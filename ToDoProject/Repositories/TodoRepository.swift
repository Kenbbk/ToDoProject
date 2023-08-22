//
//  TodoRepository.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import Foundation

class TodoRepository {
    
    //MARK: - Properties
    
    private let persistentManager: PersistentManager
    
    private var toDoList: [Todo] = [
        Todo(title: "test1", done: false, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, uuid: UUID().uuidString),
        Todo(title: "test2", done: false, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, uuid: UUID().uuidString)
    ]
    
    //MARK: - Helpers
    

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
    
    func toggleDoneAndSetDate(toDo: Todo) {
        if let index = toDoList.firstIndex(of: toDo) {
            toggleDone(index: index)
            setDoneDate(index: index)
        }
    }
    
    private func setDoneDate(index: Int) {
        toDoList[index].doneDate = Date()
    }
    
    private func toggleDone(index: Int) {
        toDoList[index].done.toggle()
    }
    
    //MARK: - Lifecycle
    
    init(persistentManager: PersistentManager) {
        self.persistentManager = persistentManager
        do {
            toDoList = try persistentManager.fetch()
        } catch PersistentError.noData {
            print("No data")
        } catch PersistentError.failFromDefault {
            print("Fail from default")
        } catch {
            print("Unknown")
        }
        
    }
}
