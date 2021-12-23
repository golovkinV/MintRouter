//
//  ShareRoute.swift
//  
//
//  Created by Vladimir Golovkin on 16.12.2021.
//

import UIKit

public protocol ShareRoute where Self: BaseCoordinatorRoutable {
    func openShare(url: URL)
}

public extension ShareRoute {
    func openShare(url: URL) {
        let module = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        ModalRouter(target: module, parent: self.controller).move()
    }
}
