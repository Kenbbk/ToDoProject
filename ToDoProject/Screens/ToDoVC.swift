//
//  ToDoVC.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class ToDoVC: UIViewController {
    
    
    //MARK: - Properties
    
    var viewModel: ToDoViewModel
    
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
    
    private lazy var datasource: UITableViewDiffableDataSource<String, Todo> = {
        let dataSource = UITableViewDiffableDataSource<String, Todo>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.identifier, for: indexPath) as! ToDoCell
            
            cell.delegate = self
            cell.label.attributedText = NSAttributedString(string: itemIdentifier.title)
            cell.isDone = itemIdentifier.done

            return cell
        }
        
        return dataSource
    }()
    
    
    //MARK: - Lifecycle
    
    init(viewModel: ToDoViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        viewModel.delgate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        applySnapShot()
        
    }
    
    //MARK: - Actions
    
    @objc private func addButtopTapped() {
        print("Added Tapped")
        var textField: UITextField!
        let alert = UIAlertController(title: "할일을 추가해주세요", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
            self.viewModel.addToDo(text: textField.text!)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alert.addTextField { textField = $0 }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: - Helpers
    
    private func applySnapShot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<String, Todo>()
                let section = viewModel.getSections()
        
        snapshot.appendSections(section)
        let tupleResult = viewModel.getItems()
        for (toDo, stringDate) in tupleResult {
            snapshot.appendItems([toDo], toSection: stringDate)
        }
        datasource.apply(snapshot, animatingDifferences: false, completion: nil)
   
    }
    
    //MARK: - UI
    
    private func configureUI() {
        title = "할일"
        configureTableView()
        configureRightBarButtonItem()
        configureOptionView()
        
    }
    
    private func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "할일 추가", style: .plain, target: self, action: #selector(addButtopTapped))
    }
    
    private func configureOptionView() {
        UIApplication.shared.keyWindow?.addSubview(optionView)
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
    
    
}

//MARK: - TableView Delegate
extension ToDoVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Tapped")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        guard !datasource.snapshot().sectionIdentifiers.isEmpty else { return nil }

        
        view.textLabel?.text = datasource.snapshot().sectionIdentifiers[section]
        
        return view
    }
}

//MARK: - ToDoCellDelegate

extension ToDoVC: ToDoCellDelegate {
    func optionTapped(sender: ToDoCell, location: CGPoint) {
        
        showOptionView(connectedCell: sender, location: location)
        
    }
}

//MARK: - OptionView Delegate
extension ToDoVC: OptionViewDelegate {
    func optionTableTapped(row: Int, connectedCell: ToDoCell) {
        
        let toDo = getSelectedToDo(connectedCell: connectedCell)
        
        if case 0 = row {
            viewModel.toggleDoneAndSave(on: toDo)
            
        }
        if case 1 = row {
            
            showEditAlert(on: toDo, with: connectedCell)
            
        }
        if case 2 = row {
            
            viewModel.removeToDo(toDo)
            
        }
    }
}

extension ToDoVC {
    
    private func showEditAlert(on toDo: Todo, with connectedCell: ToDoCell) {
        var textField: UITextField!
        let alert = UIAlertController(title: "할일을 수정해주세요", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "수정", style: .default) { action in
            
            guard let title = textField.text else { return }
            self.viewModel.editToDo(title: title, toDo: toDo)
           
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        alert.addTextField { textField = $0 }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
    }
    
    private func toggleDoneAndSave(on toDo: Todo, with connectedCell: ToDoCell) {
        viewModel.toggleDoneAndSave(on: toDo)
    }
    
    private func showOptionView(connectedCell: ToDoCell, location: CGPoint) {
        
        optionView.location = location
        optionView.connectedCell = connectedCell
        optionView.isHidden = false
    }
    
    private func getSelectedToDo(connectedCell: ToDoCell) -> Todo {
        guard let index = self.tableView.indexPath(for: connectedCell) else { fatalError( "There is no such Todo") }
        let toDo = datasource.snapshot().itemIdentifiers(inSection: datasource.snapshot().sectionIdentifiers[index.section])[index.row]
        return toDo
    }
}

extension ToDoVC: ToDoViewModelDelegate {
    func localRepoUpdated() {
        applySnapShot()
    }
    
    
}
