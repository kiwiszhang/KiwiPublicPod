//
//  Store.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/7/31.
//

import UIKit
import Foundation
import StoreKit

// plist 文件中配置的内容
struct InfoItem: Codable {
    let icon: String
    let price: String
    let desc: String
}

// 自定义转换后的模型
struct ProductItem {
    // 商品
    let product: Product
    // 商品信息在plist中配置
    let info:InfoItem
    // 是否购买
    let isPurchased: Bool
}

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

// 定义应用的订阅权限等级，按服务级别排序，最高级别的服务在前
// 数值级别与StoreKit配置文件或App Store Connect中配置的订阅级别匹配
public enum ServiceEntitlement: Int, Comparable {
    case notEntitled = 0
    
    case pro = 1
    case premium = 2
    case standard = 3
    
    init?(for product: Product) {
        // 产品必须是订阅才能有服务权限
        guard let subscription = product.subscription else {
            return nil
        }
        if #available(iOS 16.4, *) {
            self.init(rawValue: subscription.groupLevel)
        } else {
            // FIXME: zzq---实际开发需要修改为订阅ID
            switch product.id {
            case "com.tayue.chatinfotest.subscriptions.weekly9.99":
                self = .standard
            case "com.tayue.chatinfotest.subscriptions.month29.99":
                self = .premium
            case "com.tayue.chatinfotest.subscriptions.year69.99":
                self = .pro
            default:
                self = .notEntitled
            }
        }
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        // 订阅组级别按降序排列
        return lhs.rawValue > rhs.rawValue
    }
}


class Store: ObservableObject {
    static let shared = Store()
    // 产品分类
    /// 消耗品
    @Published private(set) var consumables: [ProductItem]
    /// 非消耗品
    @Published private(set) var nonConsumabls: [ProductItem]
    /// 自动订阅产品
    @Published private(set) var subscriptions: [ProductItem]
    /// 非自动订阅产品
    @Published private(set) var nonRenewables: [ProductItem]
    
    // 已购买产品状态
    @Published private(set) var purchasedNonConsumabls: [Product] = []
    @Published private(set) var purchasedNonRenewableSubscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: Product.SubscriptionInfo.Status?
    
    // 交易监听任务
    var updateListenerTask: Task<Void, Error>? = nil

    // 产品ID到表情映射字典
    private let productIdToInfo: [String: Dictionary<String, Any>]

