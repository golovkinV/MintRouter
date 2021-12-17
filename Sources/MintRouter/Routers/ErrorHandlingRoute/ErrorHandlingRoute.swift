//
//  ErrorHandlingRoute.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation

public protocol ErrorHandling {
    func handle(error: Error) -> Bool
}

public protocol ErrorHandlingRoute {
    func show(title: String, error: Error)
}

public extension ErrorHandlingRoute where Self: BaseCoordinatorRoutable {
    func show(title: String, error: Error) {
        if let handler = self.controller as? ErrorHandling {
            if handler.handle(error: error) {
                return
            }
        }
        MRAppAlertController.alert(title, message: error.message)
    }
}

// MARK: - Error extension

public extension Error {
    var message: String {
        if let text = self._userInfo?[NSLocalizedDescriptionKey] as? String {
            return text
        }
        return "\(self)"
    }
}
