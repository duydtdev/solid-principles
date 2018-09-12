//: Playground - noun: a place where people can play

import UIKit

// MARK: - Preconditions changes
/// Example

class Handler {
  
  func save(string: String) {
    /// Save string in the Cloud
  }
}

class FilteredHandler: Handler {
  
  override func save(string: String) {
    guard string.count > 5 else { return }
    
    super.save(string: string)
  }
}

/// This example breaks LSP because, in the subclass, we add the precondition that string must have a length greater than 5

/// A client of Handler doesn’t expect that FilteredHandler has a different precondition, since it should be the same for Handler and all its subclasses

/// Solution below
class ResolutionHandler {
  
  func save(string: String, minChars: Int = 0) {
    guard string.count >= minChars else { return }
    
    /// Save string in the Cloud
  }
}

// MARK: - Postconditions changes
/// Example
class Rectangle {
  
  var width: Float = 0
  var length: Float = 0
  
  var area: Float {
    return width * length
  }
}

class Square: Rectangle {
  
  override var width: Float {
    didSet {
      length = width
    }
  }
}

func printArea(of rectangle: Rectangle) {
  rectangle.length = 5
  rectangle.width = 2
  print(rectangle.area)
}

let rectangle = Rectangle()
printArea(of: rectangle) /// Result will be 10

let square = Square()
printArea(of: square) /// Result will be 4

/// We have just broken the postcondition of the width setter which is: ((width == newValue) && (height == height))

/// Solution below

protocol Polygon {
  var area: Float { get }
}

class ResolutionRectangle: Polygon {
  
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

class  ResolutionSquare: Polygon {
  
  private let side: Float
  
  init(side: Float) {
    self.side = side
  }
  
  var area: Float {
    return pow(side, 2)
  }
}

/// Client Method

func printArea(of polygon: Polygon) {
  print(polygon.area)
}

let resolutionRectangle =  ResolutionRectangle(width: 2, length: 5)
printArea(of: resolutionRectangle) /// Result will be 10

let resolutionSquare =  ResolutionSquare(side: 2)
printArea(of: resolutionSquare) /// Result will be 4
