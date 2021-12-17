import UIKit

public protocol ChaperoneRouter {
    func move()
}

public protocol StatusBarChangeable: AnyObject {
    var statusBarStyle: UIStatusBarStyle { get set }
}

// MARK: - Support classes

public final class MRWindow: UIWindow {
    class func create(level: UIWindow.Level? = nil,
                      frame: CGRect = UIScreen.main.bounds,
                      statusBarStyle: UIStatusBarStyle? = nil) -> UIWindow {
        let windowLavel = level ?? UIWindow.Level.alert + 1
        let alertWindow = MRWindow(frame: frame)
        let controller = MRViewController()
        let test = UIApplication.shared.windows.filter { $0.windowLevel < UIWindow.Level.alert && $0.isKeyWindow }.last
        let root = test?.rootViewController
        if let style = statusBarStyle {
            controller.style = style
        } else if let presented = root?.presentedViewController {
            if let style = (presented as? UINavigationController)?.viewControllers.last?.preferredStatusBarStyle {
                controller.style = style
            } else {
                controller.style = presented.preferredStatusBarStyle
            }
        } else if let style = (root as? UINavigationController)?.viewControllers.last?.preferredStatusBarStyle {
            controller.style = style
        } else if let style = root?.preferredStatusBarStyle {
            controller.style = style
        }
        
        alertWindow.rootViewController = controller
        alertWindow.windowLevel = windowLavel
        alertWindow.makeKeyAndVisible()
        return alertWindow
    }
}

private class MRViewController: UIViewController {
    var style: UIStatusBarStyle = .lightContent
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
}

public final class ObjectAssociation<T: AnyObject> {
    
    private let policy: objc_AssociationPolicy
    
    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }
    
    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        get { objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as? T }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

private extension UIViewController {
    private static let association = ObjectAssociation<UIWindow>()
    
    var storedWindow: UIWindow? {
        
        get { return Self.association[self] }
        set { Self.association[self] = newValue }
    }
}
