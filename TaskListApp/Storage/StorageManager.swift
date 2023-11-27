//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Денис Хафизов on 27.11.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    private let context: NSManagedObjectContext
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    func fetchData(completion: @escaping([Task]) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let task = try context.fetch(fetchRequest)
            completion(task)
        } catch {
            print(error)
        }
    }
    
    func save(title: String, completion: @escaping(Task) -> Void) {
        let task = Task(context: context)
        task.title = title
        completion(task)
        saveContext()
    }
    
    func delete(task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func updata(title: String, task: Task, completion: @escaping(Task) -> Void) {
        task.title = title
        completion(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
