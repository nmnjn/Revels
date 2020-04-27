//
//  ScheduleCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


protocol ScheduleCellProtocol{
    func favouritesButtonTapped(cell: UITableViewCell, fav: Bool)
}

class ScheduleCell: UITableViewCell{
    
    var favourite: Bool?{
        didSet{
            guard let favourite = favourite else { return }
            if favourite{
                self.favStarButton.setImage(UIImage(named: "star_filled")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }else{
                self.favStarButton.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
        }
    }
    
    var delegate: ScheduleCellProtocol?
    
    var schedule: Schedule?{
        didSet{
            guard let schedule = schedule else { return }
            var startDate = Date(dateString: schedule.start)
            startDate = Calendar.current.date(byAdding: .hour, value: -5, to: startDate)!
            startDate = Calendar.current.date(byAdding: .minute, value: -30, to: startDate)!
            var endDate = Date(dateString: schedule.end)
            endDate = Calendar.current.date(byAdding: .hour, value: -5, to: endDate)!
            endDate = Calendar.current.date(byAdding: .minute, value: -30, to: endDate)!
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            var dateString = formatter.string(from: startDate)
            dateString.append(" - \(formatter.string(from: endDate))")
            eventTimeLabel.text = dateString
            eventVenueLabel.text = schedule.location
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundCard.backgroundColor = selected ? UIColor.CustomColors.Black.card : UIColor.CustomColors.Black.card
//        self.lineSeperator.backgroundColor = selected ? UIColor.CustomColors.Blue.accent : UIColor.CustomColors.Blue.accent
    }
    
    var event: Event?{
        didSet{
            guard let event = event else { return }
            eventNameLabel.text = event.name
            //            textLabel?.text = event.name
        }
    }
    
    lazy var backgroundCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
//                view.dropShadow(shadowOpacity: 0.2, shadowRadius: 5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.alpha = 0.5
        return view
    }()
    
    let circleView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 1, alpha: 0.06)
        return view
    }()
    
    lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var lineSeperator: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.CustomColors.Blue.accent
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var eventVenueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 12)
        }else{
            label.font = UIFont.systemFont(ofSize: 14)
        }
        label.textAlignment = .left
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location")
        imageView.setImageColor(color: .white)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var timerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "time")
        imageView.setImageColor(color: .white)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var eventTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 12)
        }else{
            label.font = UIFont.systemFont(ofSize: 14)
        }
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var roundLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .right
        label.backgroundColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    
    lazy var favStarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "star_unfilled")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.CustomColors.Skin.accent
        button.addTarget(self, action: #selector(didTapFavButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = .init(top: 0, left: 32, bottom: 0, right: 0)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        
        backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        addSubview(backgroundCard)
        addSubview(eventNameLabel)
        addSubview(lineSeperator)
        addSubview(eventTimeLabel)
        addSubview(eventVenueLabel)
        addSubview(locationImageView)
        addSubview(timerImageView)
        addSubview(favStarButton)
        eventNameLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 28, leftConstant: 30, bottomConstant: 16, rightConstant: 30)
        _ = lineSeperator.anchor(top: eventNameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 1)
        _ = eventTimeLabel.anchor(top: lineSeperator.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 56, bottomConstant: 16, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = eventVenueLabel.anchor(top: eventTimeLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 56, bottomConstant: 8, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        locationImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        locationImageView.centerYAnchor.constraint(equalTo: eventVenueLabel.centerYAnchor).isActive = true
        locationImageView.rightAnchor.constraint(equalTo: eventVenueLabel.leftAnchor, constant: -6).isActive = true
        
        timerImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        timerImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        timerImageView.centerYAnchor.constraint(equalTo: eventTimeLabel.centerYAnchor).isActive = true
        timerImageView.rightAnchor.constraint(equalTo: eventTimeLabel.leftAnchor, constant: -6).isActive = true
        
//        favStarButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        favStarButton.widthAnchor.constraint(equalToConstant: 62).isActive = true
        favStarButton.topAnchor.constraint(equalTo: lineSeperator.bottomAnchor, constant: 0).isActive = true
        favStarButton.bottomAnchor.constraint(equalTo: backgroundCard.bottomAnchor, constant: 0).isActive = true
        favStarButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -32).isActive = true
        
        
        backgroundCard.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
        
        backgroundCard.addSubview(circleView)
        circleView.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: -200).isActive = true
        circleView.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: -250).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        circleView.layer.cornerRadius = 200
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func didTapFavButton(){
        self.favourite = !(self.favourite ?? false)
        delegate?.favouritesButtonTapped(cell: self, fav: self.favourite ?? false)
    }
}

