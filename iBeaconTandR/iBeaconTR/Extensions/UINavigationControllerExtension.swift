//
//  UINavigationControllerExtension.swift
//  iBeaconTR
//

import UIKit

extension UINavigationController {
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
