//
//  BackRoute.swift
//  campus-ios
//
//  Created by Nikita Abramenko on 28.07.2021.
//

public protocol BackRoute where Self: BaseCoordinatorRoutable {
    func back()
    func backToRoot()
    func backToRoot(animation: Bool)
}

public extension BackRoute {
    func back() {
        if let nc = self.controller.navigationController, nc.viewControllers.first != self.controller {
            nc.popViewController(animated: true)
        } else {
            self.controller.dismiss(animated: true)
        }
    }

    func backToRoot() {
        self.backToRoot(animation: true)
    }

    func backToRoot(animation: Bool) {
        if let nc = self.controller.navigationController, nc.viewControllers.first != self.controller {
            nc.popToRootViewController(animated: animation)
        } else {
            self.controller.dismiss(animated: animation)
        }
    }
}
