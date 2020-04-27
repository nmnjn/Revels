//
//  PaymentsWebViewController.swift
//  Revels-20
//
//  Created by Naman Jain on 28/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import WebKit
import UIKit
import SAConfettiView

class PaymentsWebViewController: UIViewController, WKScriptMessageHandler{
    
    let webView = WKWebView()
    
    var delegateCardID: Int?
    var delegateCardsController: DelegateCardsController?
    var proshowViewController: ProshowViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = webView
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        webView.configuration.userContentController.add(self, name: "paymentHandle")
        
    
        let cookies = HTTPCookieStorage.shared.cookies ?? []
//        for (cookie) in cookies {
//            if cookie.name == "connect.sid" {
//                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
//            }
//        }
        guard let id = self.delegateCardID else { navigationController?.popViewController(animated: true); return}
        
        if let url = URL(string: paymentsURL + "\(id)") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
        }
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.navigationController?.popViewController(animated: true)
        if let message = message.body as? String{
            if let data = message.data(using: String.Encoding.utf8) {
                do {
                    print("javascript listener called")
                    if let jsonresponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] , jsonresponse.count > 0{
                        print(jsonresponse)
                        if jsonresponse["status"] as? String == "TXN_SUCCESS"{
                            self.transactionMessage(message: "Transaction Successful!", color: UIColor.CustomColors.Green.register)
                            let confettiView = SAConfettiView(frame: self.view.bounds)
                            confettiView.colors = [#colorLiteral(red: 0.986153543, green: 0.4094150066, blue: 0.2391255498, alpha: 1), #colorLiteral(red: 0.9891604781, green: 0.7998327017, blue: 0.436186254, alpha: 1), #colorLiteral(red: 0.2523694932, green: 0.7041416764, blue: 0.8506044745, alpha: 1), #colorLiteral(red: 0.5525000095, green: 0.3602257371, blue: 0.5168206692, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
                            confettiView.intensity = 0.5
                            confettiView.startConfetti()
                            self.delegateCardsController?.getBoughtDelegateCards()
                            self.proshowViewController?.markedCardAsBought()
                            UIApplication.shared.keyWindow?.addSubview(confettiView)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                UIView.animate(withDuration: 0.5, animations: {
                                    confettiView.alpha = 0
                                }) { (_) in
                                    confettiView.stopConfetti()
                                    confettiView.removeFromSuperview()
                                }
                            }
                        }else{
                            self.transactionMessage(message: "Transaction Failed!", color: UIColor.red)
                        }
                    }
                    
                    self.webView.configuration.userContentController.removeAllUserScripts()
                } catch {
                    print("Something went wrong")
                }
            }
        }
    }
    
    func transactionMessage(message: String, color: UIColor){
        FloatingMessage().floatingMessage(Message: message, Color: color, onPresentation: {}) {}
    }
}
