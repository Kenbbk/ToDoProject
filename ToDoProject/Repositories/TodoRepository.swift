//
//  TodoRepository.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import Foundation

class TodoRepository {
    
    private var toDoList: [Todo] = [
        Todo(title: "test1", done: false, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, uuid: UUID().uuidString),
        Todo(title: "test2", done: false, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, uuid: UUID().uuidString)
    ]
//    let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    func addToDo(toDo: Todo) {
        toDoList.append(toDo)
    }
    
    func removeToDo(_ toDo: Todo) {
        guard let index = toDoList.firstIndex(of: toDo) else { return }
        toDoList.remove(at: index)
    }
    
    func getAllList() -> [Todo] {
        toDoList.forEach { print($0.uuid) }
        return toDoList
    }
    
    func getFillterAndSorted() -> [Todo] {
        return toDoList
            .filter { $0.done == false }
            .sorted { $0.date > $1.date }
    }
    
    func getDoneList() -> [Todo] {
        return toDoList.filter { $0.done == true }
    }
    
//    func checkToggle(toDo: Todo) {
//        guard let index = toDoList.firstIndex(of: toDo) else { return }
//        toDoList[index].done.toggle()
//    }
}
