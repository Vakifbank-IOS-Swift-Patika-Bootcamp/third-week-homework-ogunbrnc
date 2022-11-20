//
//  EmployeeTableViewCell.swift
//  CompanyManagement
//
//  Created by Ogün Birinci on 17.11.2022.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var employeeType: UILabel!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeSalary: UILabel!
    @IBOutlet weak var employeeField: UILabel!
    @IBOutlet weak var employeeImage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(modal: EmployeeImpl) {
        employeeName.text = modal.name
        employeeType.text = modal.type.readableType
        employeeSalary.text = "\(modal.salary) $"
        employeeField.text = modal.field.description
        employeeImage.text = modal.image
    }
    
}
