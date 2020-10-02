//
//  WebVew.swift
//  Project16
//
//  Created by Vlad Vrublevsky on 02.10.2020.
//

import UIKit
import WebKit

class WebVew: UIViewController, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    var url: URL?
    /*
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    } */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url else { return }
        
        let req = URLRequest(url: url)
        webView.load(req)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
