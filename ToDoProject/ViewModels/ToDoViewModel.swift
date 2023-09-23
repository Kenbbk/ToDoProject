//
//  ToDoViewModel.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/09/23.
//

import Foundation


protocol ToDoViewModelDelegate: AnyObject {
    func localRepoUpdated()
}

class ToDoViewModel {
    
    weak var delgate: ToDoViewModelDelegate?
    
    private var toDoRepository: TodoRepository
    
    var persistentManager: PersistentManager
    
    private var localRepo: [Todo] = [] {
        didSet {
            print("toggle and done")
            localRepo.sort { $0.date > $1.date }
            delgate?.localRepoUpdated()
        }
    }
    
    init(toDoRepository: TodoRepository, persistentManager: PersistentManager) {
        self.toDoRepository = toDoRepository
        self.localRepo = toDoRepository.getFillterAndSorted()
        self.persistentManager = persistentManager
        
    }
    
    func addToDo(text: String) {
        let Todo = Todo(title: text)
        self.toDoRepository.addToDo(toDo: Todo)
        self.persistentManager.save(toDo: Todo)
        self.localRepo.append(Todo)
    }
    
    func editToDo(title: String, toDo: Todo) {
        if let index = self.localRepo.firstIndex(of: toDo) {
            var editedTodo = toDo
            editedTodo.title = title
            self.localRepo[index] = editedTodo
            self.toDoRepository.editToDo(toDo: editedTodo)
            self.persistentManager.update(todo: editedTodo)
            
        }
    }
    
    func toggleDoneAndSave(on toDo: Todo) {
        if let index = localRepo.firstIndex(of: toDo) {
            var editedTodo = toDo
            editedTodo.done.toggle()
            editedTodo.doneDate = Date()
            
            
            localRepo[index] = editedTodo
            toDoRepository.editToDo(toDo: editedTodo)
            persistentManager.update(todo: editedTodo)
            
        }
        
//        connectedCell.isDone.toggle()
    }
    
     func removeToDo(_ toDo: Todo) {
        toDoRepository.removeToDo(toDo)
        removeFromLocalRepo(toDo)
        persistentManager.delete(todo: toDo)
    }
    
    private func removeFromLocalRepo(_ toDo: Todo) {
        guard let index = localRepo.firstIndex(of: toDo) else { return }
        
        localRepo.remove(at: index)
    }
    
    func getSections() -> [String] {
        print("Hello")
        return SectionService().makeStringSection(toDos: localRepo)
        
    }
    
    func getItems() -> [(Todo, String)] {
        return ItemService().makeItemIdentifier(toDos: localRepo)
    }
    
}
