//
//  DoneVC.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class DoneVC: UIViewController {
    
    //MARK: - Properties
    
    private var toDoRepository: TodoRepository!
    
    private var localRepo: [Todo] = [] {
        didSet {
            print("local repo Set")
            self.localRepo.sort { $0.doneDate! > $1.doneDate! }
            print(self.localRepo)
        }
    }
    
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        tb.delegate = self
        return tb
    }()
    
    private var section: [String] = [] 
        
            
        
    
    
    private var dataSource: UITableViewDiffableDataSource<String, Todo>!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDatasource()
        applyNewSnapshot()
    }
    
    init(toDoRepository: TodoRepository) {
        super.init(nibName: nil, bundle: nil)
        
        print("I am innited")
        self.toDoRepository = toDoRepository
        self.localRepo = toDoRepository.getAllList().filter { $0.done == true }
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    private func configureDatasource() {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = UITableViewCell()
            cell.textLabel?.text = itemIdentifier.title
            return cell
        })
    }
    
    private func applyNewSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Todo>()
        
        section = SectionService().makeDoneSection(toDos: localRepo)
        
        snapshot.appendSections(section)
        
        let tupleResult = ItemService().makeDoneItemIdentifier(toDos: localRepo)
        
        for (item, sectionString) in tupleResult {
            snapshot.appendItems([item], toSection: sectionString)
        }

        dataSource.apply(snapshot)
    }
    //MARK: - UI
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DoneVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        view.textLabel?.text = self.section[section]
        return view
    }
}
