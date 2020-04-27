//
//  PDFViewController.swift
//  Revels-20
//
//  Created by Naman Jain on 18/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import PDFKit

class OrderPDFViewController: UIViewController{
    
    lazy var pdfView: PDFView = {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        return view
    }()
    
    var pdfLink: String = ""
    var nameOfFile: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        navigationItem.largeTitleDisplayMode = .never
        DispatchQueue.main.async {
            print(self.pdfLink)
            let fileURL = URL(fileURLWithPath: self.pdfLink)
            self.pdfView.document = PDFDocument(url: fileURL)
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(handleShare))]
    }
    
    @objc fileprivate func handleShare(){
        guard let documentData = self.pdfView.document?.dataRepresentation() else { return }
        let activityController = UIActivityViewController(activityItems: ["MIT POST NEWSLETTER", documentData], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    fileprivate func setupView(){
        view.backgroundColor = .white
        view.addSubview(pdfView)
        pdfView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateStatusBar()
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
}