    private init() {
        // 从配置文件加载产品ID到表情的映射
        productIdToInfo = Store.loadProductIdToInfoData()

        // 初始化空产品列表，然后异步执行产品请求来填充它们
        consumables = []
        nonConsumabls = []
        subscriptions = []
        nonRenewables = []

        // 尽可能早地启动交易监听器，以免错过任何交易
        updateListenerTask = listenForTransactions()

        Task {
            // 在商店初始化期间，从App Store请求产品
            await requestProducts()

            // 交付用户购买的产品
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        // 在类销毁时取消交易监听任务
        updateListenerTask?.cancel()
    }
    
    // 加载产品plist
    static func loadProductIdToInfoData() -> [String: Dictionary<String, Any>] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: Dictionary<String, Any>] else {
            return [:]
        }
        return data
    }
    // 按价格排序产品
    func sortByPrice(_ items: [ProductItem]) -> [ProductItem] {
        return items.sorted { $0.product.price < $1.product.price }
    }
    
    //交易监听实现
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // 迭代处理所有不是直接来自`purchase()`调用的交易
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // 向用户交付产品
                    await self.updateCustomerProductStatus()

                    // 始终完成交易
                    await transaction.finish()
                } catch {
                    // StoreKit有一个验证失败的交易。不要向用户交付内容
                    print("Transaction failed verification.")
                }
            }
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // 检查JWS是否通过StoreKit验证
        switch result {
        case .unverified:
            // StoreKit解析了JWS，但验证失败
            throw StoreError.failedVerification
        case .verified(let safe):
            // 结果已验证。返回解包的值
            return safe
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            // 使用`Products.plist`文件定义的标识符从App Store请求产品
            let storeProducts = try await Product.products(for: productIdToInfo.keys)
            
            // 模型转换
            var items: [ProductItem] = []
            for product in storeProducts {
                //判断是否已经购买
                let purchased = try? await isPurchased(product)
                let item = ProductItem(product: product, info: decode(InfoItem.self, from: productIdToInfo[product.id]!)!, isPurchased: purchased!)
                items.append(item)
            }
        
            var newNonConsumables: [ProductItem] = []
            var newSubscriptions: [ProductItem] = []
            var newNonRenewables: [ProductItem] = []
            var newConsumables: [ProductItem] = []

            // 根据类型将产品分类
            for product in items {
                switch product.product.type {
                case .consumable:
                    newConsumables.append(product)
                case .nonConsumable:
                    newNonConsumables.append(product)
                case .autoRenewable:
                    newSubscriptions.append(product)
                case .nonRenewable:
                    newNonRenewables.append(product)
                default:
                    // 忽略此产品
                    print("Unknown product.")
                }
            }

            // 按价格从低到高对每个产品类别进行排序，以更新商店
            nonConsumabls = sortByPrice(newNonConsumables)
            subscriptions = sortByPrice(newSubscriptions)
            nonRenewables = sortByPrice(newNonRenewables)
            consumables = sortByPrice(newConsumables)
        } catch {
            print("Failed product request from the App Store server. \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        // 开始购买用户选择的`Product`
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            // 检查交易是否已验证。如果没有，
            // 此函数会重新抛出验证错误
            let transaction = try checkVerified(verification)

            // 交易已验证。向用户交付内容
            await updateCustomerProductStatus()

            // 始终完成交易
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func isPurchased(_ product: Product) async throws -> Bool {
        // 确定用户是否购买了给定产品
        switch product.type {
        case .nonRenewable:
            return purchasedNonRenewableSubscriptions.contains(product)
        case .nonConsumable:
            return purchasedNonConsumabls.contains(product)
        case .autoRenewable:
            return purchasedSubscriptions.contains(product)
        default:
            return false
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedConsumabls: [Product] = []
        var purchasedSubscriptions: [Product] = []
        var purchasedNonRenewableSubscriptions: [Product] = []

        // 迭代用户购买的所有产品
        for await result in Transaction.currentEntitlements {
            do {
                // 检查交易是否已验证。如果没有，捕获`failedVerification`错误
                let transaction = try checkVerified(result)

                // 检查交易的`productType`并从商店获取相应的产品
                switch transaction.productType {
                case .nonConsumable:
                    if let consumablsItem = nonConsumabls.first(where: { $0.product.id == transaction.productID }) {
                        purchasedConsumabls.append(consumablsItem.product)
                    }
                case .nonRenewable:
                    if let nonRenewable = nonRenewables.first(where: { $0.product.id == transaction.productID }){
                        // FIXME: zzq---实际开发需要修改的地方
                        // FIXME: zzq---currentDate这个值在实际开发中需要从服务器获取？
                        // 非续期订阅没有固有的过期日期，所以`Transaction.currentEntitlements`
                        // 在用户购买后始终包含它们
                        let currentDate = Date()
                        let duration: DateComponents
                        switch transaction.productID {
                            case "com.tayue.chatinfotest.nonsubscriptions.mounth.19.99":
//                                duration = DateComponents(month: 1)
                                duration = DateComponents(minute: 1)
                            case "com.tayue.chatinfotest.nonsubscriptions.halfyear.29.99":
                                duration = DateComponents(month: 6)
                            case "com.tayue.chatinfotest.nonsubscriptions.year.49.99":
                                duration = DateComponents(year: 1)
                            default:
                                duration = DateComponents(month: 1)
                        }
                        let expirationDate = Calendar(identifier: .gregorian)
                            .date(byAdding: duration, to: transaction.purchaseDate)!
                        
                        if currentDate < expirationDate {
                            purchasedNonRenewableSubscriptions.append(nonRenewable.product)
                        }
                    }
                case .autoRenewable:
                    // FIXME: zzq----这里的订阅要更改
                    if let subscription = subscriptions.first(where: { $0.product.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription.product)
                    }
                default:
                    break
                }
            } catch {
                print()
            }
        }

        // 使用购买的产品更新商店信息
        self.purchasedNonConsumabls = purchasedConsumabls
        self.purchasedNonRenewableSubscriptions = purchasedNonRenewableSubscriptions

        // 使用自动续期订阅产品更新商店信息
        self.purchasedSubscriptions = purchasedSubscriptions

        // 检查`subscriptionGroupStatus`以了解自动续期订阅状态，确定客户
        // 是新客户（从未订阅）、活跃客户还是非活跃客户（订阅已过期）
        // 此应用只有一个订阅组，因此subscriptions数组中的产品都属于同一组
        // 客户只能订阅订阅组中的一个产品
        // `product.subscription.status`返回的状态适用于整个订阅组
        subscriptionGroupStatus = try? await subscriptions.first?.product.subscription?.status.max { lhs, rhs in
            // 由于此应用支持家庭共享，可能有多个家庭成员的不同状态
            // 订阅者有权获得服务级别最高的状态
            let lhsEntitlement = entitlement(for: lhs)
            let rhsEntitlement = entitlement(for: rhs)
            return lhsEntitlement < rhsEntitlement
        }
    }

    // 使用产品ID获取订阅的服务级别
    func entitlement(for status: Product.SubscriptionInfo.Status) -> ServiceEntitlement {
        // 如果状态是过期的，则客户没有权限
        if status.state == .expired || status.state == .revoked {
            return .notEntitled
        }
        // 获取与订阅状态关联的产品
        let productID = status.transaction.unsafePayloadValue.productID
        guard let product = subscriptions.first(where: { $0.product.id == productID }) else {
            return .notEntitled
        }
        // 最后，获取此产品对应的权限
        return ServiceEntitlement(for: product.product) ?? .notEntitled
    }
    
    /// 字典转模型
    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary)
            let model = try JSONDecoder().decode(type, from: data)
            return model
        } catch {
            print("转换失败: \(error)")
            return nil
        }
    }
}

