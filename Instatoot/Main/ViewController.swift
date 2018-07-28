//
//  ViewController.swift
//  Instatoot
//
//  Created by Peter de Tagyos on 7/21/18.
//  Copyright © 2018 Peter de Tagyos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LoginViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func testAuth(_ sender: Any) {
        
        let testInstance = "https://mastodon.technology"
        var clientID = ""
        
        let client = Client(baseURL: testInstance)
        let request = Clients.register(clientName: "Instatoot", redirectURI: "itoot://oauth-response/success", scopes: [.read, .write, .follow], website: nil)
        client.run(request) { (resp) in
            if let app = resp.value {
                print("AppID: \(app.id)  Client ID: \(app.clientID)")
                clientID = app.clientID
            
                let sb = UIStoryboard(name: "Login", bundle: nil)
                if let vc: LoginViewController = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    vc.baseInstanceUrl = testInstance
                    vc.clientKey = clientID
                    vc.delegate = self
                    vc.modalTransitionStyle = .coverVertical

                    self.present(vc, animated: true, completion: nil)
                }
            }
        }

    }
    
    // MARK: - LoginViewControllerDelegate Methods
    
    func loginSuccessful(token: String) {
        L.debug("Got auth token: \(token)")
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

