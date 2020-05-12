# Viper Sample

## Introduction:

This project is created to understand the working of Viper Sample. It also gives you a clear insight of how control flows through each component of Viper.

Here , we are implementing our beloved API-Master project to get the data from the Server from the Viper layer


---------------------------------------------------------------------------------------------------

## Installation:

There is no specific installation needed for this implementation.


----------------------------------------------------------------------------------------------------

## Configuration:

There is no specific configuration needed for this implementation.

----------------------------------------------------------------------------------------------------

## Coding Part - Handlers:

There are two handlers used in  this project. (i) Service Interaction and Network Reachability 

### Service Interaction

To make API Calls to the server.

```
    //MARK: - Service Interaction - Generic
    class ServiceInteraction {
        
        static func apiCall(urlString:String,httpMethod:APIMethod,foregroundAPICall:Bool,parameters:Dictionary<String, String>?,completionBlock: @escaping (Data) -> Void) -> Void
        {
            
            
            if !Reachability.isInternetAvailable() {
                return
            }
            
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.httpMethod = httpMethod.description
            
            //Passing Parameter
            if httpMethod != .GET {
                if let param = parameters {
                    request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
                } else {
                    print("Pass body parameter")
                }
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.setValue(Constants.URLS.HEADER_VALUE, forHTTPHeaderField: Constants.URLS.HEADER_KEY)
            
            //API Time Out
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest = Constants.ApplicationGenerics.APIs.MINIMUM_TIMEOUT
            session.configuration.timeoutIntervalForResource = Constants.ApplicationGenerics.APIs.MINIMUM_TIMEOUT
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                
                guard let data = data else {
                    return
                }
                completionBlock(data)
            })
            task.resume()
        }
        
    }


    //MARK: - HTTP Method
    enum APIMethod {
        
        case GET
        case POST
        case PUT
        case DELETE
        
        var description : String {
         
            switch self {
          
          case .GET: return "GET"
          case .POST: return "POST"
          case .PUT: return "PUT"
          case .DELETE: return "DELETE"
          }
            
        }
        
    }




```

### Network Reachability

To check the network connectivity of the mobile.

```
    public class Reachability {

        class func isInternetAvailable() -> Bool {
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)

            return (isReachable && !needsConnection)
            
        }

        class func isInternetAvailable(vc:UIViewController) -> Bool {
            if isInternetAvailable() {
                return true
            } else {
                Toast.showasync(message: Constants.UserMessages.INTERNET_FAILED, controller: vc)
                return false
            }
        }
    }


```


----------------------------------------------------------------------------------------------------

## Helper Part

### Toast is used to display the User Messages and App Router is used to set the root view controller of the app.

----------------------------------------------------------------------------------------------------

## Viper Architecture

### Protocols

To control the flow of control across the components of Viper.

```
    protocol EmployeePresenterToViewProtocol: class {
        func showEmployees(employee: EmployeeResponse)
        func showError()
    }

    protocol EmployeeInteractorToPresenterProtocol: class {
        func employeeListFeed(employee: EmployeeResponse)
        func employeeListFetchedFailed()
    }

    protocol EmployeePresentorToInteractorProtocol: class {
        var presenter: EmployeeInteractorToPresenterProtocol? {get set}
        func fetchEmployeeList()
    }

    protocol EmployeeViewToPresenterProtocol: class {
        var view: EmployeePresenterToViewProtocol? {get set}
        var interactor: EmployeePresentorToInteractorProtocol? {get set}
        var router: EmployeePresenterToRouterProtocol? {get set}
        func showEmployees()
    }

    protocol EmployeePresenterToRouterProtocol: class {
        static func start() -> UIViewController
    }

```

### Router

To instantiate the View controller and link the components of the Viper. It acts as bridge between the components.


```
class EmployeeRouter: EmployeePresenterToRouterProtocol{
    
    class func start() ->UIViewController{
        let view = getStoryBoard.instantiateViewController(withIdentifier: "EmployeeViewController") as? EmployeeViewController
        //if let view = navController.childViewControllers.first as? LiveNewsViewController {
            let presenter: EmployeeViewToPresenterProtocol & EmployeeInteractorToPresenterProtocol = EmployeePresenter()
            let interactor: EmployeePresentorToInteractorProtocol = EmployeeInteractor()
            let router: EmployeePresenterToRouterProtocol = EmployeeRouter()
            
            view?.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            return view!;
            
        //}
        
        //return UIViewController()
    }
    
    static var getStoryBoard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}

```

### Entity

The Model layer where the data model is defined which will be passed through the components.


```
//MARK: - Employee Response Model
struct EmployeeResponse: Codable {
    let data: [UserData]
    let ad: Ad

    enum CodingKeys: String, CodingKey {
        case data, ad
    }
}

struct Ad: Codable {
    let company: String
    let url: String
    let text: String
}

struct UserData: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}
```

### Interactor

It interacts with the API handler and gives the data to the Interactor and it will be sent to the Presenter

```
//MARK: - Employee Interactor - API Call
class EmployeeInteractor: EmployeePresentorToInteractorProtocol{

    var presenter: EmployeeInteractorToPresenterProtocol?
    
    func fetchEmployeeList() {
        
        let urlString = Constants.URLs.API_URL
        
        ServiceInteraction.apiCall(urlString: urlString, httpMethod: .GET,foregroundAPICall: true, parameters: nil) { (responseData) in
            do {
                let response = try JSONDecoder().decode(EmployeeResponse.self, from: responseData)
                self.presenter?.employeeListFeed(employee: response)
            } catch let jsonResponseError {
                print(jsonResponseError.localizedDescription)
                self.presenter?.employeeListFetchedFailed()
            }
        }
        
    }
}


```

### Presenter

It is the nucleus of the Viper and connects and faciliatetes the data flow. 

```
//MARK: - Employee Presenter
class EmployeePresenter: EmployeeViewToPresenterProtocol {
    
    var view: EmployeePresenterToViewProtocol?
    var interactor: EmployeePresentorToInteractorProtocol?
    var router: EmployeePresenterToRouterProtocol?
    
    func showEmployees() {
        interactor?.fetchEmployeeList()
    }
}

//MARK: - Subscribing - Employee Interactor
extension EmployeePresenter: EmployeeInteractorToPresenterProtocol {
    
    func employeeListFeed(employee: EmployeeResponse) {
        view?.showEmployees(employee: employee)
    }
    
    func employeeListFetchedFailed(){
        view?.showError()
    }
}


```

### View

It connect the storyboard and responsible for View Actions. 

```
//MARK: - View Controller - Initialization
class EmployeeViewController: UIViewController {

    var presenter: EmployeeViewToPresenterProtocol?
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.showEmployees()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Presenter - delegates
extension EmployeeViewController: EmployeePresenterToViewProtocol {

    func showEmployees(employee: EmployeeResponse) {
        print("success")
        Toast.showasync(message: "success", controller: self)
    }
    
    func showError() {
        print("failed")
        Toast.showasync(message: "failed", controller: self)
    }
}

```



### Check out my Post about Viper Sample: [Project Name](https://vijaysn.com/2020/04/23/ios-av-player/)


