//
//  RegisteredEventsViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 29/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


class RegisteredEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var registeredEvents : [RegisteredEvent]!{
        didSet{
        }
    }
    
    var scheduleDict : [String:Schedule]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Registered Events"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getSchedule()
    }
    
    var fromScanner = false
    
    override func viewWillDisappear(_ animated: Bool) {
        if fromScanner{
            fromScanner = false
        }else{
           navigationController?.popViewController(animated: true)
        }
        
    }
    
    fileprivate func getSchedule(){
        
        Caching.sharedInstance.getCachedData(dataType: [String:Schedule](), cacheLocation: scheduleDictCache, dataCompletion: { (data) in
            self.scheduleDict = data
        }) { (errorMessage) in
            Networking.sharedInstance.getData(url: scheduleURL, decode: Schedule(), dataCompletion: { (data) in
                Caching.sharedInstance.saveSchedulesToCache(schedule: data)
                var scheduleDictionary : [String: Schedule] = [:]
                for sc in data{
                    scheduleDictionary["\(sc.eventId)+\(sc.round)"] = sc
                }
                self.scheduleDict = scheduleDictionary
            }) { (errorMessage) in
                self.navigationController?.popViewController(animated: true)
                print(errorMessage)
            }
        }
        

    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.CustomColors.Black.background//UIColor.CustomColors.Green.register
        
        return view
    }()
    
    func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.register(RegisteredEventTableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RegisteredEventTableViewCell
        let regEvent = self.registeredEvents[indexPath.row]
        guard let eventSchedule = self.scheduleDict?["\(regEvent.event)+\(regEvent.round)"] else {
            print("failed here")
            return cell }
        cell.schedule = eventSchedule
        cell.registeredEvent = regEvent
        cell.registeredEventsViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showMenuForEventAt(IndexPath: indexPath)
    }
    
    func showMenuForCell(Cell: UITableViewCell){
        if let indexPath = tableView.indexPath(for: Cell){
           self.showMenuForEventAt(IndexPath: indexPath)
        }
    }
    
    func showQRAddTeamMate(Cell: UITableViewCell){
        if let indexPath = tableView.indexPath(for: Cell){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            guard let selectedEvent = self.registeredEvents?[indexPath.row] else { return }
            addTeamMate(selectedEvent: selectedEvent)
        }
    }
    
    func showLeaveTeam(Cell: UITableViewCell){
        if let indexPath = tableView.indexPath(for: Cell){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            guard let selectedEvent = self.registeredEvents?[indexPath.row] else { return }
            leaveTeam(selectedEvent: selectedEvent, indexPath: indexPath)
        }
    }
    
    func leaveTeam(selectedEvent: RegisteredEvent, indexPath: IndexPath){
        let actionSheet = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            Networking.sharedInstance.leaveTeamForEventWith(ID: selectedEvent.teamid, successCompletion: { (message) in
                FloatingMessage().floatingMessage(Message: "Successfully left Team \(selectedEvent.teamid)", Color: .orange, onPresentation: {
                    self.registeredEvents.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    if self.registeredEvents.count == 0{
                        self.navigationController?.popViewController(animated: true)
                    }
                }) {}
            }, errorCompletion: { (message) in
                FloatingMessage().floatingMessage(Message: message, Color: .red, onPresentation: {}) {}
            })
        }
        actionSheet.addAction(sureAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func addTeamMate(selectedEvent: RegisteredEvent){
        let qrVC = QRViewController()
        fromScanner = true
        qrVC.eventId = selectedEvent.event
        self.present(qrVC, animated: true, completion: nil)
        return
    }
    
    func showMenuForEventAt(IndexPath indexPath: IndexPath){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let selectedEvent = self.registeredEvents?[indexPath.row] else { return }
        print(selectedEvent)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let addTeamMateAction = UIAlertAction(title: "Add a Team Mate", style: .default){ action in
            self.addTeamMate(selectedEvent: selectedEvent)
        }
        let leaveTeamAction = UIAlertAction(title: "Leave Team and Unregister", style: .destructive){ action in
            self.leaveTeam(selectedEvent: selectedEvent, indexPath: indexPath)
        }
        actionSheet.addAction(addTeamMateAction)
        actionSheet.addAction(leaveTeamAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

class RegisteredEventTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    var registeredEventsViewController: RegisteredEventsViewController?
    var registeredEvent: RegisteredEvent?
    var schedule: Schedule?{
        didSet{
//            guard let event = registeredEvent else { return }
            guard let schedule = schedule else { return }
            print(schedule)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule == nil{
            return 0
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RegisteredEventCell
        
        var textLabel = "N/A"
        var detailedTextLabel = "N/A"
        var imageName = "calendar"
        let formatter = DateFormatter()
        
//        let category = categoriesDictionary[event.category]
        
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            textLabel = "Team ID"
            imageName = "group"
            detailedTextLabel = "\(registeredEvent?.teamid ?? 0)"
            break
        case 1:
            textLabel = "Date"
            formatter.dateFormat = "dd MMM yyyy"
            let startDate = Date(dateString: schedule!.start)
            detailedTextLabel = formatter.string(from: startDate)
            break
        case 2:
            textLabel = "Time"
            formatter.dateFormat = "h:mm a"
            var startDate = Date(dateString: schedule!.start)
            startDate = Calendar.current.date(byAdding: .hour, value: -5, to: startDate)!
            startDate = Calendar.current.date(byAdding: .minute, value: -30, to: startDate)!
            var endDate = Date(dateString: schedule!.end)
            endDate = Calendar.current.date(byAdding: .hour, value: -5, to: endDate)!
            endDate = Calendar.current.date(byAdding: .minute, value: -30, to: endDate)!
            var dateString = formatter.string(from: startDate)
            dateString.append(" - \(formatter.string(from: endDate))")
            detailedTextLabel = dateString
            imageName = "timer"
            break
        case 3:
            textLabel = "Venue"
            detailedTextLabel = schedule!.location
            imageName = "location"
            break
        case 4:
            textLabel = "Round"
            detailedTextLabel = "\(String(describing: schedule!.round))"
            imageName = "assessment"
            break
        case 5:
            textLabel = "Venue"
            detailedTextLabel = schedule!.location
            imageName = "location"
            break
        case 6:
            textLabel = "Team Size"
//            detailedTextLabel = event.minTeamSize == event.maxTeamSize ? "\(event.minTeamSize)" : "\(event.minTeamSize) - \(event.maxTeamSize)"
            imageName = "group"
            break
//        case 6:
//            textLabel = "Contact 1"
//            detailedTextLabel = category?.cc1Name ?? ""
//            if detailedTextLabel != "" {
//                cell.selectionStyle = .gray
//            }
//            imageName = "contact"
//            break
//        case 7:
//            textLabel = "Contact 2"
//            detailedTextLabel = category?.cc2Name ?? ""
//            if detailedTextLabel != "" {
//                cell.selectionStyle = .gray
//            }
//            imageName = "contact"
//            break
        default:
            textLabel = "Team Size"
            cell.selectionStyle = .gray
        }
//        cell.imageView?.image = UIImage(named: imageName)
//        cell.imageView?.setImageColor(color: .white)
        cell.textLabel?.text = textLabel
        cell.detailTextLabel?.text = detailedTextLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = schedule?.eventName ?? ""
        
        let button = UIButton()
        button.backgroundColor = UIColor.CustomColors.Blue.register
        button.setTitle("Add Team Mate", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.startAnimatingPressActions()
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addTeamMate), for: .touchUpInside)
            
        let button2 = UIButton()
        button2.backgroundColor = #colorLiteral(red: 0.7536286485, green: 0.1785056603, blue: 0.07220073951, alpha: 1)
        button2.setTitle("Leave Team", for: UIControl.State())
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.startAnimatingPressActions()
        button2.layer.cornerRadius = 10
        button2.setTitleColor(.white, for: UIControl.State())
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button2.layer.cornerRadius = 10
        button2.addTarget(self, action: #selector(leaveTeam), for: .touchUpInside)
        
        view.addSubview(label)
        _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
        
        
        view.addSubview(button)
        _ = button.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: frame.width/2 - 40, heightConstant: 0)
        
        view.addSubview(button2)
        _ = button2.anchor(top: label.bottomAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 16, widthConstant: frame.width/2 - 40, heightConstant: 0)
        
        return view
    }
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.clipsToBounds = true
        tv.layer.masksToBounds = true
        tv.register(RegisteredEventCell.self, forCellReuseIdentifier: "cellId")
        tv.backgroundColor = UIColor.CustomColors.Black.card
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 10
        tv.allowsSelection = false
        return tv
    }()
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.cardBackground.backgroundColor = selected ? UIColor.CustomColors.Black.background : UIColor.CustomColors.Black.card
        self.backgroundColor = .clear
//        self.lineSeperator.backgroundColor = selected ? UIColor.CustomColors.Green.accent : UIColor.CustomColors.Green.accent
    }
    
    lazy var cardBackground : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        addSubview(cardBackground)
        _ = cardBackground.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 270)
        cardBackground.addSubview(tableView)
        tableView.fillSuperview()
        
//        let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMenu))
//        tapOnScreen.cancelsTouchesInView = false
//        addGestureRecognizer(tapOnScreen)
    }
    
    
    
    @objc func showMenu(){
        self.registeredEventsViewController?.showMenuForCell(Cell: self)
    }
    
    @objc func addTeamMate(){
        self.registeredEventsViewController?.showQRAddTeamMate(Cell: self)
    }
    
    @objc func leaveTeam(){
        self.registeredEventsViewController?.showLeaveTeam(Cell: self)
    }
}


class RegisteredEventCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        textLabel?.textColor = UIColor.init(white: 1, alpha: 0.8)
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = .white
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        detailTextLabel?.numberOfLines = 0
        textLabel?.numberOfLines = 0
        imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
