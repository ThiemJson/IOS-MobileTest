//
//  DetailController.swift
//  internalTest
//
//  Created by Teneocto on 05/07/2021.
//

import UIKit
import WebKit

class DetailController: UIViewController {
    @IBOutlet weak var webView: WKWebView!{
        didSet{
            let preference = WKWebpagePreferences()
            preference.allowsContentJavaScript = true
            let config = WKWebViewConfiguration()
            config.defaultWebpagePreferences = preference
            webView.backgroundColor = UIColor.systemGray5
        }
    }
    @IBOutlet weak var scorebatTitle: UILabel! {
        didSet{
            scorebatTitle.textColor = UIColor.systemGray5
            scorebatTitle.backgroundColor = UIColor.systemGray5
            scorebatTitle.layer.cornerRadius = 8.0
            scorebatTitle.clipsToBounds = true
        }
    }
    var scorebat : ScorebatModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadWebview()
    }
    
    // MARK: WebView
    private func loadWebview(){
        if let scorebat = self.scorebat {
            self.webView?.loadHTMLString(scorebat.embed, baseURL: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.webView.stopLoading()
    }
}

// MARK: WebkitDelegate
extension DetailController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let scorebat = self.scorebat {
            self.scorebatTitle?.text = scorebat.title
            self.scorebatTitle.backgroundColor = .clear
            self.scorebatTitle.textColor = .label
            self.webView.backgroundColor = .clear
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showErrorAlert()
    }
    
    private func showErrorAlert(){
        let alertController = UIAlertController(title: "This pages could not loaded", message: "Please check your internet connection and try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Reload", style: .default) {
            [weak self] (alert: UIAlertAction!) in
            DispatchQueue.main.async {
                self?.loadWebview()
            }
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil )
    }
}
