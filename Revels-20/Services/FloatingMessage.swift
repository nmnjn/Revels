//
//  FloatingMessage.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//


import UIKit
import AudioToolbox

open class FloatingMessage: UIViewController{
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.backgroundColor = .orange
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open func floatingMessage(Message: String, Color: UIColor, onPresentation: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        if Color == .red {
            AudioServicesPlaySystemSound(1521)
        }else{
            AudioServicesPlaySystemSound(1519)
        }
        UIApplication.shared.keyWindow?.addSubview(container)
        container.backgroundColor = Color
        container.centerXAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        container.widthAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.widthAnchor, multiplier: 0.85).isActive = true
        if Message.count > 35 {
            container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }else{
            container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        self.container.alpha = 0
        self.messageLabel.text = Message
        container.addSubview(self.messageLabel)
        messageLabel.fillSuperview(padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            self.container.transform = CGAffineTransform(translationX: 0, y: -100)
            self.container.alpha = 1
            onPresentation()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.container.transform = .identity
            }, completion: {
                (value: Bool) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { () -> Void in
                    onDismiss()
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.container.transform = CGAffineTransform(translationX: 0, y: -100)
                        self.container.alpha = 0
                    }) { (_) in
                        self.container.removeFromSuperview()
                        self.messageLabel.removeFromSuperview()
                    }
                })
            })
        })
    }
    
    open func longFloatingMessage(Message: String, Color: UIColor, onPresentation: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        if Color == .red {
            AudioServicesPlaySystemSound(1521)
        }else{
            AudioServicesPlaySystemSound(1519)
        }
        UIApplication.shared.keyWindow?.addSubview(container)
        container.backgroundColor = Color
        container.centerXAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.centerXAnchor).isActive = true
        container.topAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        container.widthAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.widthAnchor, multiplier: 0.85).isActive = true
        if Message.count > 35 {
            container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }else{
            container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        self.container.alpha = 0
        self.messageLabel.text = Message
        container.addSubview(self.messageLabel)
        messageLabel.fillSuperview(padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { () -> Void in
            self.container.transform = CGAffineTransform(translationX: 0, y: -100)
            self.container.alpha = 1
            onPresentation()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.container.transform = .identity
            }, completion: {
                (value: Bool) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { () -> Void in
                    onDismiss()
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.container.transform = CGAffineTransform(translationX: 0, y: -100)
                        self.container.alpha = 0
                    }) { (_) in
                        self.container.removeFromSuperview()
                        self.messageLabel.removeFromSuperview()
                    }
                })
            })
        })
    }
}

