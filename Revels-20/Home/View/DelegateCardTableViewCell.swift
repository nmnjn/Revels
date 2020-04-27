//
//  DelegateCardTableViewCell.swift
//  Revels-20
//
//  Created by Naman Jain on 23/01/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class DelegateCardTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var delegateCardsController: DelegateCardsController?
    var Cards: [DelegateCard]?{
        didSet{
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    let cellId = "cellId"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Cards"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(DelegateCardCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
//        view.backgroundColor = .darkGray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    fileprivate func setupLayout(){
        
        if UIViewController().isSmalliPhone(){
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 24, bottomConstant: 0, rightConstant: 16)
        addSubview(collectionView)
        collectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        addSubview(seperatorLineView)
        _ = seperatorLineView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Cards?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DelegateCardCollectionViewCell
        let card = Cards?[indexPath.item] ?? DelegateCard()
        cell.titleLabel.text = card.name
        if card.name == "Proshow Pass"{
            cell.descriptionLabel.text = "A delegate pass that gives you access to our Ground Zero proshow concert for the the last two nights of the fest."
        }else{
            cell.descriptionLabel.text = "\(card.description)"
        }
        if self.titleLabel.text == "Bought Cards"{
            cell.titleLabel.textColor = UIColor.CustomColors.Blue.accent
            cell.costLabel.text = "PURCHASED"
            cell.infoImageView.isHidden = true
        }else{
            if card.MAHE_price == 0 {
                cell.costLabel.text = "NON MAHE PRICE : ₹\(card.non_price)"
            }else if card.non_price == 0 {
                cell.costLabel.text = "MAHE PRICE : ₹\(card.MAHE_price)"
            }else{
                cell.costLabel.text = "MAHE PRICE : ₹\(card.MAHE_price)\nNON MAHE PRICE : ₹\(card.non_price)"
            }
            cell.titleLabel.textColor = UIColor.CustomColors.Skin.accent
            cell.infoImageView.isHidden = false
            
        }
        cell.descriptionLabel.tag = card.id
        cell.delegateCardTableViewCell = self
        guard let delCard = Cards?[indexPath.item] else { return cell }
        cell.card = delCard
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let card = Cards?[indexPath.item] else { return }
        print(card.id)
        if card.payment_mode >= 2 {
            delegateCardsController?.buyCard(id: card.id)
        }else{
            FloatingMessage().floatingMessage(Message: "Card is not available for online purchase!", Color: .orange, onPresentation: {}) {
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 44 , height: frame.height - 44)
    }
    
}


class DelegateCardCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate{
    
    var delegateCardTableViewCell: DelegateCardTableViewCell?
    var boughtCards = false
    var card = DelegateCard()
        
        // MARK: - Init
        let backgroundCard: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
            view.clipsToBounds = true
            view.alpha = 1
            view.backgroundColor = UIColor.CustomColors.Black.card
            return view
        }()
        
        let circleView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 10
            view.backgroundColor = UIColor(white: 0, alpha: 0.4)
            return view
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = UIColor.CustomColors.Skin.accent
            return label
        }()
        
        let separatorView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor.CustomColors.Blue.accent
            
            return view
        }()
        
        lazy var descriptionLabel: UITextView = {
            let label = UITextView()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 13)
            label.textAlignment = .left
            label.backgroundColor = .clear
            label.textColor = .init(white: 1, alpha: 0.8)
            label.isUserInteractionEnabled = true
//            label.isScrollEnabled = true
            label.isEditable = false
            label.isSelectable = false
            label.textAlignment = .center
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
            tap.delegate = self
            label.addGestureRecognizer(tap)
            return label
        }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white//UIColor.CustomColors.Skin.accent
        return label
    }()
    
    lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "buy")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .init(white: 1, alpha: 0.5)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc func handleCardTap(_ sender: AnyObject){
        if card.payment_mode >= 2 {
            self.delegateCardTableViewCell?.delegateCardsController?.buyCard(id: sender.view.tag)
        }else{
            FloatingMessage().floatingMessage(Message: "Card is not available for online purchase!", Color: .orange, onPresentation: {}) {
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout(){
        
        if UIViewController().isSmalliPhone(){
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            descriptionLabel.font = UIFont.systemFont(ofSize: 12)
            costLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        addSubview(backgroundCard)
        self.backgroundColor = .clear
//        self.selectedBackgroundView = UIView()
        
        
        
        addSubview(titleLabel)
        _ = titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 22, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        addSubview(costLabel)
        _ = costLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        addSubview(descriptionLabel)
        _ = descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: costLabel.topAnchor, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 0)
        
        _ = backgroundCard.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        backgroundCard.addSubview(infoImageView)
        infoImageView.anchor(top: nil, left: nil, bottom: backgroundCard.bottomAnchor, right: backgroundCard.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 25, heightConstant: 25)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
