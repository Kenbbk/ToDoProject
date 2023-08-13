//
//  MarkCell.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class MarkCell: UITableViewCell {
    
    static let identifier = "MarkCell"
    
    private let markImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.circle")
        iv.tintColor = .gray
        return iv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Todo"
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            label.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        contentView.addSubview(markImageView)
        print(frame.height)
        print(contentView.frame.height)
        markImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            markImageView.heightAnchor.constraint(equalToConstant: 200 - 65),
            markImageView.widthAnchor.constraint(equalToConstant: 200 - 65)
        ])
    }
    
    func setText(row: Int) {
        if row == 0 {
            label.text = "할 일"
        } else {
            label.text = "완료한 일"
        }
    }
}
