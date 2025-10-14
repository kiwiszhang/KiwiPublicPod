//
//  PersistenceController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/15.
//


import CoreData
import UIKit

final class CoerDataPersistenceController {

    static let shared = CoerDataPersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataTest") // 这里填你的 .xcdatamodeld 名字
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ 加载数据库失败: \(error)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

class CoreDataManager {
    static let shared = CoreDataManager()
    let context: NSManagedObjectContext
    
    private init() {
        context = CoerDataPersistenceController.shared.container.viewContext
    }
    
    // MARK: - Create
    func createPerson(name: String, age: String) -> Person {
        let person = Person(context: context)
        person.id = UUID()
        person.name = name
        person.age = age
        saveContext()
        return person
    }
    
    func createPet(name: String, type: String, owner: Person) -> Pet {
        let pet = Pet(context: context)
        pet.id = UUID()
        pet.name = name
        pet.type = type
        pet.owner = owner
        saveContext()
        return pet
    }
    
    // MARK: - Read
    func fetchPersons() -> [Person] {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchPersons(contains:String) -> [Person] {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", contains)
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchPets(for person: Person) -> [Pet] {
        return person.pets?.allObjects as? [Pet] ?? []
    }
    
    // MARK: - Update
    func updatePerson(person: Person, newName: String? = nil, newAge: String? = nil) {
        if let newName = newName {
            person.name = newName
        }
        if let newAge = newAge {
            person.age = newAge
        }
        saveContext()
    }
    
    func updatePet(pet: Pet, newName: String? = nil, type: String? = nil) {
        if let newName = newName {
            pet.name = newName
        }
        if let type = type {
            pet.type = type
        }
        saveContext()
    }
    
    // MARK: - Delete
    func deletePerson(person: Person) {
        context.delete(person)
        saveContext()
    }
    
    func deletePet(pet: Pet) {
        context.delete(pet)
        saveContext()
    }
    
    // MARK: - Save
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ CoreData 保存失败: \(error)")
            }
        }
    }
}
