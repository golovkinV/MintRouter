//
//  File.swift
//  
//
//  Created by Vladimir Golovkin on 16.12.2021.
//

import UIKit

public typealias ActionFunc = () -> Void
public typealias Action<T> = (T) -> Void
public typealias AlertButton = (text: String, style: UIAlertAction.Style)

public protocol AlertRoute where Self: BaseCoordinatorRoutable {
    func openAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?, userData: Any?)
    func openAlert(title: String, message: String, buttons: [String], tapBlock: Action<Int>?)
    func openAlert(title: String, message: String)
    func openAlert(message: String)
    func openSheetAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?)
    func openRefreshAlert(title: String, message: String, buttonTitle: String, action: ActionFunc?)
}

public extension AlertRoute {
    func openAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?, userData: Any?) {
        MRAppAlertController.alert(title,
                                   message: message,
                                   buttons: buttons,
                                   userData: userData,
                                   tapBlock: tapBlock)
    }
    
    func openAlert(title: String, message: String) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alert(title, message: message)
    }
    
    func openAlert(message: String) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alert(message)
    }
    
    func openAlert(title: String, message: String, buttons: [String], tapBlock: Action<Int>?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alert(title, message: message, buttons: buttons, tapBlock: tapBlock)
    }
    
    func openAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alert(title, message: message, buttons: buttons, tapBlock: tapBlock)
    }
    
    func openSheetAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alertSheet(title, message: message, buttons: buttons, tapBlock: tapBlock)
    }

    func openSheetAlert(title: String, message: String, buttons: [String], tapBlock: Action<Int>?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alertSheet(title, message: message, buttons: buttons, tapBlock: tapBlock)
    }
    
    func openRefreshAlert(title: String, message: String, buttonTitle: String, action: ActionFunc?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alert(title,
                                   message: message,
                                   buttons: [AlertButton(text: buttonTitle, style: .default)]) { _ in
            action?()
        }
    }
}
