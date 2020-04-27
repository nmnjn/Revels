//
//  BottomSheetViewController.swift
//  Revels
//
//  Created by Akhilesh Shenoy on 03/02/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import UBottomSheet
import CoreLocation

/*
 
 INSERT INTO `poitable` (`id`, `locationName`, `locationTag`, `locCordLat`, `locCordLong`, `dirCordLat`, `dirCordLong`, `imageUrl`) VALUES (NULL, 'Test', 'test', '76.56', '76.56', '76.56', '76.56', NULL);
 
 */

struct poi {
    var locationName: String
    var locationCoordinates: CLLocationCoordinate2D
    var directionCoordinates: CLLocationCoordinate2D
    var tagCategory: String
    var tagImageUrl: String
    var imageUrl: String
}

struct PoiData: Codable {
    var locationName: String
    var locCordLat: Double
    var locCordLong: Double
    var dirCordLat: Double?
    var dirCordLong: Double?
    var locationTag: String
    var imageUrl: String?
    var tagImageUrl: String?
}

struct poiDataResponse: Decodable{
    let success: Bool
    let data: [PoiData]
}

class BottomSheetViewController: BottomSheetController{
    
    var poiArray = [poi]()
    var filteredPOIArray: [poi]?{
        didSet{
            guard let array = filteredPOIArray else { return }
            DispatchQueue.main.async{
                for i in array{
                    self.handleMapDelegate?.setupTagDictionary(poi: i)
                    self.handleMapDelegate?.addAnnotation(poi: i)
                }
            }
            locationTableView.reloadData(with: .automatic)
        }
    }
    var currentTag = ""
    var tags = ["All"]
    fileprivate let tagsController = TagsController(collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var locationTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.tableFooterView = UIView()
        tableView.register(LocationSearchTableViewCell.self, forCellReuseIdentifier: "cellID")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        setupTagsController()
        setuppoi()
        setupLocationInfoViewLayout()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool){
    }
    
    //MARK: BottomSheetController configurations
    
    override var bottomYPercentage: CGFloat {
        return 0.13
    }
    
//    override var bottomY: CGFloat {
//        return 90
//    }
    
    override var initialPosition: SheetPosition {
        return .bottom
    }
    
    fileprivate func setupTagsController() {
        tagsController.delegate = self
//        tagsController.tags = self.tags
        tagsController.markerBar.backgroundColor = UIColor.CustomColors.Blue.accent
        tagsController.specialColor = UIColor.CustomColors.Blue.accent
        tagsController.menuBar.backgroundColor = UIColor.CustomColors.Black.background
        tagsController.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        tagsController.shadowBar.backgroundColor = UIColor.CustomColors.Black.background
    }
    
