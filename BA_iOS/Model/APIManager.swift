import Alamofire

class APIManager {
    
    private let manager: Alamofire.SessionManager
    private let baseURL = URL(string: "https://danielmueller.fwd.wf/api/schedules//")!

    init() {
        let defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        
        self.manager = Alamofire.SessionManager(configuration: configuration)
    }
    func eventsRequest() {
        manager.request(baseURL).response { response in
            //print("Request: \(response.request)")
            print("Response: \(response.data)")
            //print("Error: \(response.error)")
        }
    }
}
