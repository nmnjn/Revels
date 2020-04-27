
import Foundation
import Alamofire
//Private KEYS and constants

private let contentType       =    "application/json"
private let httpMethod        =    "POST"
private let keyContentType    =    "Content-Type"
private let keyToken          =    "token"
private let keyMessage        =    "message"
private let keyFile           =    "file"
private let keyFileName       =    "file.jpg"
private let keyFileType       =    "image/jpeg"

///API Structure
struct ApiStruct {
    
    /// URL of web service
    let url: String
    
    /// HTTP Method (GET/POST)
    let method: HTTPMethod
    
    /// Parameter Body
    let body: [String : Any]?
    
}

class WSManager {
    
    /// Shared instance of `WSManager`
    public static let shared = WSManager()
    public var apiRequest : DataRequest?
    // Initialize Alamofire Configurations
    private var manager: Alamofire.SessionManager
    private let configuration: URLSessionConfiguration
    
    
    private init() {
        // Default configuration
        configuration = URLSessionConfiguration.default
        
        // Timeout interval for web request
        configuration.timeoutIntervalForRequest = TimeInterval(30)
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    /// This method is used to hit web service, It returns response in respective blocks
    ///
    /// - Parameters:
    ///   - apiObject: It contains object of ApiStruct.
    ///   - onSuccess: This block is called when we receive positive response.
    ///   - onFailure: This block is called in case of internet error and server error.
    
    func prepareHeader () ->  [String : String]{
        var apiHeaders =  [String : String]()
        apiHeaders[keyContentType] = contentType
        //        apiHeaders[keyToken] = SharedPreference.sharedIntance.getUserDetail()?.value(forKeyPath: keyToken) as? String
        return apiHeaders
    }
    
    func getJSONResponse<D: Decodable>(apiStruct: ApiStruct, success:@escaping (_ response: D) -> Void, failure:@escaping(_ error: URLError)-> Void) {
        //   let queue = DispatchQueue(label: "com.test.com", qos: .background, attributes: .concurrent)
        //let url = URL.init(string: ApiManager.sharedInstance.KBASEURL + apiStruct.url)!
        apiRequest = self.manager.request(apiStruct.url, method: apiStruct.method , parameters: apiStruct.body, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.isSuccess {
                do {
                    let result: D = try JSONDecoder().decode(D.self, from: response.data!)
                    success(result)
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            else {
                if let err = response.result.error as? URLError {
                    failure(err)
                }else {
                    print("something went wrong")
                }
            }
        }
        
    }
}

