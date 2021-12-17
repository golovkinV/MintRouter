//
//  ShowWindowRouter.swift
//
//
//  Created by Nikita Abramenko on 02.09.2021.
//

import Foundation
import UIKit

public final class ShowWindowRouter: ChaperoneRouter {
    let target: UIViewController
    let window: UIWindow
    let transition: WindowTransition
    
    public init(target: UIViewController, window: UIWindow, transition: WindowTransition = FadeWindowTransition()) {
        self.target = target
        self.window = window
        self.transition = transition
    }
    
    public func move() {
        self.present(self.target, using: self.window)
    }
    
    private func present(_ controller: UIViewController, using window: UIWindow) {
        let windows = UIApplication.shared.windows.filter {
            $0 != window
        }
        for other in windows {
            self.transition.prepareForDissmiss(other)
            self.transition.animator
                .run(animation: {
                    self.transition.animateDissmiss(other)
                }, completion: {
                    other.isHidden = true
                    other.rootViewController?.dismiss(animated: false)
                })
        }
        if let old = window.rootViewController {
            old.dismiss(animated: false, completion: {
                old.view.removeFromSuperview()
            })
        }
        
        self.transition.prepareForShow(window)
        self.transition.animator.run(animation: {
            self.transition.animateShow(window)
        })
        
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
