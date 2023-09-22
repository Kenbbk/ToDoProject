//
//  PersistentManager.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/14.
//

import Foundation

protocol PersistentManager {
    
    func save(toDo: Todo)
    
    func fetch() throws -> [Todo]
    
    func delete(todo: Todo)
    
    func update(todo: Todo)
}
