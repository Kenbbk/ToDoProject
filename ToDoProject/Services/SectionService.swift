//
//  SectionService.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import Foundation

class SectionService {
    
    func makeStringSection(toDos: [Todo]) -> [String] {
        let set = Set(toDos.map { $0.date.getStartOfDay() })
        
        let array = Array(set).sorted { $0 > $1}
        
        return array.map { $0.convertToString()}
    }
    
    func makeDoneSection(toDos: [Todo]) -> [String] {
        
        let set = Set(toDos.map { $0.doneDate!.getStartOfDay() })
        
        let array = Array(set).sorted { $0 > $1}
        
        return array.map { $0.convertToString()}
    }
}
