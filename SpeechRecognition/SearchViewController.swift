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
    
    private let alertController = Alert()
    private let speech = Speech()
    private var searchText = String()
    
    private let dataSource = ["Штрафы", "Курс Валют", "Карты и счета", "Переводы", "Шаблоны"].sorted()
    private var filteredDataSource = [String]()
    private var searchBarIsEmplty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmplty
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = Constants.title
        setupTableView()
        setupSearchController()
        speech.checkStatus()
        
        alertController.recordButton.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
        alertController.keyboardButton.addTarget(self, action: #selector(keyboardPressed), for: .touchUpInside)
    }
    
    // MARK: - TableView
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pin(to: view)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = Constants.title
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.showsCancelButton = true
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func recordPressed() {
        print(#function)
        alertController.recordButton.addShadow()
        audioEngine(isRunning: speech.audioEngine!.isRunning)
    }
    
    private func audioEngine(isRunning: Bool) {
        switch isRunning {
        case true:
            speech.stopRecording()
            searchController.searchBar.text = searchText
            alertController.closeCustomVoiceActionSheet()
            updateSearchResults(for: searchController)
        case false:
            speech.startRecording { (outputText) in
                self.searchText = outputText
                self.alertController.recordedTextField.text = self.searchText + "..."
            }
        }
    }
    
    @objc private func keyboardPressed() {
        print(#function)
        alertController.closeCustomVoiceActionSheet()
        speech.stopRecording()
        searchController.searchBar.resignFirstResponder()
    }
}

    // MARK: - TableView Implementation

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredDataSource.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath)
        let cellText = isFiltering ? filteredDataSource[indexPath.row] : dataSource[indexPath.row]
        cell.textLabel?.text = cellText
        
        return cell
    }
}

    // MARK: SearchController Implementation

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text =  searchController.searchBar.text else {
            return
        }
        filterContent(text)
    }
    
    private func filterContent(_ searchText: String) {
        // регистронезависимая фильтрация
        filteredDataSource = dataSource.filter { $0.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
            alertController.showCustomVoiceActionSheet()
    }
}
