//
//  PresentRouter.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation
import UIKit

public final class PresentRouter<T: UIPresentationController>: ModalRouter, UIViewControllerTransitioningDelegate {
    let presentation: T.Type
    let configure: ((T) -> Void)?
    
    public init(target: UIViewController, from parent: UIViewController?, use presentation: T.Type, configure: ((T) -> Void)?) {
        self.presentation = presentation
        self.configure = configure
        super.init(target: target, parent: parent)
        
        self.target.modalTransitionStyle = .crossDissolve
        self.target.modalPresentationStyle = .custom
        self.target.modalPresentationCapturesStatusBarAppearance = true
        self.target.transitioningDelegate = self
    }
    
    public func set(_ modalPresentationStyle: UIModalPresentationStyle) -> Self {
        self.target.modalPresentationStyle = modalPresentationStyle
        return self
    }
    
    public override func move() {
        super.move()
    }
    
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let value = presentation.init(presentedViewController: presented, presenting: presenting)
        self.configure?(value)
        return value
    }
}
