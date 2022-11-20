import Foundation
protocol Company {
    var name: String { get }
    var employees: [EmployeeImpl]? { get }
    var budget: Double { get }
    var foundationYear: Int { get }

    func add(income amount: Double, completion: @escaping (Result<Double, Error>) -> Void)
    func add(expense amount: Double, completion: @escaping (Result<Double, Error>) -> Void)
    func add(employee: EmployeeImpl, completion: @escaping (Result<EmployeeImpl, Error>) -> Void)
    func paySalaries(completion: @escaping (Result<Double, Error>) -> Void)
}

enum CompanyError: Error {
    case incomeNotPositive
    case expenseNotPositive
    case notEnoughBudget
    case employeeExists
}

extension CompanyError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .incomeNotPositive:
            return "Income amount have to be a positive value."
        case .expenseNotPositive:
            return "Expense amount have to be a positive value."
        case .notEnoughBudget:
            return "Not enough budget to pay."
        case .employeeExists:
            return "Employee is already added."
        }
    }
}

class CompanyImpl: Company {
    let name: String
    var employees: [EmployeeImpl]?
    var budget: Double
    let foundationYear: Int
    
    var totalSalaries: Double {
        employees!.reduce(0) { $0 + $1.salary }
    }
    
    // Restriction: income can not be negative
    func add(income amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        guard amount > 0 else {
            let error = CompanyError.incomeNotPositive
            completion(.failure(error))
            return
        }
        budget += amount
        completion(.success(budget))
    }
    
    // Restriction: expense can not be negative and greater than budget.
    func add(expense amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        guard amount > 0 else {
            let error = CompanyError.expenseNotPositive
            completion(.failure(error))
            return
        }
        guard budget >= amount else {
            let error = CompanyError.notEnoughBudget
            completion(.failure(error))
            return
        }
        
        budget -= amount
        completion(.success(budget))
    }
    
    // Restriction: Same employee can not be added.
    func add(employee: EmployeeImpl, completion: @escaping (Result<EmployeeImpl, Error>) -> Void) {
        let contains = employees!.contains { $0.id == employee.id }
        guard !contains else {
            let error = CompanyError.employeeExists
            completion(.failure(error))
            return
        }
        employees!.append(employee)
        completion(.success(employee))
    }
    // Restriction: If the total amount of salary to be paid is more than the budget, the payment cannot be made.
    func paySalaries(completion: @escaping (Result<Double, Error>) -> Void) {
        guard budget >= totalSalaries else {
            let error = CompanyError.notEnoughBudget
            completion(.failure(error))
            return
        }
        
        budget -= totalSalaries
        completion(.success(budget))
    }
    
    init(name: String, employees: [EmployeeImpl]? = [], budget: Double, foundationYear: Int) {
        self.name = name
        self.employees = employees
        self.budget = budget
        self.foundationYear = foundationYear
    }
}
