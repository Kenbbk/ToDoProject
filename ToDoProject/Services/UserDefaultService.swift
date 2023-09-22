//
//  UserDefaultService.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/13.
//

import Foundation

struct UserDefaultService: PersistentManager {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    let key = "todos"
    
    func save(toDo: Todo) {
        do {
            var originalTodos = try fetch()
            originalTodos.append(toDo)
            let data = try encoder.encode(originalTodos)
            UserDefaults.standard.set(data, forKey: key)
            print("Data saved")
        } catch {
            print(error)
        }
    }
    
    func fetch() throws -> [Todo] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            throw PersistentError.noData
        }
        
        do {
            return try decoder.decode([Todo].self, from: data)
        } catch {
            throw PersistentError.failFromDefault
        }
    }
    
    func delete(todo: Todo) {
        do {
            var originalTodos = try fetch()
            guard let index = originalTodos.firstIndex(of: todo) else { return }
            originalTodos.remove(at: index)
            let data = try encoder.encode(originalTodos)
            UserDefaults.standard.set(data, forKey: key)
            
        } catch {
            print(error)
        }
    }
    
    func update(todo: Todo) {
        do {
            var originalTodos = try fetch()
            guard let index = originalTodos.firstIndex(of: todo) else { return }
            originalTodos[index] = todo
            let data = try encoder.encode(originalTodos)
            UserDefaults.standard.set(data, forKey: key)
            
        } catch {
            print(error)
        }
    }
    
    //    func save(toDos: Todo) {
    //
    //    }
    //
    //
    //    let key = "todos"
    //[1,2,3,4,5,6,7,8]
    //    func save(toDos: [Todo]) {
    //        let encoder = JSONEncoder()
    //
    //        do {
    //            let data = try encoder.encode(toDos)
    //            UserDefaults.standard.set(data, forKey: key)
    //            print("Data saved")
    //
    //        } catch {
    //            print(error)
    //        }
    //    }
    //
    //    func fetch() throws -> [Todo] {
    //
    //        guard let data = UserDefaults.standard.data(forKey: key) else {
    //            throw PersistentError.noData
    //        }
    //
    //        do {
    //            return try JSONDecoder().decode([Todo].self, from: data)
    //        } catch {
    //            throw PersistentError.failFromDefault
    //        }
    //
    //    }
    //}
    
    
}
