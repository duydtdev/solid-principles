//: Playground - noun: a place where people can play

import UIKit

/// Every time you create/change a class, you should ask yourself: How many responsibilities does this class have?

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

///================================================

/// You can solve this problem moving the responsibilities down to little classes
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

class APIHandler {
  
  func requestDataToAPI() -> Data {
    /// Send API request and wait the response
    return Data()
  }
}

class ParseHandler {
  
  func parse(data: Data) -> [String] {
    /// Parse the data and create the array
    return [""]
  }
}

class DBHandler {
  
  func saveToDB(array: [String]) {
    /// Save the array in a database (CoreData/Realm/...)
  }
}

