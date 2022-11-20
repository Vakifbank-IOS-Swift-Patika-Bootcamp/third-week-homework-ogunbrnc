//
//  EmployeeAddViewController.swift
//  CompanyManagement
//
//  Created by Ogün Birinci on 17.11.2022.
//

import UIKit

protocol EmployeeAddViewControllerDelegate: AnyObject {
    func didAddNewEmployeee(_ employee: EmployeeImpl)
}

final class EmployeeAddViewController: UIViewController {
    @IBOutlet private weak var nameAndSurnameTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var employeeTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var employeeGenderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var employeeMaritalStatusSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var employeeFieldTextField: UITextField!
    
    private var employeeFieldPickerView = ToolbarPickerView()
    private var employeeField : Field?
    
    var company: CompanyImpl?
    weak var delegate: EmployeeAddViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        configurePickerview()
    }
    
    private func configureTextFields() {
        employeeFieldTextField.inputView = employeeFieldPickerView
        employeeFieldTextField.inputAccessoryView = employeeFieldPickerView.toolbar
        employeeFieldTextField.layer.borderWidth = 1.0
        employeeFieldTextField.layer.cornerRadius = 5.0
        employeeFieldTextField.layer.borderColor = UIColor.label.cgColor
    }
    private func configurePickerview() {
        employeeFieldPickerView.dataSource = self
        employeeFieldPickerView.delegate = self
        employeeFieldPickerView.toolbarDelegate = self
        
        employeeFieldPickerView.reloadAllComponents()
    }
    
    private func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func addNewEmployee(_ sender: Any) {
        
        guard let employeeType: EmployeeType = EmployeeType(rawValue: employeeTypeSegmentedControl.selectedSegmentIndex),
              let employeeGender: Gender = Gender(rawValue: employeeGenderSegmentedControl.selectedSegmentIndex),
              let employeeMaritalStatus: MaritalStatus = MaritalStatus(rawValue: employeeMaritalStatusSegmentedControl.selectedSegmentIndex),
              let field = employeeField,
              let name = nameAndSurnameTextField.text,
              !name.isEmpty,
              let age = Int(ageTextField.text!)
        else {
            showAlert(title: "Employee not added", message: "You need to fill each field correctly")
            return
        }
        
        let newEmployee = EmployeeImpl(
            name: name,
            age: age,
            maritalStatus: employeeMaritalStatus,
            type: employeeType,
            gender: employeeGender,
            field: field
        )

        company?.add(employee: newEmployee) { result in
            switch result {
            case .success(let employee):
                self.showAlert(title: "New Employee", message: "\(employee.name) added successfully with salary: \(employee.salary)$") {
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.didAddNewEmployeee(employee)
                }
            case .failure(let error):
                self.showAlert(title: "Employee Not Added", message: error.localizedDescription)
            }
        }
    }
    
}

extension EmployeeAddViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Field.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Field(rawValue: row)?.description
    }
    
    
}

extension EmployeeAddViewController: ToolbarPickerViewDelegate {
    func didTapDone(_ picker: ToolbarPickerView) {
        let row = self.employeeFieldPickerView.selectedRow(inComponent: 0)
        self.employeeFieldPickerView.selectRow(row, inComponent: 0, animated: false)
        employeeField = Field(rawValue: row)
        self.employeeFieldTextField.text = employeeField?.description
        self.employeeFieldTextField.resignFirstResponder()
    }

    func didTapCancel(_ picker: ToolbarPickerView) {
        self.employeeFieldTextField.resignFirstResponder()
    }
}
