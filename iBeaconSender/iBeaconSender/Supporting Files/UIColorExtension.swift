//
//  UIColorExtension.swift
//  iBeaconSender
//

import UIKit

extension UIColor {
    class func rgba(red: UInt, green: UInt, blue: UInt, alpha: CGFloat? = 1.0) -> Self {
        return self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha!
        )
    }
    
    class func deepFacebookColor() -> Self {
        return self.rgba(red: 66, green: 96, blue: 153)
    }
    
    class func iOSWhiteColor() -> Self {
        return self.rgba(red: 247, green: 247, blue: 247)
    }
    
    class func iOSBlueColor() -> Self {
        return self.rgba(red: 0, green: 122, blue: 255)
    }
}
