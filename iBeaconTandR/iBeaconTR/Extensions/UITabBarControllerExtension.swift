//
//  UITabBarControllerExtension.swift
//  iBeaconTR
//

import UIKit

extension UITabBarController {
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.selectedViewController
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }
}
