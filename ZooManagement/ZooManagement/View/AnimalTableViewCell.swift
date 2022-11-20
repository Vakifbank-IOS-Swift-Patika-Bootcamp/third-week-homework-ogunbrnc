//
//  AnimalTableViewCell.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 19.11.2022.
//

import UIKit

class AnimalTableViewCell: UITableViewCell {

    
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var waterConsumptionLabel: UILabel!
    @IBOutlet weak var sitterNameLabel: UILabel!
    @IBOutlet weak var animalTypeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(modal: Animal) {
        animalNameLabel.text = modal.name
        sitterNameLabel.text = modal.sitter?.name ?? "Not assigned"
        waterConsumptionLabel.text = "\(modal.waterConsumption)"
        animalTypeLabel.text = modal.image
    }
    
}
