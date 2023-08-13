//
//  UserDefaultService.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/13.
//

import Foundation

enum PersistentError: Error {
    case noData
    case failFromDefault
}

protocol PersistentManager {
    func save(toDos: [Todo])
    func fetch() throws -> [Todo]
}

struct UserDefaultService: PersistentManager {
    
    let key = "todos"
    func save(toDos: [Todo]) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(toDos)
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
            return try JSONDecoder().decode([Todo].self, from: data)
        } catch {
            throw PersistentError.failFromDefault
        }
        
    }
}
