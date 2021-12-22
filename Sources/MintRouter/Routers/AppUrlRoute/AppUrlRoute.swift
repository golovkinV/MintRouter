//
//  AppUrlRoute.swift
//  
//
//  Created by Vladimir Golovkin on 22.12.2021.
//

import UIKit

public enum AppUrl {
    case phone(String)
    case web(URL?)
    case email(String)
    case appStore(String)
    case settings

    static func web(from string: String) -> AppUrl? {
        guard let url = URL(string: string) else {
            return nil
        }

        if UIApplication.shared.canOpenURL(url) {
            return .web(url)
        }

        return nil
    }
}

public protocol AppUrlRoute {
    func open(url: AppUrl)
}

public extension AppUrlRoute {
    func open(url: AppUrl) {
        var result: URL?

        switch url {
        case let .phone(value):
            if let number = value.stringByAddingPercentEncodingForURLQueryValue() {
                result = URL(string: "tel:\(number)")
            }
        case let .web(value):
            result = value
        case let .email(value):
            result = URL(string: "mailto:\(value)")
        case let .appStore(value):
            result = URL(string: "itms-apps://itunes.apple.com/app/\(value)")
        case .settings:
            result = URL(string: UIApplication.openSettingsURLString)
        }

        self.open(url: result)
    }

    private func open(url: URL?) {
        guard let url = url else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}

fileprivate extension String {
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
