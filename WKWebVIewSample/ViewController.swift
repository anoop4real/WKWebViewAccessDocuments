//
//  ViewController.swift
//  WKWebVIewSample
//
//  Created by anoop mohanan on 09/03/17.
//  Copyright © 2017 anoop mohanan. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController{

    @IBOutlet weak var webViewHolder:UIView!
    var wkWebView:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWKWebView()
        loadUrl()
        copyImage()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func setUpWKWebView(){
    
        wkWebView = WKWebView(frame: webViewHolder.bounds)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        webViewHolder.addSubview(wkWebView)
    }
    // Load the html from local resource folder
    // MARK: Method to load html from resources
    private func loadUrl(){
        if let resourceUrl = Bundle.main.url(forResource: "index", withExtension: "html") {
            let urlRequest = URLRequest.init(url: resourceUrl)
            wkWebView.load(urlRequest)
        }
    }
    // MARK: JS CALLS
    fileprivate func evaluateWithJavaScriptExpression(jsExpression: String) {
        
        wkWebView.evaluateJavaScript(jsExpression, completionHandler: {(_, error) in
            if((error) != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func executeJS(){
        // "http://www.freeiconspng.com/uploads/smiley-icon-1.png"
        let path = offlineImagePath()
        let formattedPath = "\"\(path)\""
        evaluateWithJavaScriptExpression(jsExpression: "changeImagePathWith(\(formattedPath));")
    }
    
    func copyImage(){
        
        if let originPath = Bundle.main.path(forResource: "smiley", ofType: "png"){
            let destinationPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
            print(destinationPath)
            let destPath = (destinationPath as NSString).appendingPathComponent("/smiley.png")
            let fileManager = FileManager.default
            
            do{
                try fileManager.copyItem(atPath: originPath, toPath: destPath)
            }catch let error{
                
                print(error.localizedDescription)
            }
        }
        
    }
    
    func offlineImagePath()-> String{
        
        let imagePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let originURLForFile = URL(fileURLWithPath: imagePath.appendingFormat("/smiley.png"))
        print("OfflinePath \(originURLForFile.absoluteString)")
        return originURLForFile.absoluteString
    }


}

extension ViewController:WKNavigationDelegate, WKUIDelegate {
    
    // MARK: Navigation Delegates
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: .alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }
    


}