    func setuppoi(){
        let apiStruct = ApiStruct(url: mapsDataURL, method: .get, body: nil)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (map: poiDataResponse) in
            if map.success{
                for i in map.data{
                    self.poiArray.append(poi.init(locationName: i.locationName, locationCoordinates: CLLocationCoordinate2D(latitude: i.locCordLat, longitude: i.locCordLong), directionCoordinates: CLLocationCoordinate2D(latitude: i.dirCordLat ?? i.locCordLat, longitude: i.dirCordLong ?? i.locCordLong), tagCategory: i.locationTag, tagImageUrl: i.tagImageUrl ?? "", imageUrl: i.imageUrl ?? ""))
                    if !self.tags.contains(i.locationTag){
                        self.tags.append(i.locationTag)
                    }
                }
                
                self.poiArray.sort { (poi1, poi2) -> Bool in
                    poi1.locationName < poi2.locationName
                }
                self.filteredPOIArray = self.poiArray
                self.currentTag = "All"
                self.tagsController.tags = self.tags
            }
        }) { (error) in
            print(error)
        }
    }
    
    //MARK: locationInfoView conf
    var currentLocation: String = ""
    var currentLocationDirectionCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    var handleMapDelegate: HandleMapDelegate? = nil
    
    lazy var nameLabel : UILabel = {
       let label = UILabel()
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
       label.lineBreakMode = .byWordWrapping
       label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
       label.textAlignment = .left
       label.textColor = .white
       label.text = ""
       return label
    }()

    lazy var closeButton : UIButton = {
       let button = UIButton()
       button.setTitle("~", for: .normal)
       button.setTitleColor(.white, for: .normal)
       button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12.5
       button.clipsToBounds = true
       button.backgroundColor = .red
       button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
       return button
     }()
    lazy var imageView: UIImageView = {
        let iV = UIImageView()
        iV.clipsToBounds = true
        iV.contentMode = .scaleAspectFill
        return iV
    }()

    lazy var locationInfoView: UIView = {
       let view = UIView()
       view.backgroundColor = UIColor.CustomColors.Black.background
       return view
    }()
    
    @objc func handleClose(){
        handleMapDelegate?.removeDirection()
        locationInfoView.isHidden = true
    }
    
    @objc func showDirection(){
        changePosition(to: .bottom)
        handleMapDelegate?.showDirection(to: currentLocationDirectionCoordinates)
    }

    @objc func showNavigation() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:"comgooglemaps://?saddr=&daddr=\(currentLocationDirectionCoordinates.latitude),\(currentLocationDirectionCoordinates.longitude)&directionsmode=walking")! as URL)
        } else {
            handleMapDelegate?.showNavigation(to: currentLocation, coordinates: currentLocationDirectionCoordinates)
        }

        
    }
    
    lazy var directionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "direction")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(white: 1, alpha: 0.5)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 20, right: 0)
        button.backgroundColor = UIColor.CustomColors.Black.card
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
        return button
    }()
    
    lazy var navigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "navigation")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(white: 1, alpha: 0.5)
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 20, right: 0)
        button.backgroundColor = UIColor.CustomColors.Black.card
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
        return button
    }()
    
     fileprivate func setupLocationInfoViewLayout() {
    
            locationInfoView.addSubview(nameLabel)
        
            nameLabel.leftAnchor.constraint(equalTo: locationInfoView.leftAnchor, constant: 20).isActive = true
            nameLabel.topAnchor.constraint(equalTo: locationInfoView.topAnchor, constant: 8).isActive = true
            nameLabel.widthAnchor.constraint(equalTo: locationInfoView.widthAnchor, constant: -32).isActive = true
            nameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
            locationInfoView.addSubview(closeButton)
            closeButton.rightAnchor.constraint(equalTo: locationInfoView.rightAnchor , constant: -16).isActive = true
            closeButton.topAnchor.constraint(equalTo: locationInfoView.topAnchor, constant: 16).isActive = true
            closeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
            locationInfoView.addSubview(directionButton)
            let width = (view.frame.width - 48) / 2
        _ = directionButton.anchor(top: nameLabel.bottomAnchor, left: locationInfoView.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: width, heightConstant: 85)
            
            locationInfoView.addSubview(navigationButton)
        _ = navigationButton.anchor(top: nameLabel.bottomAnchor, left: directionButton.rightAnchor, bottom: nil, right: locationInfoView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 85)
            
            let titleLabel = UILabel()
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.numberOfLines = 0
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.textColor = UIColor(white: 1, alpha: 0.8)
            titleLabel.textAlignment = .center
            titleLabel.text = "Direction"
            
            let titleLabel1 = UILabel()
            titleLabel1.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel1.numberOfLines = 0
            titleLabel1.translatesAutoresizingMaskIntoConstraints = false
            titleLabel1.textColor = UIColor(white: 1, alpha: 0.8)
            titleLabel1.textAlignment = .center
            titleLabel1.text = "Navigation"
            
            
            directionButton.addSubview(titleLabel)
            _ = titleLabel.anchor(top: nil, left: directionButton.leftAnchor, bottom: directionButton.bottomAnchor, right: directionButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 20)
            
            navigationButton.addSubview(titleLabel1)
            _ = titleLabel1.anchor(top: nil, left: navigationButton.leftAnchor, bottom: navigationButton.bottomAnchor, right: navigationButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 12, rightConstant: 0, widthConstant: 0, heightConstant: 20)
            
            locationInfoView.addSubview(imageView)
        _ = imageView.anchor(top: navigationButton.bottomAnchor, left: locationInfoView.leftAnchor, bottom: nil, right: locationInfoView.rightAnchor, topConstant: 16, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 250)
            imageView.layer.cornerRadius = 10
            
        }
    
    func setDelegate(vc: HandleMapDelegate){
        handleMapDelegate = vc
    }
       
    func loadLocationInfoView(title: String){
        nameLabel.text = title
        currentLocation = title
        locationInfoView.isHidden = false
        changePosition(to: .middle)
        for i in poiArray{
            if i.locationName == currentLocation{
                if let url = URL(string: i.imageUrl){
                    imageView.sd_setImage(with: url, completed: nil)
                }
                currentLocationDirectionCoordinates = i.directionCoordinates
                return
            }
            
        }
    }
    
    func hideLocationInfoView(){
        locationInfoView.isHidden = true
//        changePosition(to: .bottom)
    }
    
//MARK: ViewSetup
    fileprivate func setupLayout() {
        view.backgroundColor = UIColor.CustomColors.Black.background
        let tinyBar = UIView()
        tinyBar.backgroundColor = UIColor.CustomColors.Blue.accent
        tinyBar.layer.cornerRadius = 2.5
        
        view.addSubview(tinyBar)
        tinyBar.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 7.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 5)
        
        tinyBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         
         guard let tagsView = tagsController.view else {return}
         view.addSubview(tagsView)
        _ = tagsView.anchor(top: tinyBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 60)

        view.addSubview(locationTableView)
         _ = locationTableView.anchor(top: tagsView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
         
        view.addSubview(locationInfoView)
        
        _ = locationInfoView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 13, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.view.frame.height)
        locationInfoView.isHidden = true
     }
}


extension BottomSheetViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredPOIArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = filteredPOIArray?[indexPath.row].locationName ?? ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! LocationSearchTableViewCell
         cell.textLabel?.text = place
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let poi = filteredPOIArray![indexPath.row]
        handleMapDelegate?.zoomToPlace(name: poi.locationName, location: poi.locationCoordinates)
        loadLocationInfoView(title: poi.locationName)
    }
}

extension BottomSheetViewController: TagsControllerDelegate{
    func didTapTag(indexPath: IndexPath) {
        currentTag = tags[indexPath.row]
        handleMapDelegate?.removeAnnotations()
        filteredPOIArray = currentTag == "All" ? poiArray : poiArray.filter({ (poi) -> Bool in
            poi.tagCategory == currentTag
        })
    }
}



