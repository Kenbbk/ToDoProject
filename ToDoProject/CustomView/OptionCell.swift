//
//  OptionCell.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import UIKit

class Optioncell: UITableViewCell {
 
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Todo"
        label.textColor = .gray
        return label
    }()
    
    var optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "OptionImage")
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        contentView.addSubview(optionImageView)
        optionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            optionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            optionImageView.heightAnchor.constraint(equalToConstant: 40),
            optionImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
