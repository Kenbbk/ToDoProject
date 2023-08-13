//
//  NSAttributedString+Ext.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/13.
//

import UIKit

extension NSAttributedString {
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(attributedString: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func removeStrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(attributedString: self)
        attributeString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
