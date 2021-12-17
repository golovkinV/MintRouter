//
//  ShareRoute.swift
//  
//
//  Created by Vladimir Golovkin on 16.12.2021.
//

import UIKit

protocol ShareRoute {
    func openShare(url: URL)
}

extension ShareRoute where Self: BaseCoordinatorRoutable {
    func openShare(url: URL) {
        let module = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        ModalRouter(target: module, parent: self.controller).move()
    }
}
