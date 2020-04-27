//
//  ResultsCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//


import UIKit

class ResultsCell: UICollectionViewCell{
    
    // MARK: - Properties
    
    var event: Event?{
        didSet{
            guard let event = event else { return }
            eventNameLabel.text = event.name
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.backgroundColor = UIColor.CustomColors.Black.card
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        label.text = "Event Name"
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupLongPressGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let id = event?.id{
                print(id)
            }
        }
        
    }
    
    // MARK: - Setup Functions
    
    func setupLayout(){
        backgroundColor = .clear
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = UIColor.CustomColors.Black.card
        //containerView.alpha = 0.5
        addSubview(containerView)
        containerView.addSubview(eventNameLabel)
        containerView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        eventNameLabel.fillSuperview(padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
    }
    
    func setupLongPressGesture(){
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
}

class NoResultsCell: UICollectionViewCell{
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 20       )
        }else{
           label.font = UIFont.boldSystemFont(ofSize: 25)
        }
        
        label.textColor = UIColor(white: 1, alpha: 0.3)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The results have not been uploaded yet."
        return label
    }()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Setup Functions
    
    func setupLayout(){
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 100, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
    }
}
