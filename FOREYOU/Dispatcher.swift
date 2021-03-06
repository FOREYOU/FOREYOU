class Dispatcher
{
    enum DispatchLevel {
        case Main, UserInteractive, UserInitiated, Utility, Background
        var dispatchQueue: OS_dispatch_queue
        { switch self
        { case .Main: return dispatch_get_main_queue()
        case .UserInteractive: return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) case .UserInitiated: return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) case .Utility: return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0) case .Background: return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0) } } } func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .Main, closure: () -> Void) { let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))) dispatch_after(time, dispatchLevel.dispatchQueue, closure) } }
