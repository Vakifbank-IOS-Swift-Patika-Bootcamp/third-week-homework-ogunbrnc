//
//  AnimalSitterListingViewController.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import UIKit

//animalSitterTableView has 2 sections to list animals and sitters.

struct TableViewResult {
    let animals: [Animal]
    let sitters: [Sitter]
}
enum TableViewResultType: Int {
    case animal = 0
    case sitters = 1
    static var count: Int { return TableViewResultType.sitters.rawValue + 1}
    var header: String {
        switch self {
        case .animal:
            return "Animals"
        case .sitters:
            return "Sitters"
        }
    }
}

final class AnimalSitterListingViewController: UIViewController {
    
    @IBOutlet private weak var animalSitterTableView: UITableView!
    var animalSitterList: TableViewResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    private func configureTableView() {
        animalSitterTableView.register(UINib(nibName: "AnimalTableViewCell", bundle: nil), forCellReuseIdentifier: "AnimalTableViewCell")
        animalSitterTableView.register(UINib(nibName: "SitterTableViewCell", bundle: nil), forCellReuseIdentifier: "SitterTableViewCell")
        animalSitterTableView.delegate = self
        animalSitterTableView.dataSource = self
        animalSitterTableView.estimatedRowHeight = UITableView.automaticDimension
    }
}

extension AnimalSitterListingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewResultType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = TableViewResultType(rawValue: section)
        switch type {
            case .animal:
                return animalSitterList!.animals.count
            case .sitters:
                return animalSitterList!.sitters.count
            default:
                fatalError("too many sections")
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let type = TableViewResultType(rawValue: section)
        return type?.header
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TableViewResultType(rawValue: section)?.header
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
      
        
        headerView.addSubview(label)
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 15).isActive = true
        label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true

        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = TableViewResultType(rawValue: indexPath.section)
        switch type {
        case .animal:
            let animal = animalSitterList?.animals[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalTableViewCell", for: indexPath) as! AnimalTableViewCell
            cell.configure(modal: animal!)
            return cell
        case .sitters:
            let sitter = animalSitterList?.sitters[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SitterTableViewCell", for: indexPath) as! SitterTableViewCell
            cell.configure(modal: sitter!)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = TableViewResultType(rawValue: indexPath.section)
        if type == .animal {
            if let animal: Speakable = animalSitterList?.animals[indexPath.row] as? Speakable {
                animal.speak()
            }
        }
    }
}
