//
//  SortingService.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import Foundation

class SortingService {
    
    func sortInDateOrder(toDoList: [Todo]) -> [Todo] {
        return toDoList.sorted { $0.date > $1.date}
    }
}
