//: Playground - noun: a place where people can play

import UIKit

/// Example
class Handler {
  
  let fm = FilesystemManager()
  
  func handle(string: String) {
    fm.save(string: string)
  }
}

class FilesystemManager {
  
  func save(string: String) {
  }
}
/// FilesystemManager is the low-level module and it’s easy to reuse in other projects
/// We can solve this dependency using a protocol

class ResolutionHandler {
  
  let storage: Storage
  
  init(storage: Storage) {
    self.storage = storage
  }
  
  func handle(string: String) {
    storage.save(string: string)
  }
}

protocol Storage {
  
  func save(string: String)
}

class ResolutionFilesystemManager: Storage {
  
  func save(string: String) {
    /// Implement A features
  }
}

class ResolutionDatabaseManager: Storage {
  
  func save(string: String) {
    /// Implement B features
  }
}
