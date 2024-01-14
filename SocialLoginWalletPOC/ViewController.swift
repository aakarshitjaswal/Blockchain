//
//  ViewController.swift
//  SocialLoginWalletPOC
//
//  Created by Aakarshit Jaswal on 14/01/24.
//

import UIKit

class ViewController: UIViewController {
    let apiKey = "TEST_API_KEY:f90bd4d8467609d433d5ffdabae4c543:20913c2458fd95296dae8226ef221724"
    var myAppID = ""
    var myuserID = ""
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
        let headers = [
          "Content-Type": "application/json",
          "Authorization": "Bearer \(apiKey)"
        ]
        
        let UUID = UUID().uuidString
        
        let parameters = ["userId": "\(UUID)"] as [String : Any]

        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

            let request = NSMutableURLRequest(url: NSURL(string: "https://api.circle.com/v1/w3s/users")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = postData

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                } else {
                    if let httpResponse = response as? HTTPURLResponse {
                            if let responseData = data {
                                do {
                                    
                                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                                       {
                                        print(json)
                                    } else {
                                        print("Cateched")
                                    }
                                } catch {
                                    print("Error: \(error.localizedDescription)")
                                }
                            }
                    }
                }
            }

            dataTask.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }




}

