//
//  Sitter.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import Foundation

enum Gender: Int, Equatable {
    case female
    case male
}

class Sitter {
    let id: String
    var gender: Gender
    var name: String
    var animals: [Animal]?
    var experience: Int
    var animalNames: [String] {
        animals?.map {$0.name} ?? []
    }
    var salary: Double {
        Double(animals!.count * 750 + 1000 * experience)
    }
    var image: String {
        switch gender {
        case .female:
            return "🙋‍♀️"
        case .male:
            return "🙋‍♂️"
        }
    }
    init(name:String = "Unknown",experience: Int, gender: Gender){
        self.animals = []
        self.id = UUID().uuidString
        self.name = name
        self.experience = experience
        self.gender = gender
    }
}
extension Sitter: Equatable {
    static func == (lhs: Sitter, rhs: Sitter) -> Bool {
        lhs.id == rhs.id
    }
}
