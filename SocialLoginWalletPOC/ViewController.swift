//
//  ViewController.swift
//  SocialLoginWalletPOC
//
//  Created by Aakarshit Jaswal on 14/01/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    let apiKey = "TEST_API_KEY:f90bd4d8467609d433d5ffdabae4c543:20913c2458fd95296dae8226ef221724"
    var myAppID = ""
    var myuserID = ""
    var myUsername = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAppID()
        // Do any additional setup after loading the view.
    }

    func getAppID() {
        let url = URL(string: "https://api.circle.com/v1/w3s/config/entity")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if httpResponse.statusCode == 200 {
                // Successful response
                    if let responseData = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                               let data = json["data"] as? [String: Any],
                               let appID = data["appId"] as? String {
                                self.myAppID = appID
                                print("App ID: \(appID)")
                                self.createAUser()

                            } else {
                                print("Error parsing JSON")
                                
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
            } else {
                // Handle other HTTP status codes if needed
                print("HTTP status code: \(httpResponse.statusCode)")
            }
        }

        dataTask.resume()
    }

    func createAUser() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let UUID = UUID().uuidString

        let parameters: Parameters = ["userId": UUID]

        AF.request("https://api.circle.com/v1/w3s/users",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseString { response in
                 switch response.result {
                 case .success(let value):
                     print(value)
                 case .failure(let error):
                     print("Error: \(error.localizedDescription)")
                 }
             }
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        print("Response Headers: \(response.request?.allHTTPHeaderFields ?? [:])")
                        print(json)
                    } else {
                        print("Caught")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }




}

