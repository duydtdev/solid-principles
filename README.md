# SOLID Principles in Swift

## Descriptions
> This repository to contain all knowledges about ``SOLID Principles in Swift``.

## Contents
### 1. Overview
It represents `5 principles` of object-oriented programming: 
* Single responsibility 
* Open/Closed, 
* Liskov Substitution
* Interface Segregation 
* Dependency Inversion

These principles help you can solve the main problems of a bad architecture:
* `Fragility`: A change may break unexpected parts—it is very difficult to detect if you don’t have a good test coverage.
* `Immobility`: A component is difficult to reuse in another project—or in multiple places of the same project—because it has too many coupled dependencies.
* `Rigidity`: A change requires a lot of efforts because affects several parts of the project.

### 2. The Single Responsibility Principle (SRP)
* There should never be more than one reason for a class to change.

Every time you create/change a class, you should ask yourself: How many responsibilities does this class have?

```swift
class Handler {
  func handle() {
    let data = requestDataToAPI()
    let array = parse(data: data)
    saveToDB(array: array)
  }
  
  private func requestDataToAPI() -> Data {
    /// Send API request and wait the response
    return Data()
  }
  
  private func parse(data: Data) -> [String] {
    /// Parse the data and create the array
    return [""]
  }
  
  private func saveToDB(array: [String]) {
    /// Save the array in a database (CoreData/Realm/...)
  }
}
```
You can solve this problem moving the responsibilities down to little classes

```swift
class APIHandler {
    func requestDataToAPI() -> Data {
        // send API request and wait the response
    }
}
```

```swift
class ParseHandler {
  func parse(data: Data) -> [String] {
    /// Parse the data and create the array
    return [""]
  }
}
```
```swift
class DBHandler {
  func saveToDB(array: [String]) {
    /// Save the array in a database (CoreData/Realm/...)
  }
}
```
And then we will can write a class same as below
```swift
class NewHandler {
  let apiHandler: APIHandler
  let parseHandler: ParseHandler
  let dbHandler: DBHandler
  
  init(apiHandler: APIHandler, parseHandler: ParseHandler, dbHandler: DBHandler) {
    self.apiHandler = apiHandler
    self.parseHandler = parseHandler
    self.dbHandler = dbHandler
  }
  
  func handle() {
    let data = apiHandler.requestDataToAPI()
    let array = parseHandler.parse(data: data)
    dbHandler.saveToDB(array: array)
  }
}
```
This principle helps you to keep your classes as clean as possible. Moreover, in the first example you couldn’t test `requestDataToAPI`, parse and `saveToDB` directly, since those were private methods. After the refactor, you can easily do it testing `APIHandler`, `ParseHandler` and `DBHandler`

### 3. The Open-Closed Principle (OCP)
* Software entities (Classes, Modules, Functions,…) should be open for extension, but closed for modification
* If you want to create a class easy to maintain, it must have two important characteristics:
    * Open for extension: You should be able to extend or change the behaviours of a class without efforts.
    * Closed for modification: You must extend a class without changing the implementation

Example:
```swift
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
```

```swift
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
```

If you want to add the possibility to print also the details of a new class, we should change the implementation of printData every time we want to log a new class

```swift
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
 
        let bicycles = [
            Bicycle(type: "BMX"),
            Bicycle(type: "Tandem")
        ]
 
        bicycles.forEach { bicycles in
            print(bicycles.printDetails())
        }
    }
}
```

```swift
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
```

```swift
class Bicycle {
    let type: String
 
    init(type: String) {
        self.type = type
    }
 
    func printDetails() -> String {
        return "I'm a \(type)"
    }
}
```

We can solve this problem by a new protocol `Printable`
```swift
protocol Printable {
    func printDetails() -> String
}
```

```swift
class Logger {
    func printData() {
        let cars: [Printable] = [
            Car(name: "Batmobile", color: "Black"),
            Car(name: "SuperCar", color: "Gold"),
            Car(name: "FamilyCar", color: "Grey"),
            Bicycle(type: "BMX"),
            Bicycle(type: "Tandem")
        ]
 
        cars.forEach { car in
            print(car.printDetails())
        }
    }
}
```

```swift
class Car: Printable {
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
```

```swift
class Bicycle: Printable {
    let type: String
 
    init(type: String) {
        self.type = type
    }
 
    func printDetails() -> String {
        return "I'm a \(type)"
    }
}
```

### 4. The Liskov Substitution Principle (LSP)
* Functions that use pointers or references to base classes must be able to use objects of derived classes without knowing it

##### Preconditions changes
Example
```swift
class Handler {
  func save(string: String) {
    /// Save string in the Cloud
  }
}
```

```swift
class FilteredHandler: Handler {
  override func save(string: String) {
    guard string.count > 5 else { return }
    
    super.save(string: string)
  }
}
```

This example breaks LSP because, in the subclass, we add the precondition that string must have a length greater than 5

A client of Handler doesn’t expect that FilteredHandler has a different precondition, since it should be the same for Handler and all its subclasses

And the solution below:

```swift
class ResolutionHandler {
  func save(string: String, minChars: Int = 0) {
    guard string.count >= minChars else { return }
    
    /// Save string in the Cloud
  }
}
```

