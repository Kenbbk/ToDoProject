//
//  ToDo.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import Foundation

class Todo: Codable, Equatable, Hashable {
    var title: String
    var done: Bool
    let date: Date
    let uuid: String
    var doneDate: Date?
    
    
    init(title: String, done: Bool = false, date: Date = Date(), uuid: String = UUID().uuidString) {
        self.title = title
        self.done = done
        self.date = date
        self.uuid = uuid
    }
    
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
}


