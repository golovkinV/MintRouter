//
//  HeaderModalRouter.swift
//
//
//  Created by Nikita Abramenko on 02.09.2021.
//

import Foundation
import UIKit

public class HeaderModalRouter: NSObject, ChaperoneRouter {
    fileprivate let target: UIViewController
    fileprivate let parent: UIViewController?
    fileprivate var windowLevel: UIWindow.Level = .normal
    
    public init(target: UIViewController, parent: UIViewController?) {
        self.target = target
        self.parent = parent
        if parent == nil {
            self.target.modalPresentationStyle = .fullScreen
        }
    }
    
    public func set(level: UIWindow.Level) -> Self {
        self.windowLevel = level
        return self
    }
    
    public func move() {
        if let vc = parent {
            self.presentModal(self.target, from: vc)
        } else {
            self.presentModal(self.target)
        }
    }
    
    private func presentModal(_ controller: UIViewController, from parent: UIViewController) {
        parent.present(controller, animated: true, completion: {})
    }
    
    private func presentModal(_ controller: UIViewController) {
        let windowLevel = self.windowLevel + CGFloat(UIApplication.shared.windows.count)
        let window: UIWindow? = MRWindow.create(level: windowLevel)
        controller.storedWindow = window
        DispatchQueue.main.async {
            window?.rootViewController?.present(controller, animated: false)
        }
    }
}

private extension UIViewController {
    private static let association = ObjectAssociation<UIWindow>()
    
    var storedWindow: UIWindow? {
        get { return Self.association[self] }
        set { Self.association[self] = newValue }
    }
}
