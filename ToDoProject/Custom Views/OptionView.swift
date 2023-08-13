//
//  OptionView.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/11.
//

import UIKit

protocol OptionViewDelegate: AnyObject {
    func optionTableTapped(row: Int, connectedCell: ToDoCell)
}

class OptionView: UIView {
    
    //MARK: - Properties
    
    enum Section {
        case main
    }
    
    var connectedCell: ToDoCell? {
        didSet {
            configureDataSource()
            applySnapshot()
        }
    }
    
    weak var delegate: OptionViewDelegate?
    
    var location = CGPoint() {
        didSet {
            containerView.frame = CGRect(x: location.x - 84, y: location.y, width: 120, height: 150)
        }
    }
    
    private let containerView: UIView = {
       let view = UIView()
        
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.masksToBounds = false
        
        return view
    }()
    
    private lazy var OptionTableView: UITableView = {
        let tb = UITableView()

        tb.rowHeight = 50
        tb.delegate = self
        tb.isScrollEnabled = false
        tb.backgroundColor = .white
        tb.layer.cornerRadius = 10
        tb.separatorStyle = .singleLine
        tb.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tb.clipsToBounds = true
        
        return tb
    }()
    
    var dataSource: UITableViewDiffableDataSource<Section, UUID>!
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        addGestureOnBigView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc private func bigViewTapped(_ gesture: UITapGestureRecognizer) {
        isHidden = true
    }
    
    //MARK: - Helpers
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems([UUID(), UUID(), UUID(), UUID()])
        dataSource.apply(snapshot)
    }
    
    private func addGestureOnBigView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(bigViewTapped(_:)))
        gesture.delegate = self
        addGestureRecognizer(gesture)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: OptionTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = Optioncell()
            cell.configureCell(index: indexPath.row, isDone: self.connectedCell!.isDone)
            
            return cell
        })
    }
    
    //MARK: - UI
    
    private func configureUI() {
        configureSelf()
        configureContainerView()
        configureTableView()
    }
    
    private func configureSelf() {
        isUserInteractionEnabled = true
        isHidden = true
    }
    
    private func configureContainerView() {
        addSubview(containerView)
    }
    
    private func configureTableView() {
        addSubview(OptionTableView)
        OptionTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            OptionTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            OptionTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            OptionTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            OptionTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

//MARK: - TableView Delegate

extension OptionView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("!!!!!")
        tableView.deselectRow(at: indexPath, animated: true)
        guard let connectedCell else { return }
        delegate?.optionTableTapped(row: indexPath.row, connectedCell: connectedCell)
        isHidden = true
    }
}

//MARK: - Gesutre Delegate

extension OptionView: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        
        return !OptionTableView.frame.contains(location)
    }
}
