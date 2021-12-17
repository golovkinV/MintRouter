//
//  BottomSheetRouter.swift
//
//
//  Created by Nikita Abramenko on 02.09.2021.
//

import Foundation
import FittedSheets
import UIKit

public final class BottomSheetRouter: NSObject, ChaperoneRouter {
        
    let target: UIViewController
    let parent: UIViewController?
    let sheetSizes: [SheetSize]
    let options: SheetOptions
    var windowLevel: UIWindow.Level = .normal
    
    public init(target: UIViewController,
         parent: UIViewController?,
         sheetSizes: [SheetSize] = [.fullscreen],
         options: SheetOptions = .init(
            presentingViewCornerRadius: 16,
            shouldExtendBackground: true,
            shrinkPresentingViewController: false)) {
        self.target = target
        self.parent = parent
        self.sheetSizes = sheetSizes
        self.options = options
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
                
        let sheetController = SheetViewController(controller: controller,
                                                  sizes: sheetSizes,
                                                  options: options)
                
        parent.present(sheetController, animated: true, completion: {})
    }
        
    private func presentModal(_ controller: UIViewController) {
        let windowLevel = self.windowLevel + CGFloat(UIApplication.shared.windows.count)
        let window: UIWindow? = MRWindow.create(level: windowLevel)
        controller.storedWindow = window
        DispatchQueue.main.async {
            window?.rootViewController?.present(controller, animated: true)
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

public extension BottomSheetRouter {
    func moveInline() {
        guard let vc = parent else { return }
        let sheetController = SheetViewController(controller: target,
                                                  sizes: sheetSizes,
                                                  options: options)
        sheetController.animateIn(to: vc.view, in: vc)
    }
}
