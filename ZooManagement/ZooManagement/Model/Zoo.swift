//
//  Zoo.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//

import Foundation

protocol Zoo {
    var name: String { get }
    var budget: Double { get }
    var waterLimit: Double { get }
    var animals: [Animal] { get }
    var sitters: [Sitter] { get }
    var totalSalaries: Double { get }
    
    func add(income  amount: Double, completion: @escaping (Result<Double, Error>) -> Void)
    func add(expense amount: Double, completion: @escaping (Result<Double, Error>) -> Void)
    func add(animal: Animal, completion: @escaping (Result<Animal, Error>) -> Void)
    func add(sitter: Sitter,completion: @escaping (Result<Sitter, Error>) -> Void)
    func increase(water amount: Double, completion: @escaping (Result<Double, Error>) -> Void)
    func paySalaries(completion: @escaping (Result<Double, Error>) -> Void)
    func assign(animal: inout Animal, sitter: inout Sitter, completion: @escaping (Result<(Sitter,Animal), Error>) -> Void)

}

enum ZooError: Error {
    case incomeNotPositive
    case expenseNotPositive
    case notEnoughBudget
    case sitterNotExists
    case animalNotExists
    case animalExists
    case sitterExists
    case limitNotPossitive
    case notEnoughWater
    case hasAlreadySitter
}

extension ZooError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incomeNotPositive:
            return "Income amount have to be a positive value."
        case .expenseNotPositive:
            return "Expense amount have to be a positive value."
        case .notEnoughBudget:
            return "Not enough budget to pay."
        case .animalExists:
            return "Animal is already added"
        case .animalNotExists:
            return "This animal does not live in the zoo."
        case .sitterNotExists:
            return "This sitter doesn't work at the zoo."
        case .sitterExists:
            return "Sitter is already added."
        case .limitNotPossitive:
            return "Water limit have to be a positive value."
        case .notEnoughWater:
            return "There is no enough water to add new animal."
        case .hasAlreadySitter:
            return "This animal has already sitter"
        }
    }
}

class ZooImpl: Zoo {
    var name: String
    var waterLimit: Double
    var budget: Double
    var animals: [Animal]
    var sitters: [Sitter]
    var totalSalaries: Double {
        sitters.reduce(0) { $0 + $1.salary }
    }
    var totalWaterConsumption: Double {
        animals.reduce(0) {$0 + $1.waterConsumption}
    }
    
    //Restriction: income can not be negative
    func add(income amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        guard amount > 0 else {
            let error = ZooError.incomeNotPositive
            completion(.failure(error))
            return
        }
        budget += amount
        completion(.success(budget))
    }
    
    //Restriction: expense can not be negative and can not be greater than budget.
    func add(expense amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        guard amount > 0 else {
            let error = ZooError.expenseNotPositive
            completion(.failure(error))
            return
        }
        guard budget >= amount else {
            let error = ZooError.notEnoughBudget
            completion(.failure(error))
            return
        }
        
        budget -= amount
        completion(.success(budget))
    }
    
    //Restriction: If the water limit is not sufficient or animal is already in zoo, new animal cannot be added
    func add(animal: Animal, completion: @escaping (Result<Animal, Error>) -> Void) {
        let contains = animals.contains(animal)
        guard !contains else {
            let error = ZooError.animalExists
            completion(.failure(error))
            return
        }
        
        guard waterLimit >= animal.waterConsumption  else {
            completion(.failure(ZooError.notEnoughWater))
            return
        }
        animals.append(animal)
        waterLimit -= animal.waterConsumption
        completion(.success(animal))
    }
    
    // Restriction: If the sitter is already added, will not be added again.
    func add(sitter: Sitter,completion: @escaping (Result<Sitter, Error>) -> Void) {
        let contains = sitters.contains(sitter)
        guard !contains else {
            let error = ZooError.sitterExists
            completion(.failure(error))
            return
        }
        sitters.append(sitter)
        completion(.success(sitter))
    }
    
    //Restriction: water amount can not be negative
    func increase(water amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        guard amount > 0 else {
            let error = ZooError.limitNotPossitive
            completion(.failure(error))
            return
        }
        waterLimit += amount
        completion(.success(waterLimit))
    }
    
    //Restriction: If the budget is not sufficient, no payment will be made.
    func paySalaries(completion: @escaping (Result<Double, Error>) -> Void) {
        guard budget >= totalSalaries else {
            let error = ZooError.notEnoughBudget
            completion(.failure(error))
            return
        }
        
        budget -= totalSalaries
        completion(.success(budget))
    }
    
    // Restriction: if animal doesn't live at the zoo or sitter doesn't work at the zoo or animal has already sitter assignment will not be made
    func assign(animal: inout Animal, sitter: inout Sitter, completion: @escaping (Result<(Sitter,Animal), Error>) -> Void) {
        guard animals.contains(animal) else {
            completion(.failure(ZooError.animalNotExists))
            return
        }
        guard sitters.contains(sitter) else {
            completion(.failure(ZooError.sitterNotExists))
            return
        }
        guard animal.sitter == nil else {
            completion(.failure(ZooError.hasAlreadySitter))
            return
        }
        animal.sitter = sitter
        sitter.animals!.append(animal)
        completion(.success((sitter,animal)))
    }
    
    func prints(){
        animals.forEach { animal in
            print(animal.waterConsumption)
        }
        sitters.forEach { sitter in
            print(sitter.salary)
        }
    }
    //If there are animals while the zoo is being created, water limits will be deducted.
    init(name:String, waterLimit:Double, budget: Double , animals: [Animal], sitters: [Sitter]){
        self.name = name
        self.waterLimit = waterLimit - animals.reduce(0) { $0 + $1.waterConsumption }
        self.budget = budget
        self.animals = animals
        self.sitters = sitters
    }
}
