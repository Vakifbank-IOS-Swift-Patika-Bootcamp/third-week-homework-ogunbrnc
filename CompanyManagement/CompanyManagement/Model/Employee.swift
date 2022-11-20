//
//  Employee.swift
//  CompanyManagement
//
//  Created by Ogün Birinci on 17.11.2022.
//

import Foundation

enum Field: Int {
    case frontendDeveloper = 0
    case backendDeveloper = 1
    case mobileDeveloper = 2
    case fullstackDeveloper = 3
    case gameDeveloper = 4
    case dataScientist = 5
    static var count: Int { return Field.dataScientist.rawValue + 1 }
    
    var description: String {
        switch self {
        case .frontendDeveloper: return "Frontend Developer"
        case .backendDeveloper   : return "Backend Developer"
        case .mobileDeveloper  : return "Mobile Developer"
        case .fullstackDeveloper : return "Fullstack Developer"
        case .gameDeveloper : return "Game Developer"
        case .dataScientist : return "Data Scientist"
        }
    }
    var salaryCoefficient: Double {
        switch self {
        case .frontendDeveloper:
            return 1.5
        case .backendDeveloper:
            return 2.0
        case .mobileDeveloper:
            return 2.5
        case .fullstackDeveloper:
            return 2.5
        case .gameDeveloper:
            return 2.5
        case .dataScientist:
            return 1.7
        }
    }
    
}

enum Gender: Int,Equatable {
    case male
    case female
}

// Salary will be calculated using salary Coefficient value
enum MaritalStatus: Int, Equatable {
    case single
    case married
    
    var salaryCoefficient: Double {
        switch self {
        case .single:
            return 1.0
        case .married:
            return 2
        }
    }
}

// Salary will be calculated using salary Coefficient value
enum EmployeeType: Int, Equatable {
    case junior
    case mid
    case senior
    
    var salaryCoefficient: Double {
        switch self {
        case .junior:
            return 1
        case .mid:
            return 1.5
        case .senior:
            return 2
        }
    }
    var readableType: String {
        switch self {
        case .junior:
            return "Jr. Developer"
        case .mid:
            return "Mid. Developer"
        case .senior:
            return "Sr. Developer"
        }
    }
}

// Using the ID value, the same employee will not be added again.
protocol Employee: Equatable {
    var image: String { get }
    var gender: Gender { get }
    var id: String { get }
    var name: String { get }
    var age: Int { get }
    var maritalStatus: MaritalStatus { get set }
    var type: EmployeeType { get }
    var salary: Double { get }
    var field: Field { get }
}

class EmployeeImpl: Employee {

    let id: String
    let name: String
    let age: Int
    var maritalStatus: MaritalStatus
    let type: EmployeeType
    let gender: Gender
    var field: Field
    var image: String {
        switch gender {
        case .male:
            return "🙋‍♂️"
        case .female:
            return "🙋‍♀️"
        }
    }
    var salary: Double {
        10_000 +  Double(100 * age) + (500 * type.salaryCoefficient) + (750 * maritalStatus.salaryCoefficient) + (2000 * field.salaryCoefficient)
    }
    
    init(name: String, age: Int, maritalStatus: MaritalStatus, type: EmployeeType, gender: Gender, field: Field) {
        self.id = UUID().uuidString
        self.name = name
        self.age = age
        self.maritalStatus = maritalStatus
        self.type = type
        self.gender = gender
        self.field = field
    }
}
extension EmployeeImpl : Equatable {
    static func == (lhs: EmployeeImpl, rhs: EmployeeImpl) -> Bool {
        return lhs.id == rhs.id
    }
}
