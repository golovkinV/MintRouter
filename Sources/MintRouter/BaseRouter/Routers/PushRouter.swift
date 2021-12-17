//
//  PushRouter.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation
import UIKit

public class PushRouter: ChaperoneRouter {
    let target: UIViewController
    let parent: UIViewController
    let drop: Drop
    
    public enum Drop {
        case none
        case last
        case all
        case custom(Int)
    }
    
    public init(target: UIViewController, parent: UIViewController, drop: Drop = .none) {
        self.target = target
        self.parent = parent
        self.drop = drop
    }
    
    public func move() {
        if let nc = parent.navigationController {
            self.present(self.target, using: nc)
        }
    }
    
    private func present(_ controller: UIViewController, using ncontroller: UINavigationController) {
        if ncontroller.topViewController == controller {
            return
        }
        
        switch self.drop {
        case .last:
            let controllers = Array(ncontroller.viewControllers.dropLast()) + [controller]
            ncontroller.setViewControllers(controllers, animated: true)
        case .all:
            ncontroller.setViewControllers([controller], animated: true)
        case let .custom(count):
            let controllers = Array(ncontroller.viewControllers.dropLast(count)) + [controller]
            ncontroller.setViewControllers(controllers, animated: true)
        default:
            ncontroller.pushViewController(controller, animated: true)
        }
    }
}
