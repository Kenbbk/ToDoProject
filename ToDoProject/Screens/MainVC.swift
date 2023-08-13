//
//  MainVC.swift
//  ToDoProject
//
//  Created by Woojun Lee on 2023/08/10.
//

import UIKit

class MainVC: UIViewController {
    
    //MARK: - Properties
    
    private let userDefaultService = UserDefaultService()
    
    private lazy var toDoRepository = TodoRepository(persistentManager: userDefaultService)
    
    
    
    private var gray: UIColor {
        return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
    }
    
    let green = UIColor(red: 25/255, green: 90/255, blue: 59/255, alpha: 1)
    
    private var black = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1)
    
    
    private lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.register(MarkCell.self, forCellReuseIdentifier: MarkCell.identifier)
        tb.backgroundColor = .clear
        tb.delegate = self
        tb.dataSource = self
                tb.isScrollEnabled = false
        return tb
    }()
    
    var gradientView: UIView!
    
    private let toDoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientView()
        
        configureTableView()
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    private func pushToNextVC(row: Int) {
        
        let vc = row == 0 ? ToDoVC(toDoRepository: toDoRepository, persistentManager: userDefaultService) : DoneVC(toDoRepository: toDoRepository)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - UI
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalToConstant: 200),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func configureToDoView() {
        view.addSubview(toDoView)
        toDoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toDoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toDoView.widthAnchor.constraint(equalToConstant: 100),
            toDoView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func configureGradientView() {
        gradientView = UIView(frame: view.frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [green.cgColor, gray.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        view.addSubview(gradientView)
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToNextVC(row: indexPath.row)
        
    }
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MarkCell()
        
        cell.setText(row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


