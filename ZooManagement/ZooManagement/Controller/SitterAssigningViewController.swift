//
//  SitterAssigningViewController.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit

protocol SitterAssigningViewControllerDelegate : AnyObject {
    func didAssignedSitter()
}

final class SitterAssigningViewController: UIViewController {
    
    var animals: [Animal]?
    var sitters: [Sitter]?
    var zoo: ZooImpl?
    private var selectedSitterRow: Int = 0
    private var selectedAnimalRow: Int = 0
    private var sitterOptions: [String] = []
    private var animalOptions: [String] = []
    private var sitterPickerView = ToolbarPickerView()
    private var animalPickerView = ToolbarPickerView()
    
    @IBOutlet private weak var animalTextField: UITextField!
    @IBOutlet private weak var sitterTextField: UITextField!
    
    weak var delegate: SitterAssigningViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        configureTextFields()
        configurePickerviews()

    }
    private func configureTextFields() {
        animalTextField.inputView = animalPickerView
        animalTextField.inputAccessoryView = animalPickerView.toolbar
        animalTextField.layer.borderWidth = 1.0
        animalTextField.layer.cornerRadius = 5.0
        animalTextField.layer.borderColor = UIColor.label.cgColor
        
        sitterTextField.inputView = sitterPickerView
        sitterTextField.inputAccessoryView = sitterPickerView.toolbar
        sitterTextField.layer.borderWidth = 1.0
        sitterTextField.layer.cornerRadius = 5.0
        sitterTextField.layer.borderColor = UIColor.label.cgColor
    }
    
    private func configurePickerviews() {
        
        sitterOptions = sitters?.map{$0.name} ?? []
        animalOptions = animals?.map{$0.name} ?? []
        
        sitterPickerView.dataSource = self
        sitterPickerView.delegate = self
        sitterPickerView.toolbarDelegate = self
        
        animalPickerView.dataSource = self
        animalPickerView.delegate = self
        animalPickerView.toolbarDelegate = self
        
        animalPickerView.reloadAllComponents()
        sitterPickerView.reloadAllComponents()
    }
    
    private func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    //Restriction: All fields should be filled.
    @IBAction private func assignButtonClicked(_ sender: Any) {
        var sitter = sitters![selectedSitterRow]
        var animal = animals![selectedAnimalRow]
        zoo?.assign(animal: &animal, sitter: &sitter){ result in
            switch result {
            case .success((let sitter, let animal)):
                self.showAlert(title: "New Sitter", message: "\(sitter.name) assigned to \(animal.name) as sitter") {
                    self.navigationController?.popViewController(animated: true)
                }
                self.delegate?.didAssignedSitter()
            case .failure(let error):
                self.showAlert(title: "Sitter not added.", message: error.localizedDescription)
            }
        }
    }
    
    
    
}

extension SitterAssigningViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sitterPickerView {
            return sitterOptions.count
        }
        else {
            return animalOptions.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sitterPickerView{
            return sitterOptions[row]
        } else {
            return animalOptions[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        if pickerView == sitterPickerView {
            selectedSitterRow = row
            sitterTextField.text = sitterOptions[row]
        } else {
            selectedAnimalRow = row
            animalTextField.text = animalOptions[row]
        }
    }
    
}

extension SitterAssigningViewController: ToolbarPickerViewDelegate {
    func didTapDone(_ picker: ToolbarPickerView) {
        if picker == sitterPickerView {
            let row = self.sitterPickerView.selectedRow(inComponent: 0)
            self.sitterPickerView.selectRow(row, inComponent: 0, animated: false)
            self.sitterTextField.text = self.sitterOptions[row]
            self.sitterTextField.resignFirstResponder()
        }
        else {
            let row = self.animalPickerView.selectedRow(inComponent: 0)
            self.animalPickerView.selectRow(row, inComponent: 0, animated: false)
            self.animalTextField.text = self.animalOptions[row]
            self.animalTextField.resignFirstResponder()
        }
    }

    func didTapCancel(_ picker: ToolbarPickerView) {
        if picker == sitterPickerView {
            self.sitterTextField.text = nil
            self.sitterTextField.resignFirstResponder()
        }
        else {
            self.animalTextField.text = nil
            self.animalTextField.resignFirstResponder()
        }
    }
}
