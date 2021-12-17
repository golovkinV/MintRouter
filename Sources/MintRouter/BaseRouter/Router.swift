import UIKit

public protocol RouteCommand {}

public protocol RouterCommandResponder: AnyObject {
    func respond(command: RouteCommand) -> Bool
}

public protocol Router: AnyObject {
    var parentRouter: Router? { get }
    var responder: RouterCommandResponder? { get set }
    func execute(_ command: RouteCommand)
}

public protocol RouterProtocol: Router {
    var controller: UIViewController! { get }
}

public protocol BaseRoutable: RouterProtocol {}

public class BaseRouter: BaseRoutable {
    public weak var controller: UIViewController!
    public weak var responder: RouterCommandResponder?
    
    public private(set) weak var parentRouter: Router?
    
    public init(view: UIViewController, parent: Router? = nil) {
        self.controller = view
        self.parentRouter = parent
    }
    
    public func execute(_ command: RouteCommand) {
        if self.responder?.respond(command: command) == true {
            return
        }
        self.parentRouter?.execute(command)
    }
}
