//
//  Connectivity.swift
//  StockPrice
//
//  Created by Slava on 5/12/21.
//

import Foundation
import Alamofire

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
