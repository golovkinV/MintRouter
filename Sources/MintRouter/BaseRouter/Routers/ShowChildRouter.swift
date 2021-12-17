//
//  ShowChildRouter.swift
//
//
//  Created by Nikita Abramenko on 02.09.2021.
//

import Foundation
import UIKit

public protocol ChildNavigationContainer: UIViewController {
    var childContainerView: UIView? { get }
}

public class ShowChildRouter: ChaperoneRouter {
    let target: UIViewController
    let parent: UIViewController
    let container: UIView?
    
    public init(target: UIViewController, parent: UIViewController) {
        self.target = target
        self.parent = parent
        self.container = (parent as? ChildNavigationContainer)?.childContainerView
    }
    
    public func move() {
        self.presentChild(self.target, from: self.parent, in: self.container)
    }
    
    private func presentChild(_ controller: UIViewController, from parent: UIViewController, in container: UIView?) {
        if let view = container ?? parent.view {
            let old = parent.children.first
            old?.view.removeFromSuperview()
            old?.removeFromParent()
            parent.addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(controller.view)
            NSLayoutConstraint.activate([
                controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                controller.view.topAnchor.constraint(equalTo: view.topAnchor),
                controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            UIView.transition(with: view,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
