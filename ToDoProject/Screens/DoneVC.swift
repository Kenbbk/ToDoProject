//
//  DoneVC.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class DoneVC: UIViewController {
    
    let button: UIButton = {
        let button =  UIButton(frame: CGRect(x: 150, y: 200, width: 100, height: 40))
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.setTitle("Button", for: .normal)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 150, y: 400, width: 100, height: 40))
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    var items: [UIAction] {
        
        let save = UIAction(
            title: "Save",
            image: UIImage(systemName: "plus"),
            handler: { [unowned self] _ in
                self.label.text = "Save"
            })
        
        let delete = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash"),
            handler: { [unowned self] _ in
                self.label.text = "Delete"
            })
        
        let Items = [save, delete]
        
        return Items
    }
    
    let myView = UIView(frame: CGRect(x: 50, y: 300, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(myView)
        myView.backgroundColor = .white
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 1
        myView.layer.shadowRadius = 1
        myView.layer.shadowOffset = .zero
        myView.layer.shadowPath = nil
        print(myView.layer.masksToBounds)
        
        //        view.addSubview(button)
        //               view.addSubview(label)
        //
        ////        let interaction = UIContextMenuInteraction(delegate: self)
        //          // 버튼의 상호작용을 추가해줍니다.
        ////          button.addInteraction(interaction)
        //        setupMenu()
    }
    
    //    func setupMenu() {
    //        let menu = UIMenu(title: "메뉴",
    //                          children: items)
    //
    //        button.menu = menu
    ////        button.showsMenuAsPrimaryAction = true
    //    }
    //
    //    @objc func buttonHandler(_ sender: UIButton) {
    //      }
    //}
    
    //extension DoneVC: UIContextMenuInteractionDelegate {
    //
    //    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    //
    //        return UIContextMenuConfiguration(actionProvider:  { [unowned self] suggestedActions in
    //
    //            let menu = UIMenu(title: "메뉴1",
    //                              children: self.items)
    //
    //            return menu
    //        })
    //    }
    //}
}
