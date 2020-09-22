//
//  SearchViewController.swift
//  SpeechRecognition
//
//  Created by  Alexander on 22.09.2020.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constants {
        static let cellId = "CellId"
        static let title = "Поиск"
    }
    
    // MARK: - Properties
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let dataSource = ["Штрафы", "Курс Валют", "Карты и счета", "Переводы", "Шаблоны"].sorted()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = Constants.title
        configurateTableView()
    }
    
    // MARK: - TableView
    
    private func configurateTableView() {
        view.addSubview(tableView)
        tableView.pin(to: view)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
    }
}
    
    // MARK: - TableView Implementation

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
}
