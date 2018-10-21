//
//  LoginWebViewController.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 05/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit
import WebKit

class LoginWebViewController: UIViewController {
    
    private let FriendsAccessCode = 2
    private let PhotosAccessCode = 4
    private let WallAccessCode = 8192
    private let GroupsAccessCode = 262144

    
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLoginRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func makeLoginRequest(){
        let accessScope = FriendsAccessCode + PhotosAccessCode + WallAccessCode + GroupsAccessCode
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6438914"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: accessScope.description), //"270342"
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.87")
        ]
        let request = URLRequest(url: urlComponents.url!)
        webView.load(request)
    }
}

extension LoginWebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse:
        WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment
            else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        token = params["access_token"]!
        
        let userId = params["user_id"]!
        currentUserId = userId
        
        performSegue(withIdentifier: "loginSegue", sender: nil)
        
        decisionHandler(.cancel)
    }
}
