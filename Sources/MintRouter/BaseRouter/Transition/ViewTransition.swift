//
//  ViewTransition.swift
//
//
//  Created by Nikita Abramenko on 02.09.2021.
//

import Foundation
import UIKit

public protocol ViewTransition {
    var animator: Animator { get }

    func prepareForDissmiss(_ view: UIView)
    func animateDissmiss(_ view: UIView)

    func prepareForShow(_ view: UIView)
    func animateShow(_ view: UIView)
}

public struct FadeViewTransition: ViewTransition {
    public var animator: Animator {
        return .normal(duration: 0.5, curve: .easeInOut)
    }

    public func prepareForDissmiss(_ view: UIView) {}

    public func animateDissmiss(_ view: UIView) {
        view.alpha = 0
    }

    public func prepareForShow(_ view: UIView) {
        view.alpha = 0
    }

    public func animateShow(_ view: UIView) {
        view.alpha = 1
    }
}

public struct PushViewTransition: ViewTransition {
    public var animator: Animator {
        return .spring(duration: 0.5, dumping: 1, velocity: 0, curve: .easeInOut)
    }

    public func prepareForDissmiss(_ view: UIView) {}

    public func animateDissmiss(_ view: UIView) {
        let width: CGFloat = -view.bounds.width * 0.3
        view.transform = CGAffineTransform(translationX: width, y: 0)
    }

    public func prepareForShow(_ view: UIView) {
        view.transform = CGAffineTransform(translationX: view.bounds.width, y: 0)
    }

    public func animateShow(_ view: UIView) {
        view.transform = .identity
    }
}

public struct FallViewTransition: ViewTransition {
    public var animator: Animator {
        return .spring(duration: 0.5, dumping: 0.7, velocity: 0, curve: .easeInOut)
    }

    public func prepareForDissmiss(_ view: UIView) {}

    public func animateDissmiss(_ view: UIView) {
        view.transform = .init(translationX: 0, y: -view.bounds.height - 50)
    }

    public func prepareForShow(_ view: UIView) {
        view.transform = .init(translationX: 0, y: -view.bounds.height - 50)
    }

    public func animateShow(_ view: UIView) {
        view.transform = .identity
    }
}
