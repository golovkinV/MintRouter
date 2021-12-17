//
//  ModalRouter.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation
import UIKit

public class ModalRouter: NSObject, ChaperoneRouter {
    let target: UIViewController
    let parent: UIViewController?
    
    public var windowLevel: UIWindow.Level = .normal
    
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
    
    private func presentModal(_ controller: UIViewController, from parent: UIViewController, completion: ActionFunc? = nil) {
        parent.present(controller, animated: true, completion: completion)
    }
    
    private func presentModal(_ controller: UIViewController, completion: ActionFunc? = nil) {
        let windowLevel = self.windowLevel + CGFloat(UIApplication.shared.windows.count)
        let window: UIWindow? = MRWindow.create(level: windowLevel)
        controller.storedWindow = window
        DispatchQueue.main.async {
            window?.rootViewController?.present(controller, animated: true, completion: completion)
        }
    }
}

public extension ModalRouter {
    func move(completion: ActionFunc?) {
        if let vc = parent {
            self.presentModal(self.target, from: vc, completion: completion)
        } else {
            self.presentModal(self.target, completion: completion)
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
