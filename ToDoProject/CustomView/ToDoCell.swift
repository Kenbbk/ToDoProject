//
//  ToDoCell.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

protocol ToDoCellDelegate: AnyObject {
    func optionTapped(sender: ToDoCell, cgPoint: CGPoint)
}

class ToDoCell: UITableViewCell {
    
    //MARK: - Properties
    
    var isDone = false {
        didSet {
            
            if isDone {
                label.attributedText = label.attributedText?.strikeThrough()
            } else {
                label.attributedText = label.attributedText?.removeStrikeThrough()
            }
        }
    }
    
    static let identifier = "ToDoCell"
    
    weak var delegate: ToDoCellDelegate?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Todo"
        label.textColor = .gray
        
        return label
    }()
    
    private lazy var optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "OptionImage")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(optionImageTapped(_:))))
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc private func optionImageTapped(_ gesture: UITapGestureRecognizer) {
        
        let location = convert(optionImageView.frame.origin, to: self.superview?.superview)
        delegate?.optionTapped(sender: self, cgPoint: location)
        //        viewModel?.toDo
        //
        
        //        label.attributedText = "asdasdad".strikeThrough()
        
    }
    
    //MARK: - Helpers
    
    //MARK: - UI
    
    private func configureUI() {
        
        contentView.addSubview(optionImageView)
        optionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            optionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            optionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            optionImageView.heightAnchor.constraint(equalToConstant: 40),
            optionImageView.widthAnchor.constraint(equalToConstant: 40)
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
}
