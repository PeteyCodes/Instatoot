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


class LoginViewController: UIViewController, WKNavigationDelegate, WKURLSchemeHandler, OAuthSwiftURLHandlerType  {

    var baseInstanceUrl: String!
    var clientKey: String!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var isFirstLoad: Bool = true
    private var webView: WKWebView? = nil
    
    
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
            }
        }
        decisionHandler(.allow)
        return
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView?.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html, error) in
            if html != nil {
                L.debug("Page Loaded: \(self.webView!.url)\nHTML: \(html!)")
            }
        })
    }
    
    // MARK: - WKURLSchemeHandler Methods
    
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        // If this method was called, we successfully authenticated
        L.debug("Authenticated: \(urlSchemeTask.request.url?.absoluteString)")
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        L.debug("webView stop")
    }
    
    // MARK: - Private Methods
    
    private func loadAuthPage() {
        let conf = WKWebViewConfiguration()
        conf.setURLSchemeHandler(self, forURLScheme: "itoot")
        
        self.webView = WKWebView(frame: self.containerView.bounds, configuration: conf)
        self.webView!.navigationDelegate = self
        self.containerView.addSubview(self.webView!)
        
        D.instance.authenticate(clientKey: self.clientKey, baseUrl: self.baseInstanceUrl, handlerVC: self, onCompletion: {
            L.debug("Successfully authenticated!!")
            
            // TODO
            
        }) { (error) in
            L.debug("Error authenticating: \(error)")
        }
        
        
    }
    
    private func refreshView() {
        
    }
    
    private func setupView() {
    }
    
}
