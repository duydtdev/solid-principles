//: Playground - noun: a place where people can play

import UIKit

/// Old source code
class Logger {
  
  func printData() {
    let cars = [
      Car(name: "Batmobile", color: "Black"),
      Car(name: "SuperCar", color: "Gold"),
      Car(name: "FamilyCar", color: "Grey")
    ]
    
    cars.forEach { car in
      print(car.printDetails())
    }
  }
}

class Car {
  let name: String
  let color: String
  
  init(name: String, color: String) {
    self.name = name
    self.color = color
  }
  
  func printDetails() -> String {
    return "I'm \(name) and my color is \(color)"
  }
}

/// ===============================
/// If you want to add the possibility to print also the details of a new class, we should change the implementation of printData every time we want to log a new class

class NewLogger {
  
  func printData() {
    let cars = [
      NewCar(name: "Batmobile", color: "Black"),
      NewCar(name: "SuperCar", color: "Gold"),
      NewCar(name: "FamilyCar", color: "Grey")
    ]
    
    cars.forEach { car in
      print(car.printDetails())
    }
    
    let bicycles = [
      NewBicycle(type: "BMX"),
      NewBicycle(type: "Tandem")
    ]
    
    bicycles.forEach { bicycles in
      print(bicycles.printDetails())
    }
  }
}

class NewCar {
  let name: String
  let color: String
  
  init(name: String, color: String) {
    self.name = name
    self.color = color
  }
  
  func printDetails() -> String {
    return "I'm \(name) and my color is \(color)"
  }
}

class NewBicycle {
  let type: String
  
  init(type: String) {
    self.type = type
  }
  
  func printDetails() -> String {
    return "I'm a \(type)"
  }
}

/// ===============================
/// We can solve this problem creating a new protocol Printable, which will be implemented by the classes to log. Finally, printData will print an array of Printable

protocol Printable {
  func printDetails() -> String
}

class ResolutionLogger {
  
  func printData() {
    let cars: [Printable] = [
      ResolutionCar(name: "Batmobile", color: "Black"),
      ResolutionCar(name: "SuperCar", color: "Gold"),
      ResolutionCar(name: "FamilyCar", color: "Grey"),
      ResolutionBicycle(type: "BMX"),
      ResolutionBicycle(type: "Tandem")
    ]
    
    cars.forEach { car in
      print(car.printDetails())
    }
  }
}

class ResolutionCar: Printable {
  let name: String
  let color: String
  
  init(name: String, color: String) {
    self.name = name
    self.color = color
  }
  
  func printDetails() -> String {
    return "I'm \(name) and my color is \(color)"
  }
}

class ResolutionBicycle: Printable {
  let type: String
  
  init(type: String) {
    self.type = type
  }
  
  func printDetails() -> String {
    return "I'm a \(type)"
  }
}
