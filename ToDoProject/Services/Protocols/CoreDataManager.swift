//
//  CoreDataManager.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/09/22.
//

import Foundation
import CoreData

class CoreDataManager: PersistentManager {
    
    lazy var context = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TodoCore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save(toDo: Todo) {
        
        let todoCore = TodoCore(context: persistentContainer.viewContext)
        todoCore.date = toDo.date
        todoCore.done = toDo.done
        todoCore.doneDate = toDo.doneDate
        todoCore.title = toDo.title
        todoCore.uuid = toDo.uuid
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    func fetch() throws -> [Todo] {
        let request = NSFetchRequest<TodoCore>(entityName: "TodoCore")
        let toDosCore = try persistentContainer.viewContext.fetch(request)
        let toDos = toDosCore.map {
            Todo(title: $0.title!, done: $0.done, date: $0.date!, uuid: $0.uuid!, doneDate: $0.doneDate)
        }
        return toDos
    }
    
    func delete(todo: Todo) {

        do {
            let selectedObject = try identifyTodoCore(todo: todo)
            print(selectedObject.title, "@@@@@@")
            context.delete(selectedObject)
            try context.save()
            
        } catch {
            print(error)
        }
        
        
        
    }
    
    func update(todo: Todo) {
        
            delete(todo: todo)
            save(toDo: todo)
            
    }
    
    private func identifyTodoCore(todo: Todo) throws -> TodoCore {
        let request = NSFetchRequest<TodoCore>(entityName: "TodoCore")
        let uuid = todo.uuid
        
        let filter = NSPredicate(format: "uuid == %@", uuid)
        request.predicate = filter
        
        let selectedObject = try persistentContainer.viewContext.fetch(request).first!
        
        return selectedObject
        
    }
    
    private func convertToCoreEntity(todo: Todo) -> TodoCore {
        let todoCore = TodoCore(context: persistentContainer.viewContext)
        todoCore.date = todo.date
        todoCore.done = todo.done
        todoCore.doneDate = todo.doneDate
        todoCore.title = todo.title
        todoCore.uuid = todo.uuid
        return todoCore
    }
}
//        do {
//            //            try persistentContainer.viewContext.save()
//            let request = NSFetchRequest<TodoCore>(entityName: "TodoCore")
//            let fetchedTodos = try persistentContainer.viewContext.fetch(request)
//            for item in fetchedTodos {
//                print(item.title)
//            }
//
//        } catch {
//            print(error)
//        }

//            let newEntity = NSEntityDescription.insertNewObject(forEntityName: "TodoCore", into: persistentContainer.viewContext) as! TodoCore
//            newEntity.setValue(todo.date, forKey: "date")
//            newEntity.setValue(todo.done, forKey: "done")
//            newEntity.setValue(todo.doneDate, forKey: "doneDate")
//            newEntity.setValue(todo.title, forKey: "title")
//            newEntity.setValue(todo.uuid, forKey: "uuid")
//
//
//        }
////        let request = NSFetchRequest<TodoCore>(entityName: "TodoCore")
////        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoCore")
////        let a = try! persistentContainer.viewContext.fetch(request)
//        let request = NSFetchRequest<TodoCore>(entityName: "TodoCore")
//
//            let todoCore = NSEntityDescription.insertNewObject(forEntityName: "TodoCore", into: self.persistentContainer.viewContext) as! TodoCore
////            let todoCore = TodoCore(entity: NSEntityDescription.insertNewObject(forEntityName: "TodoCore", into: <#T##NSManagedObjectContext#>), insertInto: <#T##NSManagedObjectContext?#>)
////            let todoCore = TodoCore(context: persistentContainer.viewContext)
//
//            todoCore.date = $0.date
//            todoCore.done = $0.done
//            todoCore.doneDate = $0.doneDate
//            todoCore.title = $0.title
//            todoCore.uuid = $0.uuid
//            return todoCore

//        let hello = toDos.map { }
//        persistentContainer.viewContext.


//    func fetch() throws -> [Todo] {
//
//    }
//


