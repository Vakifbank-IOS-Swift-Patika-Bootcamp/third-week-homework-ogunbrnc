//
//  ViewController.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit

final class ZooViewController: UIViewController {
    @IBOutlet private weak var zooNameLabel: UILabel!
    @IBOutlet private weak var budgetAmountLabel: UILabel!
    @IBOutlet private weak var totalSalaryAmountLabel: UILabel!
    @IBOutlet private weak var waterLimitLabel: UILabel!
    @IBOutlet private weak var totalWaterConsumptionLabel: UILabel!
    @IBOutlet private weak var increaseWaterLimitTextField: UITextField!
    @IBOutlet private weak var addIncomeOrExpenseTextField: UITextField!
    private var zoo = ZooImpl(name: "Birinci Zoo", waterLimit: 15, budget: 20_000, animals: [], sitters: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        configureLabels()
    }
    
    private func configureLabels() {
        zooNameLabel.text = zoo.name
        budgetAmountLabel.text = "\(zoo.budget) $"
        totalSalaryAmountLabel.text = "\(zoo.totalSalaries) $"
        waterLimitLabel.text = "\(zoo.waterLimit)"
        totalWaterConsumptionLabel.text = "\(zoo.totalWaterConsumption)"
    }
    
    private func configureTextFields() {
        increaseWaterLimitTextField.layer.borderWidth = 1.0
        increaseWaterLimitTextField.layer.cornerRadius = 5.0
        increaseWaterLimitTextField.layer.borderColor = UIColor.label.cgColor
        
        addIncomeOrExpenseTextField.layer.borderWidth = 1.0
        addIncomeOrExpenseTextField.layer.cornerRadius = 5.0
        addIncomeOrExpenseTextField.layer.borderColor = UIColor.label.cgColor
    }
    
