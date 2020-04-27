//
//  MenuController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

protocol MenuControllerDelegate {
    func didTapMenuItem(indexPath: IndexPath)
}

class MenuController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    
    var menuItems = [String]()
    
    var specialColor: UIColor?
    
    var delegate: MenuControllerDelegate?
    
    let menuBar: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    lazy var markerBar: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let shadowBar: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        print(indexPath)
        delegate?.didTapMenuItem(indexPath: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(menuBar)
        view.addSubview(shadowBar)
        
        let width = view.frame.width
        let neededWidth = width / CGFloat(integerLiteral: menuItems.count)
        
        _ = shadowBar.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: 0.5)
        _ = menuBar.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0.5, rightConstant: 0, widthConstant: neededWidth, heightConstant: 10)
        menuBar.addSubview(markerBar)
        _ = markerBar.anchor(top: nil, left: menuBar.leftAnchor, bottom: menuBar.bottomAnchor, right: menuBar.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.label.text = menuItems[indexPath.item]
        if let color = specialColor{
            cell.color = color
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let neededWidth = width / CGFloat(integerLiteral: menuItems.count)
        return .init(width: neededWidth, height: 40)
    }
    
}

