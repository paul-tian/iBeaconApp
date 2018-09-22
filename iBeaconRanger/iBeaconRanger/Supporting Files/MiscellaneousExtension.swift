//
//  MiscellaneousExtension.swift
//  iBeaconRanger
//
//  Created by Paul Tian
//  Copyright © 2018 Paul Tian. All rights reserved.
//

import Foundation

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
    
}

extension Double {
    
    static func intervalTime() -> Double {
        return  0.1
    }
    
}


