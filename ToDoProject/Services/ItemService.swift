//
//  ItemService.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import Foundation

class ItemService {
    
    func makeItemIdentifier(toDos: [Todo]) -> [(Todo, String)] {
        var tupleResult: [(toDo :Todo, sectionString: String)] = []
        for todo in toDos {
            let stringDate = todo.date.convertToString()
            tupleResult.append(( todo, stringDate))
        }
        
        return tupleResult
    }
    
    func makeItemIdentifier(toDo: Todo) -> (Todo, String) {
        
        let stringDate = toDo.date.convertToString()
            
        return (toDo, stringDate)
    }
    
    func makeDoneItemIdentifier(toDos: [Todo]) -> [(Todo, String)] {
        var sortedToDos = toDos.sorted { $0.doneDate! < $1.doneDate! }
        var tupleResult: [(toDo :Todo, sectionString: String)] = []
        for todo in sortedToDos {
            let stringDate = todo.doneDate!.convertToString()
            tupleResult.append(( todo, stringDate))
        }
        
        return tupleResult
    }
}
