//
//  ToDoVC.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class ToDoVC: UIViewController {
    //MARK: - Properties
    
    private var toDoRepository: TodoRepository!
    
    private var localRepo: [Todo] = []
    
    enum Row {
        case todo(Todo)
        case date(Todo)
    }
    
    var section: [String] = []
    
//    enum Section {
//        case main
//    }
    
    private lazy var optionView: OptionView = {
        let optionView = OptionView(frame: UIScreen.main.bounds)
        optionView.delegate = self
        
        return optionView
    }()
    
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.delegate = self
        tb.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        tb.rowHeight = 60
        
        return tb
    }()
    
    var datasource: UITableViewDiffableDataSource<String, Todo>!
    
  
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "할일"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "할일 추가", style: .plain, target: self, action: #selector(addButtopTapped))
        view.backgroundColor = .systemCyan
        configureTableView()
        configureDataSource()
        applySnapshot()
        configureOptionView()
        
    }
    
    init(toDoRepository: TodoRepository) {
        super.init(nibName: nil, bundle: nil)
        self.toDoRepository = toDoRepository
        self.localRepo = toDoRepository.getFillterAndSorted()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc private func addButtopTapped() {
        print("Added Tapped")
        var textField: UITextField!
        let alert = UIAlertController(title: "할일을 추가해주세요", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            let Todo = Todo(title: textField.text!)
            self.toDoRepository.addToDo(toDo: Todo)
//            self.localRepo.append(Todo)
            self.applyOldSnapshot(toDo: Todo)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alert.addTextField { textField = $0 }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureOptionView() {
        UIApplication.shared.keyWindow?.addSubview(optionView)
//        view.addSubview(optionView)
        view.bringSubviewToFront(optionView)
    }
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
    
    private func configureDataSource() {
        datasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as! ToDoCell
            
            cell.delegate = self
            cell.label.text = itemIdentifier.title
            print("mask",cell.layer.masksToBounds)
            print("clups",cell.clipsToBounds)
            return cell
        })
    }
    
    private func applySnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Todo>()
        // todo 배열 사용해서 section만 리턴 스트링으로 포맷된 데이트
        let set = Set(localRepo.map { $0.date.convertToString() })
        section = Array(set).sorted(by: >)
        
        // 이것을 이용해서 snapshot.appendsection 다집어넣고
        snapshot.appendSections(section)
        
    // todo 데이트순에 따라 정렬 loop map { ($0 , $0.dsf )}
        // tuple  -> [(String , [Todo] )]
        for toDo in localRepo {
            let stringDate = toDo.date.convertToString()
           
            snapshot.appendItems([toDo], toSection: stringDate)
            
        }
        
//        snapshot.appendSections([]) // <-
        
        
//        let toDoList = toDoRepository.getFillterAndSorted()
//        snapshot.appendItems([todo], toSection: "sdfkjlsjl")
//        snapshot.appendItems(toDoList)
        datasource.apply(snapshot)
    }
    
    private func applyOldSnapshot(toDo: Todo) {
        var oldSnapshot = datasource.snapshot()
        let stringDate = toDo.date.convertToString()
        
        if section.contains(stringDate) {
            oldSnapshot.insertItems([toDo], beforeItem: localRepo[0])
            
            
            
        } else {
            if section.isEmpty {
                oldSnapshot.appendSections([stringDate])
                oldSnapshot.appendItems([toDo], toSection: stringDate)
            } else {
                
                oldSnapshot.insertSections([stringDate], beforeSection: section[0] )
                oldSnapshot.appendItems([toDo], toSection: stringDate)
                section.insert(stringDate, at: 0)
            }
            
            
        }
        
        localRepo.insert(toDo, at: 0)
        datasource.apply(oldSnapshot)
    }
}

extension ToDoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Tapped")
    }
}

extension ToDoVC: ToDoCellDelegate {
    func optionTapped(sender: ToDoCell, cgPoint: CGPoint) {
        print("Tapped")
        guard let index = self.tableView.indexPath(for: sender) else { return }
        let toDo = localRepo[index.row]
        toDoRepository.checkToggle(toDo: toDo)
        optionView.location = cgPoint
        optionView.isHidden = false
        
    }
    

    
    //    func optionTapped(toDo: Todo) {
    //        print("I am tapped")
    //        toDoRepository.checkToggle(toDo: toDo)
    //        var oldSnapshot = datasource.snapshot()
    //
    ////        var snapshot = NSDiffableDataSourceSnapshot<Section, Todo>()
    ////        snapshot.appendSections([.main])
    ////        let toDoList = toDoRepository.getToDoList()
    ////
    ////        snapshot.appendItems(toDoList)
    ////        datasource.apply(snapshot)
    ////
    //        oldSnapshot.reconfigureItems([toDo])
    //////        oldSnapshot.reloadItems([changedTodo!])
    //        datasource.apply(oldSnapshot)
    //    }
    
    
    
}

extension ToDoVC: OptionViewDelegate {
    func optionTableTapped(row: Int) {
        print("Message well arrived" , row)
    }
}




