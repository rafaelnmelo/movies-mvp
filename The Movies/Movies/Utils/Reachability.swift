import Foundation
import Alamofire

class Reachability {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