    private func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func paySalaries(_ sender: Any) {
        
        if (zoo.sitters.isEmpty) {
            showAlert(title: "No Sitter", message: "There is no sitter to pay salary.")
            return
        }
        
        zoo.paySalaries { result in
            switch result {
            case .success(let budget):
                self.showAlert(title: "Salaries paid", message: "Salaries paid successfully, new budget is: \(budget)")
                self.budgetAmountLabel.text = "\(budget) $"
            case .failure(let error):
                self.showAlert(title: "Salaries not paid", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func increaseWaterLimit(_ sender: Any) {
        guard increaseWaterLimitTextField.text != "" else {
            self.showAlert(title: "Water limit not added", message: "Text field can not be empty.")
            return
            
        }
        let doubleValue = Double(increaseWaterLimitTextField.text!)
        zoo.increase(water: doubleValue ?? 0.0) { result in
            switch result {
            case .success(let newWaterLimit):
                self.waterLimitLabel.text = "\(newWaterLimit)"
                self.increaseWaterLimitTextField.text = ""
                self.showAlert(title: "Water limit increased", message: "New water limit is:\(newWaterLimit)")

            case .failure(let error):
                self.showAlert(title: "Water limit not increased.", message: error.localizedDescription)

            }
        }
    }
    @IBAction private func addIncome(_ sender: Any) {
        guard addIncomeOrExpenseTextField.text != "" else {
            self.showAlert(title: "Income not added", message: "Text field can not be empty.")
            return
        }
        let doubleValue = Double(addIncomeOrExpenseTextField.text!)
        zoo.add(income: doubleValue ?? 0.0) { result in
            switch result {
            case .success(let budget):
                self.budgetAmountLabel.text = "\(budget) $"
                self.addIncomeOrExpenseTextField.text = ""
                self.showAlert(title: "Income added.", message: "New budget is: \(budget)")
            case .failure(let error):
                self.showAlert(title: "Income not added.", message: error.localizedDescription)
            }
        }
    }
    @IBAction private func addExpense(_ sender: Any) {
        guard addIncomeOrExpenseTextField.text != "" else {
            self.showAlert(title: "Expense not added", message: "Text field can not be empty.")
            return
        }
        let doubleValue = Double(addIncomeOrExpenseTextField.text!)
        zoo.add(expense: doubleValue ?? 0.0) { result in
            switch result {
            case .success(let budget):
                self.budgetAmountLabel.text = "\(budget) $"
                self.addIncomeOrExpenseTextField.text = ""
                self.showAlert(title: "Expense added.", message: "New budget is: \(budget)")
            case .failure(let error):
                self.showAlert(title: "Expense not added.", message: error.localizedDescription)

            }
        }
    }
    
    @IBAction private func navigateAddingAnimalPage(_ sender: Any) {
        guard let addingAnimalView = self.storyboard?.instantiateViewController(withIdentifier: "AnimalAddingViewController") as? AnimalAddingViewController else {
            fatalError("View Controller not found")
        }
        addingAnimalView.zoo = zoo
        addingAnimalView.delegate = self
        navigationController?.pushViewController(addingAnimalView, animated: true)
    }
    
    @IBAction private func navigateAddingSitterPage(_ sender: Any) {
        guard let addingSitterView = self.storyboard?.instantiateViewController(withIdentifier: "SitterAddingViewController") as? SitterAddingViewController else {
            fatalError("View Controller not found")
        }
        addingSitterView.zoo = zoo
        addingSitterView.delegate = self
        navigationController?.pushViewController(addingSitterView, animated: true)
    }
    //Restriction: if there is no animal or sitter, will not navigate to listing page.
    @IBAction private func navigateListingPage(_ sender: Any) {
        if (zoo.animals.isEmpty) && (zoo.sitters.isEmpty) {
            self.showAlert(title: "No animal and sitter", message: "There is no animal and sitter.")
            return
        }
        
        guard let listingAnimalSitterView = self.storyboard?.instantiateViewController(withIdentifier: "AnimalSitterListingViewController") as? AnimalSitterListingViewController else {
            fatalError("View Controller not found")
        }
        listingAnimalSitterView.animalSitterList = TableViewResult  (animals: zoo.animals, sitters: zoo.sitters)
        navigationController?.pushViewController(listingAnimalSitterView, animated: true)
    }
    //Restriction: if there is no animal without sitter, will not navigate to assigning page.
    @IBAction private func navigateAssigningPage(_ sender: Any) {
        let animalsWithoutSitter = zoo.animals.filter {$0.sitter == nil}
        if animalsWithoutSitter.isEmpty {
            self.showAlert(title: "No animal", message: "There is no animal without sitter.")
            return
        }
        if zoo.sitters.isEmpty {
            self.showAlert(title: "No sitter", message: "There is no animal sitter to assign animal.")
            return
        }
        
        guard let sitterAssigningView = self.storyboard?.instantiateViewController(withIdentifier: "SitterAssigningViewController") as? SitterAssigningViewController else {
            fatalError("View Controller not found")
        }
        sitterAssigningView.animals = animalsWithoutSitter
        sitterAssigningView.sitters = zoo.sitters
        sitterAssigningView.zoo = zoo
        sitterAssigningView.delegate = self
        navigationController?.pushViewController(sitterAssigningView, animated: true)
        
    }
    
}
//When new sitter added, totalSalaryAmountLabel will update.
extension ZooViewController: SitterAddingViewControllerDelegate {
    func didAddSitter() {
        totalSalaryAmountLabel.text = "\(zoo.totalSalaries) $"
    }
}
//When new animal added, totalWaterConsumptionLabel will update.

extension ZooViewController: AnimalAddingViewControllerDelegate {
    func didAddNewAnimal(_ animal: Animal) {
        waterLimitLabel.text = "\(zoo.waterLimit)"
        totalWaterConsumptionLabel.text = "\(zoo.totalWaterConsumption)"
    }
}
//When sitter is assigned to animal, totalSalaryAmountLabel will update.

extension ZooViewController: SitterAssigningViewControllerDelegate {
    func didAssignedSitter() {
        totalSalaryAmountLabel.text = "\(zoo.totalSalaries) $"
    }
}
