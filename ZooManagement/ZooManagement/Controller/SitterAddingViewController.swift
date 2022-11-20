//
//  SitterAddingViewController.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit

protocol SitterAddingViewControllerDelegate : AnyObject {
    func didAddSitter()
}
final class SitterAddingViewController: UIViewController {

    @IBOutlet private weak var sitterNameTextField: UITextField!
    @IBOutlet private weak var sitterGenderSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var sitterExperienceTextField: UITextField!
    var zoo: ZooImpl?
    weak var delegate: SitterAddingViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    private func configureTextFields() {
        sitterExperienceTextField.layer.borderWidth = 1.0
        sitterExperienceTextField.layer.cornerRadius = 5.0
        sitterExperienceTextField.layer.borderColor = UIColor.label.cgColor
        
        sitterNameTextField.layer.borderWidth = 1.0
        sitterNameTextField.layer.cornerRadius = 5.0
        sitterNameTextField.layer.borderColor = UIColor.label.cgColor
    }
    
    private func showAlert(title: String, message:String, completion:  (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction private func addSitter(_ sender: Any) {
        guard let gender: Gender = Gender(rawValue: sitterGenderSegmentedControl.selectedSegmentIndex),
            let name = sitterNameTextField.text,
              !name.isEmpty,
              let experience = sitterExperienceTextField.text,
              !experience.isEmpty
        else {
            showAlert(title: "Sitter not added", message: "You need to fill each field")
            return
        }
        let newSitter = Sitter(
            name: name,
            experience: Int(experience)!,
            gender: gender
        )
        
        zoo?.add(sitter: newSitter) { result in
            switch result {
            case .success(let sitter):
                self.delegate?.didAddSitter()
                self.showAlert(title: "New Sitter", message: "\(sitter.name) added successfully with salary: \(sitter.salary)") {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self.showAlert(title: "Sitter not added.", message: error.localizedDescription)
            }
        }
    }
}
