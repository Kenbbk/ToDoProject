//
//  OptionView.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import UIKit

protocol OptionViewDelegate: AnyObject {
    func optionTableTapped(row: Int)
}

class OptionView: UIView {
    
    enum Section {
        case main
    }
    
    weak var delegate: OptionViewDelegate?
    
    var location = CGPoint() {
        didSet {
            OptionTableView.frame = CGRect(x: location.x - 90, y: location.y, width: 120, height: 150)
        }
    }
    
    private lazy var OptionTableView: UITableView = {
        let tb = UITableView(frame: CGRect(x: 100, y: 300, width: 120, height: 150))
        tb.backgroundColor = .white
        tb.rowHeight = 50
        tb.delegate = self
        tb.isScrollEnabled = false
        tb.layer.cornerRadius = 10
        tb.layer.borderColor = UIColor.black.cgColor
        tb.layer.borderWidth = 0.3
        tb.layer.masksToBounds = false
        tb.layer.shadowColor = UIColor.blue.cgColor
        tb.layer.shadowOpacity = 1
        tb.layer.shadowRadius = 1
        tb.layer.shadowOffset = .zero
        tb.layer.shadowPath = nil
//        tb.layer.masksToBounds = true
        return tb
    }()
    
    var dataSource: UITableViewDiffableDataSource<Section, UUID>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print(OptionTableView.layer.masksToBounds)
        isUserInteractionEnabled = true
        isHidden = true
        configureTableView()
        configureDataSource()
        applySnapshot()
        addGestureOnBigView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func bigViewTapped(_ gesture: UITapGestureRecognizer) {
        
        isHidden = true
    }
    
    private func addGestureOnBigView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(bigViewTapped(_:)))
        gesture.delegate = self
        addGestureRecognizer(gesture)
    }
    
    private func configureTableView() {
        addSubview(OptionTableView)
        bringSubviewToFront(OptionTableView)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: OptionTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = Optioncell()
            cell.layer.masksToBounds = false
            if indexPath.row == 0 {
                cell.label.text = "asdjlkasjdlkqwjelkjqwlkejqwlkjdlkasjldkajsldkajsldkajsdlkajsldkasjlkdjaskldjlkasjdlkasjdklsjadkljaslkdjlaksdjlkasjdlkasdj"
                cell.optionImageView.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
            }
            
            return cell
        })
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems([UUID(), UUID(), UUID(), UUID()])
        dataSource.apply(snapshot)
    }
    
}

extension OptionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("!!!!!")
        delegate?.optionTableTapped(row: indexPath.row)
        isHidden = true
    }
}

extension OptionView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        
        return !OptionTableView.frame.contains(location)
    }
}
