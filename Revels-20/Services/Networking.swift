//
//  Networking.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import Alamofire

struct UserKeys{
    static let sharedInstance = UserKeys()
    let mobile = "mobile"
    let firstName = "firstName"
    let lastName = "lastName"
    let userID = "userID"
    let email = "email"
    let loggedIn = "isLoggedIn"
    let active = "active"
}

let resultsURL = "https://api.mitrevels.in/results" //"https://api.techtatva.in/results"
let eventsURL = "https://api.mitrevels.in/events"
let scheduleURL = "https://api.mitrevels.in/schedule" //"https://api.techtatva.in/schedule"
let categoriesURL = "https://api.mitrevels.in/categories"
let delegateCardsURL = "https://api.mitrevels.in/delegate_cards"
let boughtDelegateCardsURL = "https://register.mitrevels.in/boughtCards"
let paymentsURL = "https://register.mitrevels.in/buy?card="
let mapsDataURL = "https://appdev.mitrevels.in/maps"
let collegeDataURL = "http://api.mitrevels.in/colleges"
let proshowURL = "https://appdev.mitrevels.in/proshow" //"http://aws.namanjain.me:3000/proshow/"
let sponsorsURL = "https://appdev.mitrevels.in/sponsors"

struct NetworkResponse <T: Decodable>: Decodable{
    let success: Bool
    let data: [T]?
}

let newsLetterURL = "http://newsletter-revels.herokuapp.com/pdf"

struct NewsLetterApiRespone: Decodable{
    let data: String?
}
struct Networking {
    
    let userSignUpURL = "https://register.mitrevels.in/signup/"
    let userPasswordForgotURL = "https://register.mitrevels.in/forgotPassword/"
    let userPasswordResetURL = "https://register.mitrevels.in/setPassword/"
    let userLoginURL = "https://register.mitrevels.in/login/"
    let userLogoutURL = "https://register.mitrevels.in/logout/"
    let userDetailsURL = "https://register.mitrevels.in/userProfile"
    let registerEventURL = "https://register.mitrevels.in/createteam"
    let getRegisteredEventsURL = "https://register.mitrevels.in/registeredEvents"
    let leaveTeamURL = "https://register.mitrevels.in/leaveteam"
    let addTeamMateURL = "https://register.mitrevels.in/addmember"

    
    let liveBlogURL = "http://revels.herokuapp.com/"
    
    static let sharedInstance = Networking()
    
    func getResults(dataCompletion: @escaping (_ Data: [Result]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(resultsURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(ResultsResponse.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Results Response Failed")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    func getData<T: Decodable>(url: String, decode: T, dataCompletion: @escaping (_ Data: [T]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){

        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(NetworkResponse<T>.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Response Failed in \(url)")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }

    // MARK: - Events
    
    func getCategories(dataCompletion: @escaping (_ Data: [Category]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(categoriesURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Events Response Failed")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    
    // MARK: - Users
    
    func registerUserWithDetails(name: String, email: String, mobile: String, reg: String, collname: String, dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "name": name,
            "email": email,
            "regno": reg,
            "mobile": mobile,
            "collname": collname,
            "type": "invisible",
            "g-recaptcha-response": serverToken,
            ] as [String : Any]
        
        Alamofire.request(userSignUpURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        dataCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func forgotPasswordFor(Email email: String, dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "email": email,
            "type": "invisible",
            "g-recaptcha-response": serverToken,
            ] as [String : Any]
        
        Alamofire.request(userPasswordForgotURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        dataCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func resetPassword(Token: String, Password: String, dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "token": Token,
            "password": Password,
            "password2": Password,
            ] as [String : Any]
        
        Alamofire.request(userPasswordResetURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        dataCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func loginUser(Email: String, Password: String, dataCompletion: @escaping (_ Data: User) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "email": Email,
            "password": Password,
            "type": "invisible",
            "g-recaptcha-response": serverToken,
            ] as [String : Any]
        self.logoutUser()
        Alamofire.request(userLoginURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        self.getUserDetails(dataCompletion: { (userData) in
                            dataCompletion(userData)
                        }, errorCompletion: { (errorMessage) in
                            errorCompletion(errorMessage)
                        })
                        
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func getUserDetails(dataCompletion: @escaping (_ Data: User) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(userDetailsURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Coudnt Fetch User Data")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    func getNewsLetterUrl(dataCompletion: @escaping (_ Data: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(newsLetterURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(NewsLetterApiRespone.self, from: data)
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }else{
                            errorCompletion("Unable to get Newletter URL")
                        }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    
    func logoutUser(){
        Alamofire.request(userLogoutURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
//            Caching.sharedInstance.saveUserDetailsToCache(user: nil)
            if let data = response.data{
                print(data)
            }
        }
    }
    
    
    //MARK: - EVENTS
    
    
    func registerEventWith(ID id: Int, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "eventid": id
            ] as [String : Any]
        
        Alamofire.request(registerEventURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        successCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func getRegisteredEvents(dataCompletion: @escaping (_ Data: [RegisteredEvent]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(getRegisteredEventsURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(RegisteredEventsResponse.self, from: data)
                    if resultsResponse.success{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Coudn't Fetch Registered Events")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    func leaveTeamForEventWith(ID id: Int, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "teamid": id
            ] as [String : Any]
        
        Alamofire.request(leaveTeamURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        successCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    func addTeamMateToEventWith(EventID id: Int, TeamMateDelegateID delid: String, successCompletion: @escaping (_ SuccessMessage: String) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        let parameters = [
            "eventid": id,
            "delid" : delid
            ] as [String : Any]
        
        Alamofire.request(addTeamMateURL, method: .post, parameters: parameters, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    if response.success{
                        successCompletion(response.msg)
                    }else{
                        print(response)
                        errorCompletion(response.msg)
                    }
                }catch let error{
                    errorCompletion("decoder_error")
                    print(error)
                }
            }
        }
    }
    
    
    // live blog url
    
    func getLiveBlogData(dataCompletion: @escaping (_ Data: [Blog]) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(liveBlogURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(BlogData.self, from: data)
                    if resultsResponse.numUpdates >= 0{
                        if let data = resultsResponse.data{
                            dataCompletion(data)
                        }
                    }else{
                        errorCompletion("Coudn't Fetch Registered Events")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
    func getProshowData(dataCompletion: @escaping (_ Data: ProResponse) -> (),  errorCompletion: @escaping (_ ErrorMessage: String) -> ()){
        
        Alamofire.request(proshowURL, method: .get, parameters: nil, encoding: URLEncoding()).response { response in
            if let data = response.data{
                do{
                    let resultsResponse = try JSONDecoder().decode(ProResponse.self, from: data)
                    if resultsResponse.success{
                        dataCompletion(resultsResponse)
                    }else{
                        errorCompletion("Coudn't Fetch Registered Events")
                    }
                }catch let error{
                    print(error)
                    errorCompletion("Decoding Error")
                }
            }
        }
    }
    
}
