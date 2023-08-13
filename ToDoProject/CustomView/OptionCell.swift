//
//  OptionCell.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import UIKit

class Optioncell: UITableViewCell {
    
    static let identifier = "Optioncell"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "완료"
        label.textColor = .gray
        return label
    }()
    
    var optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.tintColor = .systemGray2
        iv.image = UIImage(named: "OptionImage")
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
        
        selectionStyle = .none
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        contentView.addSubview(optionImageView)
        optionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            optionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            optionImageView.heightAnchor.constraint(equalToConstant: 20),
            optionImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.heightAnchor.constraint(equalToConstant: 40),
            label.trailingAnchor.constraint(equalTo: optionImageView.leadingAnchor, constant: -5)
        ])
    }
    
    func configureCell(index: Int, isDone: Bool) {
        setText(index: index, isDone: isDone)
        setIcon(index: index)
    }
    
    
}

extension Optioncell {
    
    private func setText(index: Int, isDone: Bool) {
        switch index {
        case 0: label.text = isDone ? "안완료" : "완료"
        case 1: label.text = "수정"
        case 2: label.text = "삭제"
        default:
            return
        }
    }
    
    private func setIcon(index: Int) {
        switch index {
        case 0: optionImageView.image = UIImage(systemName: "checkmark")
        case 1: optionImageView.image = UIImage(systemName: "pencil")
        case 2: optionImageView.image = UIImage(systemName: "trash")
        default:
            return
        }
    }
}
