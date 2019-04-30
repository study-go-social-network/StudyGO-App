//
//  DetailCallout.swift
//  Let's Study
//
//  Created by Alexander on 17/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit

@IBDesignable class DetailCallout: UIView{
    
    var view:UIView!
    var timer:Timer?
    var dueTime = "2019-04-19 04:52:00"
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var lv: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var dueTimeLabel: UILabel!
    var currentEvent:EventObject!
    init(studyEvent:StudyEvent){
        super.init(frame:CGRect(x: 0, y: 0, width: 200, height: 300))
        setup()
        userImage.image = UIImage(named: studyEvent.holder.userProfileImageSrc)
        userName.text = studyEvent.holder.userName
       
        capacity.text = "\(1+studyEvent.joiners.count)/\(studyEvent.capacity)"
        dueTimeLabel.text = studyEvent.dueTime
        dueTimeLabel.textColor = UIColor.blue
        
        
        //        var date = NSDate()
        //        var dateformatter = DateFormatter()
        //        dateformatter.dateFormat="yyyy-MM-ddHH:mm:ss"
        //        var strNowTime = dateformatter.string(from: date as Date) as String
        //        dueTimeLabel.text = strNowTime;
        
        
        addCycleTimer()
    }
    init(event:EventObject){
        super.init(frame:CGRect(x: 0, y: 0, width: 200, height: 300))
        setup()
        self.currentEvent = event
        do{
            let url = URL(string: event.holder.userImageSrc)
            let data = try Data(contentsOf: url!)
            userImage.image = UIImage(data: data)
        }catch{
            print(error)
        }
         lv.text = "Lv " + connector.checkRankByUserIdInRank(userid: currentEvent.holder.userid).description
        userName.text = event.holder.name
        capacity.text = "Unspecified"
        dueTimeLabel.text = event.dueTime
        dueTimeLabel.textColor = UIColor.blue
        dueTime = event.dueTime
        descriptionField.text = event.description
        if event.holder.userid == currentUser?.userid {
            joinButton.removeFromSuperview()
            statusLabel.text = "This is your activity"
        }
        addCycleTimer()
    }
    fileprivate func addCycleTimer() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoop.Mode.common)
    }
    @objc private func handleTimer (){
        if joinButton != nil{
            if !connector.checkPartnerAvaliable(eventid: currentEvent.eventid!){
                joinButton.removeFromSuperview()
                statusLabel.text = "Event Full"
                
            }else if userStatus == UserState.waiting{
                joinButton.removeFromSuperview()
                statusLabel.text = "Waiting for response"
            }else if userStatus == UserState.free{
                // do not do something
            }
        }
        
        let currentDate = Date(timeIntervalSinceNow: 1)
        
        //        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //"HH:mm:ss"

        
        let now = dateFormatter.string(from: currentDate)
        let date1 = dateFormatter.date(from: now)!
        let date2 = dateFormatter.date(from: dueTime)!
        let diff = Int(date2.timeIntervalSince(date1))
        let hours = diff/3600
        let minutes = (diff-hours*3600)/60
        let seconds = diff-hours*3600-minutes*60
        print(dateFormatter.string(from: currentDate))
        print(diff/3600)
        dueTimeLabel.text = String(format: "%02d", hours)+":"+String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
        
        //        if hours < 1 {
        //            self.dueTimeLabel.textColor = UIColor.red
        //            if self.joinButton != nil {
        //                self.joinButton.isEnabled = false
        //                self.joinButton.removeFromSuperview()
        //                self.statusLabel.text = "Waiting for finishing"
        //            }
        //
        //        }else{
        //
        //
        //        }
        if hours <= 0 {
            if minutes <= 0 && seconds <= 0 {
                self.dueTimeLabel.text = "Finished"
                self.statusLabel.text = "Event Finished"
                // in this time we remove the finnished event
                connector.removeEvent(eventid: currentEvent.eventid!)
                if self.joinButton != nil{
                    self.joinButton.isEnabled = false
                    
                    self.joinButton.titleLabel!.text = "Finished"
                    self.joinButton.removeFromSuperview()
                }
                
                timer?.invalidate()
            }
        }
        
        
        
        
        // dueTimeLabel.text = dateFormatter.string(from:currentTime)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        setup()
        userImage.image = UIImage(named: "image01")
        
    }
    
    @IBAction func joinEvent(_ sender: Any) {
        print("Join Event")
        userStatus = UserState.waiting
        Saver.saveInformation()
        //let connector = DBConnector()
        connector.sendMessage(type: "REQUEST", event: currentEvent, senderId: currentUser!.userid)

        joinButton.isHidden = true
        statusLabel.text = "Waiting for respones"
        //createAlert(message: "Please waiting for the response", title: "Your request have been sent")
    }
    func createAlert(message:String,title:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            self.statusLabel.text = "Waiting for respones"
        }))
        alert.present(alert, animated: true, completion: nil)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup()
        userImage.image = UIImage(named: "image01")
    }
    func setup(){
        view = loadNib()
        view.frame = bounds
        addSubview(view)
    }
    func loadNib()-> UIView{
        let className = type(of: self)
        let bundle = Bundle(for: className)
        let nib = UINib(nibName: "DetailCallout", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    
}