##### Postconditions changes
Example:
```swift
class Rectangle {
  
  var width: Float = 0
  var length: Float = 0
  
  var area: Float {
    return width * length
  }
}
```

```swift
class Square: Rectangle {
  
  override var width: Float {
    didSet {
      length = width
    }
  }
}
```

Write a function to print result of rectangle and square
```swift
func printArea(of rectangle: Rectangle) {
  rectangle.length = 5
  rectangle.width = 2
  print(rectangle.area)
}

let rectangle = Rectangle()
printArea(of: rectangle) /// Result will be 10

let square = Square()
printArea(of: square) /// Result will be 4
```

Instead, the first one prints 10 and the second one 4. This means that, `with` this inheritance, we have just broken the postcondition of the width `setter which is: ((width == newValue) && (height == height)).`

We can solve it using a protocol with a method `area`
```swift
protocol Polygon {
    var area: Float { get }
}
```

```swift
class Rectangle: Polygon {
    private let width: Float
    private let length: Float
 
    init(width: Float, length: Float) {
        self.width = width
        self.length = length
    }
 
    var area: Float {
        return width * length
    }
}
```

```swift
class Square: Polygon {
    private let side: Float
 
    init(side: Float) {
        self.side = side
    }
 
    var area: Float {
        return pow(side, 2)
    }
}
```

And write a method to print of result
```swift
func printArea(of polygon: Polygon) {
  print(polygon.area)
}

let resolutionRectangle =  ResolutionRectangle(width: 2, length: 5)
printArea(of: resolutionRectangle) /// Result will be 10

let resolutionSquare =  ResolutionSquare(side: 2)
printArea(of: resolutionSquare) /// Result will be 4
```
### 5. The Interface Segregation Principle (ISP)
* Clients should not be forced to depend upon interfaces that they do not use

##### Fat interface (Protocol)
Example
```swift
protocol GestureProtocol {
  func didTap()
  func didDoubleTap()
  func didLongPress()
}
```

`SuperButton` is happy to implement the methods which it needs
```swift
class SuperButton: GestureProtocol {
  func didTap() {
    /// Send tap action
  }
  
  func didDoubleTap() {
    /// Send double tap action
  }
  
  func didLongPress() {
    /// Send long press action
  }
}
```
The problem is that our app has also a `PoorButton` which needs just `didTap`
```swift
class PoorButton: GestureProtocol {
  func didTap() {
    /// Send tap action
  }
  
  func didDoubleTap() { }
  
  func didLongPress() { }
}
```
Solution below:
```swift
protocol TapProtocol {
  func didTap()
}
```

```swift
protocol DoubleTapProtocol {
  func didDoubleTap()
}
```

```swift
protocol LongPressProtocol {
  func didLongPress()
}
```

And we write a `SuperButton` like as:
```swift
class ResolutionSuperButton: TapProtocol, DoubleTapProtocol, LongPressProtocol {
  func didTap() {
    /// Send tap action
  }
  
  func didDoubleTap() {
    /// Send double tap action
  }
  
  func didLongPress() {
    /// Send long press action
  }
}
```

And `PoorButton` just have `didTap`
```swift
class ResolutionPoorButton: TapProtocol {
  func didTap() {
    /// Send tap action
  }
}
```

##### Fat interface (Class)
Example
```swift
class Video {
  var title: String = "My Video"
  var description: String = "This is a beautiful video"
  var author: String = "Name"
  var url: String = "https://video"
  var duration: Int = 60
  var created: Date = Date()
  var update: Date = Date()
}

func play(video: Video) {
}
```
We are injecting too many information in the method play, since it needs just url, title and duration
And we can solve this problem with a `Playable` protocol
```swift
protocol Playable {
  var title: String { get }
  var url: String { get }
  var duration: Int { get }
}
```

```swift
class ResolutionVideo: Playable {
  var title: String = "My Video"
  var description: String = "This is a beautiful video"
  var author: String = "Name"
  var url: String = "https://video"
  var duration: Int = 60
  var created: Date = Date()
  var update: Date = Date()
}


func play(video: Playable) {
}
```

### 6. The Dependency Inversion Principle (DIP)
* High level modules should not depend upon low level modules. Both should depend upon abstractions
* Abstractions should not depend upon details. Details should depend upon abstractions

Example:
```swift
class Handler {
  let fm = FilesystemManager()
  
  func handle(string: String) {
    fm.save(string: string)
  }
}
```

```swift
class FilesystemManager {
  func save(string: String) {
  }
}
```
FilesystemManager is the low-level module and it’s easy to reuse in other projects
We can solve this dependency using a protocol

```swift
protocol Storage {
  func save(string: String)
}
```

```swift
class ResolutionHandler {
  let storage: Storage
  
  init(storage: Storage) {
    self.storage = storage
  }
  
  func handle(string: String) {
    storage.save(string: string)
  }
}
```
```swift
class ResolutionFilesystemManager: Storage {
  
  func save(string: String) {
    /// Implement A features
  }
}
```

```swift
class ResolutionDatabaseManager: Storage {
  
  func save(string: String) {
    /// Implement B features
  }
}
```
Now it can be useful also for testing

## Meta
Author: Duy Doan

Distributed under the MIT license. See ``LICENSE`` for more information.