//
//  AnimalAddingViewController.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit

protocol AnimalAddingViewControllerDelegate: AnyObject {
    func didAddNewAnimal(_ animal: Animal)
}

final class AnimalAddingViewController: UIViewController {

    
    @IBOutlet private weak var animalNameTextField: UITextField!
    @IBOutlet private weak var waterConsumptionTextField: UITextField!
    @IBOutlet private weak var animalTypeSegmentedControl: UISegmentedControl!
    
    weak var delegate: AnimalAddingViewControllerDelegate?
    
    var zoo: ZooImpl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        configureLabels()
    }
    
    private func configureTextFields() {
        waterConsumptionTextField.layer.borderWidth = 1.0
        waterConsumptionTextField.layer.cornerRadius = 5.0
        waterConsumptionTextField.layer.borderColor = UIColor.label.cgColor
    }
    private func configureLabels() {
        animalNameTextField.layer.borderWidth = 1.0
        animalNameTextField.layer.cornerRadius = 5.0
        animalNameTextField.layer.borderColor = UIColor.label.cgColor
    }
    private func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Restriction: all fields should be filled.
    @IBAction private func addAnimal(_ sender: Any) {
        guard let animalType: AnimalType = AnimalType(rawValue: animalTypeSegmentedControl.selectedSegmentIndex),
              let name = animalNameTextField.text,
              !name.isEmpty,
              let waterConsumption = Double(waterConsumptionTextField.text!)
        else {
            showAlert(title: "Animal not added", message: "You need to fill each field")
            return
        }
        
        let newAnimal: Animal
        switch animalType {
        case .cat:
            newAnimal = Cat(name: name, waterConsumption: waterConsumption)
        case .dog:
            newAnimal = Dog(name: name, waterConsumption: waterConsumption)
        }
        
        zoo?.add(animal: newAnimal) { result in
            switch result {
            case .success(let animal):
                self.showAlert(title: "New Animal", message: "\(animal.name) added") {
                    self.navigationController?.popViewController(animated: true)
                }
                self.delegate?.didAddNewAnimal(animal)
            case .failure(let error):
                self.showAlert(title: "Animal not added.", message: error.localizedDescription)
            }
        }
    }
    
}
