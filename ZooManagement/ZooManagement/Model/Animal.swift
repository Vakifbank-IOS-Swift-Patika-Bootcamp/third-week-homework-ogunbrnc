//
//  Animal.swift
//  ZooManagement
//
//  Created by Ogün Birinci on 18.11.2022.
//


import AVFoundation
import Foundation

var soundEffect: AVAudioPlayer?

enum AnimalType: Int, Equatable {
    case cat
    case dog
}

class Animal {
    var image: String?
    let id: String
    var name: String
    var waterConsumption: Double
    weak var sitter: Sitter?
    init(name: String  = "Unknown", waterConsumption: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.waterConsumption = waterConsumption
    }
}

extension Animal: Equatable {
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        lhs.id == rhs.id
    }
}

protocol Speakable {
    func speak()
}



class Dog: Animal {
    override init(name: String = "Unknown", waterConsumption: Double) {
        super.init(name: name, waterConsumption: waterConsumption)
        self.image = "🐶"
    }
    
}

extension Dog: Speakable{
    func speak() {
        let path = Bundle.main.path(forResource: "dog.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
}



class Cat: Animal {
    override init(name: String = "Unknown", waterConsumption: Double) {
        super.init(name: name, waterConsumption: waterConsumption)
        self.image = "🐱"
    }
}

extension Cat: Speakable {
    func speak() {
        let path = Bundle.main.path(forResource: "cat.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundEffect = try AVAudioPlayer(contentsOf: url)
            soundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
}


