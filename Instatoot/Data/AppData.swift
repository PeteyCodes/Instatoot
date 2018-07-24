//
//  AppData.swift
//  Instatoot
//
//  Created by Peter de Tagyos on 7/21/18.
//  Copyright © 2018 Peter de Tagyos. All rights reserved.
//

import Foundation
import OAuthSwift
import SafariServices


typealias D = AppData

public class AppData {
    static let instance = AppData()
    
    
    var oauth2: OAuth2Swift? = nil

    
    public func authenticate(clientKey: String, baseUrl: String, handlerVC: OAuthSwiftURLHandlerType, onCompletion: @escaping () -> Void, onFailure: @escaping (_ errorMessage: String) ->Void) {
    
        self.oauth2 = OAuth2Swift(
            consumerKey: clientKey,
            consumerSecret: "",
            authorizeUrl: "\(baseUrl)/oauth/authorize",
            responseType: "code")

        self.oauth2?.authorizeURLHandler = handlerVC
        
        _ = self.oauth2?.authorize(withCallbackURL: "itoot://oauth-response/success", scope: "read+write+follow", state: "Instatoot", success: { (credential, response, params) in
            L.debug("OAuth Token: \(credential)")

            // TODO
            
            self.oauth2 = nil
            onCompletion();
            
        }, failure: { (error) in
            self.oauth2 = nil
            onFailure(error.localizedDescription)
        })
    }
}

