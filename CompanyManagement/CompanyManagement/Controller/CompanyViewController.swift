//
//  CompanyViewController.swift
//  CompanyManagement
//
//  Created by Ogün Birinci on 17.11.2022.
//

import UIKit

final class CompanyViewController: UIViewController {
    
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var budgetAmountLabel: UILabel!
    @IBOutlet private weak var incomeOrExpenseTextField: UITextField!
    @IBOutlet private weak var salaryPaymentAmountLabel: UILabel!
    
    private var company = CompanyImpl(name: "Birinci Fam", employees: [], budget: 20_000, foundationYear: 1999)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyNameLabel.text = company.name
        budgetAmountLabel.text = "\(company.budget) $"
        salaryPaymentAmountLabel.text = "\(company.totalSalaries) $"
    }
    
    private func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func addIncome(_ sender: Any) {
        //Buradaki inputu ele almayı sor.
        guard incomeOrExpenseTextField.text != "" else {
            self.showAlert(title: "Income not added", message: "Text field can not be empty.")
            return
        }
        let doubleValue = Double(incomeOrExpenseTextField.text!)
        company.add(income: doubleValue ?? 0.0) { result in
            switch result {
            case .success(let budget):
                self.budgetAmountLabel.text = "\(budget) $"
                self.incomeOrExpenseTextField.text = ""
                self.showAlert(title: "Income added", message: "New budget is: \(budget)")

            case .failure(let error):
                self.showAlert(title: "Income not added", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func addExpense(_ sender: Any) {
        guard incomeOrExpenseTextField.text != "" else {
            self.showAlert(title: "Expense not added", message: "Text field can not be empty.")
            return
        }
        let doubleValue = Double(incomeOrExpenseTextField.text!)
        company.add(expense: doubleValue ?? 0.0) { result in
            switch result {
            case .success(let budget):
                self.budgetAmountLabel.text = "\(budget) $"
                self.incomeOrExpenseTextField.text = ""
                self.showAlert(title: "Expense added", message: "New budget is: \(budget)")

            case .failure(let error):
                self.showAlert(title: "Expense not added", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func paySalaries(_ sender: Any) {
        if (company.employees?.isEmpty)! {
            showAlert(title: "No Employee", message: "There is no employee to pay salary.")
            return
        }
        company.paySalaries { result in
            switch result {
            case .success(let budget):
                self.budgetAmountLabel.text = "\(budget) $"
                self.showAlert(title: "Salaries paid.", message: "New budget is: \(budget)")
            case .failure(let error):
                self.showAlert(title: "Salaries not paid.", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func navigateShowEmployees(_ sender: Any) {
        if (company.employees?.isEmpty)! {
            self.showAlert(title: "No employee", message: "There is no employee to list.")
            return
        }
        
        guard let showEmployeesView = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeListViewController") as? EmployeeListViewController else {
            fatalError("View Controller not found")
        }
        showEmployeesView.employees = company.employees
        navigationController?.pushViewController(showEmployeesView, animated: true)
    }
    
    @IBAction private func navigateToAddNewEmployee(_ sender: Any) {
        guard let addEmployeeView = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeAddViewController") as? EmployeeAddViewController else {
            fatalError("View Controller not found")
        }
        addEmployeeView.company = company
        addEmployeeView.delegate = self
        navigationController?.pushViewController(addEmployeeView, animated: true)
    }
    
}

extension CompanyViewController: EmployeeAddViewControllerDelegate {
    func didAddNewEmployeee(_ employee: EmployeeImpl) {
        salaryPaymentAmountLabel.text = "\(company.totalSalaries) $"
    }
}
