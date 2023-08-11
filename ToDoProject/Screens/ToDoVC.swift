//
//  ToDoVC.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class ToDoVC: UIViewController {
    
    
    //MARK: - Properties
    
    var section: [String] = []
    
    private var toDoRepository: TodoRepository!
    
    private var localRepo: [Todo] = [] {
        didSet {
            print("Sorted")
            self.localRepo.sort { $0.date > $1.date }
            applySnapShot()
        }
    }
    
    
    
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
        configureOptionView()
        configureDataSource()
        applySnapShot()
        
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
            self.localRepo.append(Todo)
            
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
    
    private func applySnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Todo>()
        section = SectionService().makeStringSection(toDos: localRepo)
        snapshot.appendSections(section)
        
        let tupleResult = ItemService().makeItemIdentifier(toDos: localRepo)
        for (toDo, stringDate) in tupleResult {
            snapshot.appendItems([toDo], toSection: stringDate)
        }
        
        datasource.apply(snapshot)
    }
    
//    private func updateSnapshot() {
//        var snapshot = NSDiffableDataSourceSnapshot<String, Todo>()
//        let sectionString = SectionService().makeStringSection(toDos: localRepo)
//        section = sectionString
//        snapshot.appendSections(section)
//
//
//    }
    
    //    private func applyOldSnapshot(toDo: Todo) {
    //        var oldSnapshot = datasource.snapshot()
    //        let tuple = ItemService().makeItemIdentifier(toDo: toDo)
    //
    //        if oldSnapshot.sectionIdentifiers.contains(tuple.1) {
    //
    //            if let first = oldSnapshot.itemIdentifiers(inSection: tuple.1).first {
    //                oldSnapshot.insertItems([toDo], beforeItem: first)
    //            }
    //
    //        } else {
    //
    //            if let first = oldSnapshot.sectionIdentifiers.first {
    //
    //                print(tuple.1)
    ////                oldSnapshot.appendSections([tuple.1])
    //
    //                oldSnapshot.insertSections([tuple.1], beforeSection: first)
    //                oldSnapshot.appendItems([toDo], toSection: tuple.1)
    //                print("1")
    //            } else {
    //
    //                oldSnapshot.appendSections([tuple.1])
    //                oldSnapshot.appendItems([toDo], toSection: tuple.1)
    //                print("2")
    //            }
    //
    //        }
    //
    //        section.insert(tuple.1, at: 0)
    ////        if let first = oldSnapshot.itemIdentifiers.first {
    ////            oldSnapshot.insertItems([toDo], beforeItem: first)
    ////        } else {
    ////            oldSnapshot.appendItems([toDo])
    ////        }
    //
    //        datasource.apply(oldSnapshot)
    //    }
    //
    //
    //}
}
extension ToDoVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Tapped")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        guard !datasource.snapshot().sectionIdentifiers.isEmpty else { return nil }
        print(self.section)
        //        view.textLabel?.text = self.section[section]
        view.textLabel?.text = datasource.snapshot().sectionIdentifiers[section]
        return view
    }
    
}

extension ToDoVC: ToDoCellDelegate {
    func optionTapped(sender: ToDoCell, cgPoint: CGPoint) {
        print("Tapped")
        guard let index = self.tableView.indexPath(for: sender) else { return }
        
//        let toDo = localRepo[index.row]
        let toDo = datasource.snapshot().itemIdentifiers(inSection: datasource.snapshot().sectionIdentifiers[index.section])[index.row]
//        let toDo = datasource.snapshot().itemIdentifiers(inSection: a)[index.row]
        print(index.section)
//        toDoRepository.checkToggle(toDo: toDo)
        toDo.done.toggle()
        toDo.doneDate = Date()
        print(toDo.uuid, toDo.done, toDo.doneDate)
                
        optionView.location = cgPoint
        optionView.isHidden = false
    }
}

extension ToDoVC: OptionViewDelegate {
    func optionTableTapped(row: Int) {
        print("Message well arrived" , row)
    }
}




