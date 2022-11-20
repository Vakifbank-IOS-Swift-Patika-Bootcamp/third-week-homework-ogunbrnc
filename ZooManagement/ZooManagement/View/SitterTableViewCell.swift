//
//  SitterTableViewCell.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit


class SitterTableViewCell: UITableViewCell {

    @IBOutlet private weak var sitterNameLabel: UILabel!
    @IBOutlet private weak var sitterSalaryLabel: UILabel!
    @IBOutlet private weak var sitterAnimalsLabel: UILabel!
    @IBOutlet private weak var sitterImageLabel: UILabel!
    
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
