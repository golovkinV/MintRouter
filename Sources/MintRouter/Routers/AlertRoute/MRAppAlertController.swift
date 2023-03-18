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
    
    public static func alertPublisher(_ title: String?,
                                      message: String? = "") -> UIAlertController {
        return self.alertFactory.create(title,
                                        message: message,
                                        buttons: [],
                                        cancelTitle: nil,
                                        tapBlock: nil)
    }
    
    public static func sheetAlertPublisher(_ title: String? = nil,
                                           message: String? = nil,
                                           cancelTitle: String? = "") -> UIAlertController {
        return self.sheetAlertFactory.create(title,
                                             message: message,
                                             buttons: [],
                                             cancelTitle: cancelTitle,
                                             tapBlock: nil)
    }

    public static func alert(_ title: String,
                             message: String = "",
                             acceptMessage: String = "OK",
                             acceptBlock: (() -> Void)? = nil) {
        let buttons = [AlertButton(acceptMessage, .default)]
        let alert = self.alertFactory.create(title,
                                             message: message,
                                             buttons: buttons,
                                             cancelTitle: nil) { _ in
            acceptBlock?()
        }
        viewController.present(alert, animated: true, completion: nil)
    }

    public static func alertSheet(_ title: String,
                                  message: String,
                                  buttons: [String],
                                  cancelTitle: String? = nil,
                                  tapBlock: ((Int) -> Void)? = nil) {
        let alertButtons = buttons.map { AlertButton($0, .default) }
        let alert = self.sheetAlertFactory.create(title,
                                                  message: message,
                                                  buttons: alertButtons,
                                                  cancelTitle: cancelTitle) {
                                                    tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func alertSheet(_ title: String,
                                  message: String,
                                  buttons: [AlertButton],
                                  cancelTitle: String? = nil,
                                  tapBlock: ((Int) -> Void)? = nil) {
        
        let alert = self.sheetAlertFactory.create(title,
                                                  message: message,
                                                  buttons: buttons,
                                                  cancelTitle: cancelTitle) {
                                                    tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }


    public static func alert(_ title: String,
                             message: String,
                             buttons: [String],
                             tapBlock: ((Int) -> Void)? = nil) {
        let alertButtons = buttons.map { AlertButton($0, .default) }
        let alert = self.alertFactory.create(title,
                                             message: message,
                                             buttons: alertButtons,
                                             cancelTitle: nil) {
            tapBlock?($0)
        }
        viewController.present(alert, animated: true, completion: nil)
    }

    public static func alert(_ title: String,
                             message: String,
                             buttons: [AlertButton],
                             tapBlock: ((Int) -> Void)? = nil) {
        let alert = self.alertFactory.create(title,
                                             message: message,
                                             buttons: buttons,
                                             cancelTitle: nil) {
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
    func create(_ title: String?,
                message: String?,
                buttons: [AlertButton],
                cancelTitle: String?,
                tapBlock: ((Int) -> Void)?) -> UIAlertController
}

private struct DefaultAlertViewFactory: AlertViewFactory {
    public func create(_ title: String?,
                       message: String?,
                       buttons: [AlertButton] = [],
                       cancelTitle: String? = nil,
                       tapBlock: ((Int) -> Void)? = nil) -> UIAlertController {
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
    public func create(_ title: String?,
                       message: String?,
                       buttons: [AlertButton] = [],
                       cancelTitle: String? = nil,
                       tapBlock: ((Int) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (offset, item) in buttons.enumerated() {
            alert.addAction(UIAlertAction(title: item.text, style: item.style, handler: { _ in
                tapBlock?(offset)
            }))
        }
        
        guard let cancelTitle = cancelTitle else { return alert }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
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
