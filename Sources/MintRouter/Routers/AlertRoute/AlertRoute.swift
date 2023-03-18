//
//  AlertRoute.swift
//  
//
//  Created by Vladimir Golovkin on 16.12.2021.
//

import UIKit
import Combine

public enum ConfimationEnum {
    case cancel
    case confirm
    case custom(completion: () -> Void)
}

public typealias ActionFunc = () -> Void
public typealias Action<T> = (T) -> Void
public typealias AlertButton = (text: String, style: UIAlertAction.Style)

public protocol AlertRoute where Self: BaseCoordinatorRoutable {
    func openAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?, userData: Any?)
    func openAlert(title: String, message: String, buttons: [String], tapBlock: Action<Int>?)
    func openAlert(title: String, message: String)
    func openAlert(message: String)
    func openSheetAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?)
    func openSheetAlert(title: String, message: String, buttons: [String], tapBlock: Action<Int>?)
    func openRefreshAlert(title: String, message: String, buttonTitle: String, action: ActionFunc?)
    func openAlertPublisher<T>(title: String?, message: String?, actions: [UIAlertCombineAction<T>]) -> AnyPublisher<T, Never>
    func openSheetAlertPublisher<T>(title: String?, message: String?, cancelTitle: String?, actions: [UIAlertCombineAction<T>]) -> AnyPublisher<T, Never>
}

public extension AlertRoute {
    func openAlert(title: String, message: String, buttons: [AlertButton], tapBlock: Action<Int>?, userData: Any?) {
        MRAppAlertController.alert(title,
                                   message: message,
                                   buttons: buttons,
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
    
    func openSheetAlert(title: String, message: String, buttons: [AlertButton], cancelTitle: String?, tapBlock: Action<Int>?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alertSheet(title, message: message, buttons: buttons, cancelTitle: cancelTitle, tapBlock: tapBlock)
    }

    func openSheetAlert(title: String, message: String, buttons: [String], cancelTitle: String?, tapBlock: Action<Int>?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alertSheet(title, message: message, buttons: buttons, cancelTitle: cancelTitle, tapBlock: tapBlock)
    }
    
    func openRefreshAlert(title: String, message: String, buttonTitle: String, action: ActionFunc?) {
        MRAppAlertController.viewController = self.controller
        MRAppAlertController.alert(title,
                                   message: message,
                                   buttons: [AlertButton(text: buttonTitle, style: .default)]) { _ in
            action?()
        }
    }
    
    func openAlertPublisher<T>(title: String?, message: String?, actions: [UIAlertCombineAction<T>]) -> AnyPublisher<T, Never> {
        return MRAppAlertController.alertPublisher(title,
                                                   message: message)
        .show(presenter: self.controller, actions: actions)
    }
    
    func openSheetAlertPublisher<T>(title: String?, message: String?, cancelTitle: String?, actions: [UIAlertCombineAction<T>]) -> AnyPublisher<T, Never> {
        return MRAppAlertController.sheetAlertPublisher(title,
                                                        message: message,
                                                        cancelTitle: cancelTitle)
        .show(presenter: self.controller, actions: actions)
    }
}

public struct UIAlertCombineAction<T> {
    public let title: String?
    public let style: UIAlertAction.Style
    public let event: T
    public let titleColor: UIColor?

    public init(title: String? = nil,
                style: UIAlertAction.Style,
                event: T,
                titleColor: UIColor? = nil) {
        self.title = title
        self.style = style
        self.event = event
        self.titleColor = titleColor
    }
}

extension UIAlertController {
    func show<T>(presenter: UIViewController, actions: [UIAlertCombineAction<T>]) -> AnyPublisher<T, Never> {
        return Deferred {
            Future<T, Never>() { [unowned self] resolve in
                actions.forEach { action in
                    let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                        resolve(.success(action.event))
                    }
                    alertAction.setValue(action.titleColor, forKey: "titleTextColor")
                    self.addAction(alertAction)
                }
                presenter.present(self, animated: true)
            }
        }.handleEvents(receiveCancel: {
            presenter.dismiss(animated: true)
        }).eraseToAnyPublisher()
    }
}
