//
//  EmployeeListViewController.swift
//  CompanyManagement
//
//  Created by Ogün Birinci on 17.11.2022.
//

import UIKit

final class EmployeeListViewController: UIViewController {

    private let searchController = UISearchController()
    @IBOutlet private weak var employeeListTableView: UITableView!
    var employees: [EmployeeImpl]?
    var filteredEmployees: [EmployeeImpl]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configureSearchController()
        configureTableView()
    }
    private func configureSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        filteredEmployees = employees
    }
    private func configureTableView() {
        employeeListTableView.register(UINib(nibName: "EmployeeTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeTableViewCell")
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
        employeeListTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}
extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEmployees!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell",for: indexPath) as? EmployeeTableViewCell {
            cell.configure(modal: filteredEmployees![indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension EmployeeListViewController: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        if !(text.isEmpty) {
            filteredEmployees = employees?.filter {
                $0.name.replacingOccurrences(of: " ", with: "").lowercased().contains(text.replacingOccurrences(of: " ", with: "").lowercased())}
            employeeListTableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        guard let text = searchBar.text else {
            return
        }
        if !(text.isEmpty) {
            filteredEmployees = employees?.filter {
                $0.name.replacingOccurrences(of: " ", with: "").lowercased().contains(text.replacingOccurrences(of: " ", with: "").lowercased())}
            employeeListTableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        filteredEmployees = employees
        employeeListTableView.reloadData()
    }
}
