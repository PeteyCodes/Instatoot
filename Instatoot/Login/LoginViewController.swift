//
//  LoginViewController.swift
//  Instatoot
//
//  Created by Peter de Tagyos on 7/21/18.
//  Copyright © 2018 Peter de Tagyos. All rights reserved.
//

import OAuthSwift
import UIKit
import WebKit


protocol LoginViewControllerDelegate: class {
    func loginSuccessful(token: String)
}


class LoginViewController: UIViewController, WKNavigationDelegate, OAuthSwiftURLHandlerType  {

    var baseInstanceUrl: String!
    var clientKey: String!
    weak var delegate: LoginViewControllerDelegate? = nil
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    private var isFirstLoad: Bool = true
    private var oauth2: OAuth2Swift? = nil

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            loadAuthPage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - OAuthSwiftURLHandlerType Methods
    
    func handle(_ url: URL) {
        print("Loading URL: \(url.absoluteString)")
        let request = URLRequest(url: url)
        self.webView?.load(request)
    }
    
    // MARK: - WKNavigationDelegate Methods
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        L.debug("Started loading: \(webView.url)")
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let redirectUrl = navigationAction.request.url {
            if redirectUrl.absoluteString.hasPrefix("itoot") {
                L.debug("Redirected after succesful auth! \(redirectUrl)")
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
        

    // MARK: - Private Methods
    
    private func loadAuthPage() {
        self.webView.navigationDelegate = self
        
        let urlString = "\(self.baseInstanceUrl!)/oauth/authorize?client_id=\(self.clientKey!)&response_type=code&redirect_uri=itoot://oauth-response/success&scope=read%20write%20follow&state=Instatoot"

        if let url = URL(string: urlString) {
            self.webView.load(URLRequest(url: url))
        }
    }
    
    private func refreshView() {
        
    }
    
    private func setupView() {
    }
    
}
