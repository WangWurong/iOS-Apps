//
//  ViewController.swift
//  InsClone
//
//  Created by oldFluffyRabbit on 8/3/19.
//  Copyright © 2019 大兔子殿下. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var signupModeActive = true // initial to sign up mode
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var signupOrLoginButton: UIButton!
    @IBOutlet var switchLoginModeButton: UIButton!
    
    @IBAction func signupOrLogin(_ sender: Any) {
        // check the input username and password
        if username.text == "" || password.text == "" {
            displayAlert(title: "Error in form", message: "Please enter an email and password")
        } else {
            
            if (signupModeActive) {
                // in the sign up mode
                // send the http request
                let signupURL = URL(string: "http://127.0.0.1:5000/signup")
                var request = URLRequest(url: signupURL!)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpMethod = "POST"
                let parameters: [String: Any] = [
                    "username": username.text!,
                    "password": password.text!
                ]
                let session = URLSession.shared
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            // handle json...
                            if (json["statusCode"] as! Int == 500) {
                                self.displayAlert(title: "Could not sign you up", message: json["message"] as! String)
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
                
            } else {
                // log in mode: log in
                let signupURL = URL(string: "http://127.0.0.1:5000/login")
                var request = URLRequest(url: signupURL!)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.httpMethod = "POST"
                let parameters: [String: Any] = [
                    "username": username.text!,
                    "password": password.text!
                ]
                let session = URLSession.shared
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }
                
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    
                    guard error == nil else {
                        return
                    }
                    
                    guard let data = data else {
                        return
                    }
                    
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            // handle json...
                            if (json["statusCode"] as! Int == 500) {
                                self.displayAlert(title: "Could not sign you up", message: json["message"] as! String)
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task.resume()
            }
           
        }
    }
    
    @IBAction func switchLoginMode(_ sender: Any) {
        // in sign up mode, switch to login page
        if (signupModeActive) {
            signupModeActive = false
            signupOrLoginButton.setTitle("Log In", for: [])
            switchLoginModeButton.setTitle("Sign Up", for: [])
        } else {
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign Up", for: [])
            switchLoginModeButton.setTitle("Log In", for: [])
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

