//: Playground - noun: a place where people can play

import UIKit

// MARK: - Fat interface (Protocol)
/// Example
protocol GestureProtocol {
  func didTap()
  func didDoubleTap()
  func didLongPress()
}

/// SuperButton is happy to implement the methods which it needs
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

/// The problem is that our app has also a PoorButton which needs just didTap
class PoorButton: GestureProtocol {
  func didTap() {
    /// Send tap action
  }
  
  func didDoubleTap() { }
  
  func didLongPress() { }
}

/// Solution below

protocol TapProtocol {
  func didTap()
}

protocol DoubleTapProtocol {
  func didDoubleTap()
}

protocol LongPressProtocol {
  func didLongPress()
}

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

class ResolutionPoorButton: TapProtocol {
  func didTap() {
    /// Send tap action
  }
}

// MARK: - Fat interface (Class)
/// Example
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

/// We are injecting too many information in the method play, since it needs just url, title and duration
/// Solution below

protocol Playable {
  var title: String { get }
  var url: String { get }
  var duration: Int { get }
}

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
