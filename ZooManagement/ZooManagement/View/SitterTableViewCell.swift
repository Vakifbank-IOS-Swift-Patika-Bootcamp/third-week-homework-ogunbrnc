//
//  SitterTableViewCell.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit

class SitterTableViewCell: UITableViewCell {

    @IBOutlet weak var sitterNameLabel: UILabel!
    @IBOutlet weak var sitterSalaryLabel: UILabel!
    @IBOutlet weak var sitterAnimalsLabel: UILabel!
    @IBOutlet weak var sitterImageLabel: UILabel!
    
    @IBOutlet weak var sitterExperienceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(modal: Sitter) {
        sitterNameLabel.text = modal.name
        sitterSalaryLabel.text = "\(modal.salary) $"
        sitterAnimalsLabel.text = modal.animalNames.isEmpty ? "Not assigned to any animal." : modal.animalNames.joined(separator: "\n")
        sitterImageLabel.text = modal.image
        sitterExperienceLabel.text = "\(modal.experience)"
    }
}
