//
//  Configuration.swift
//  iBeaconSender
//

import Foundation

class iBeaconConfiguration {
    static let uuid = UUID(uuidString: "B58185D4-0D49-4019-A557-44B785DF5CC5")!
//    static let major = arc4random() % 10 + 1
    static let major = 1
    static let minor = arc4random() % 200 + 1
    static let identifier = "PaulT"
    private init() {}
}
