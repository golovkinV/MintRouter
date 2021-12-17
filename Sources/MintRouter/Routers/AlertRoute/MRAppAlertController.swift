//
//  MRAppAlertController.swift
//  
//
//  Created by Vladimir Golovkin on 16.12.2021.
//

import UIKit

// MARK: Alert Manager

public class MRAppAlertController {
    static var viewController: UIViewController!
    private static var alertFactory: AlertViewFactory = DefaultAlertViewFactory()
    private static var sheetAlertFactory: AlertViewFactory = DefaultSheetAlertViewFactory()

    @discardableResult
    public static func set(alertFactory: AlertViewFactory) -> MRAppAlertController.Type {
        self.alertFactory = alertFactory
        return self
    }

    @discardableResult
    public static func set(alertPresent: AlertPresentProtocol) -> MRAppAlertController.Type {
        return self
    }

    public static func alert(_ title: String,
                             message: String = "",
                             acceptMessage: String = "OK",
                             userData: Any? = nil,
                             acceptBlock: (() -> Void)? = nil) {
        let buttons = [AlertButton(acceptMessage, .default)]
        let alert = self.alertFactory.create(title,
                                             message: message,
                                             buttons: buttons,
                                             userData: userData) { _ in
            acceptBlock?()
        }
        viewController.present(alert, animated: true, completion: nil)
    }

    public static func alertSheet(_ title: String,
                                  message: String,
                                  buttons: [String],
                                  userData: Any? = nil,
                                  tapBlock: ((Int) -> Void)? = nil) {
        let alertButtons = buttons.map { AlertButton($0, .default) }
        let alert = self.sheetAlertFactory.create(title,
                                                  message: message,
                                                  buttons: alertButtons,
                                                  userData: userData) {
                                                    tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func alertSheet(_ title: String,
                                  message: String,
                                  buttons: [AlertButton],
                                  userData: Any? = nil,
                                  tapBlock: ((Int) -> Void)? = nil) {
        
        let alert = self.sheetAlertFactory.create(title,
                                                  message: message,
                                                  buttons: buttons,
                                                  userData: userData) {
                                                    tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }


    public static func alert(_ title: String,
                             message: String,
                             buttons: [String],
                             userData: Any? = nil,
                             tapBlock: ((Int) -> Void)? = nil) {
        let alertButtons = buttons.map { AlertButton($0, .default) }
        let alert = self.alertFactory.create(title,
                                             message: message,
                                             buttons: alertButtons,
                                             userData: userData) {
            tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }

    public static func alert(_ title: String,
                             message: String,
                             buttons: [AlertButton],
                             userData: Any? = nil,
                             tapBlock: ((Int) -> Void)? = nil) {
        let alert = self.alertFactory.create(title,
                                             message: message,
                                             buttons: buttons,
                                             userData: userData) {
            tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Alert manager

private final class MRAlertManager {
    private var alertsBuffer: [UIViewController] = []
    private var presented: UIViewController?
    private var alertPresent: AlertPresentProtocol = DefaultAlertPresent()

    public func set(alertPresent: AlertPresentProtocol) {
        self.alertPresent = alertPresent
    }

    func presentIfCan(_ alert: UIViewController) {
        if self.presented != nil {
            self.alertsBuffer.append(alert)
            return
        }
        self.presented = alert
        self.presented?.view.layer.zPosition = 100000
        self.alertPresent.show(alert)
    }

    func presentNextIfNeeded() {
        self.presented = nil
        if self.alertsBuffer.isEmpty {
            return
        }
        let alert = self.alertsBuffer.removeFirst()
        self.presented = alert
        self.alertPresent.show(alert)
    }
}

// MARK: - Alert Present

public protocol AlertPresentProtocol {
    func show(_ alert: UIViewController)
}

public struct DefaultAlertPresent: AlertPresentProtocol {
    public func show(_ alert: UIViewController) {}
}

// MARK: - Alert Factory

public protocol AlertViewFactory {
    func create(_ title: String,
                message: String,
                buttons: [AlertButton],
                userData: Any?,
                tapBlock: ((Int) -> Void)?) -> UIViewController
}

private struct DefaultAlertViewFactory: AlertViewFactory {
    public func create(_ title: String,
                       message: String,
                       buttons: [AlertButton],
                       userData: Any?,
                       tapBlock: ((Int) -> Void)?) -> UIViewController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (offset, item) in buttons.enumerated() {
            alert.addAction(UIAlertAction(title: item.text, style: item.style, handler: { _ in
                tapBlock?(offset)
            }))
        }
        return alert
    }
}

private struct DefaultSheetAlertViewFactory: AlertViewFactory {
    public func create(_ title: String,
                       message: String,
                       buttons: [AlertButton],
                       userData: Any?,
                       tapBlock: ((Int) -> Void)?) -> UIViewController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (offset, item) in buttons.enumerated() {
            alert.addAction(UIAlertAction(title: item.text, style: item.style, handler: { _ in
                tapBlock?(offset)
            }))
        }
        alert.addAction(UIAlertAction(title: title, style: .cancel, handler: { _ in
            tapBlock?(buttons.count + 1)
        }))
        return alert
    }
}

// MARK: - Support extensions

private extension UIAlertAction {
    convenience init(title: String?,
                     preferredStyle: UIAlertAction.Style,
                     buttonIndex: Int,
                     tapBlock: ((UIAlertAction, Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) { action in
            if let block = tapBlock {
                block(action, buttonIndex)
            }
        }
    }
}
