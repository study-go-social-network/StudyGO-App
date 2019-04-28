//
//  StudyTimerViewController.swift
//  StudyApp
//
//  Created by Alexander on 19/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit
var eventInprogress:EventObject?
var eventToJoin:EventObject?

class StudyTimerViewController: UIViewController {

    var messageQueue:[Message] = []
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBAction func rejectRequest(_ sender: Any) {
      // let connector = DBConnector()
        connector.readMessage(message: messageQueue[0])
        connector.sendMessageById(type: "REJECT", event: eventInprogress!, senderId: eventInprogress!.holder.userid, touserid: messageQueue[0].fromUserid)
         // connector.disconnected()
        messageView.isHidden = true
    }
    @IBAction func acceptRequest(_ sender: Any) {
        connector.addPartnerByEventId(eventid: eventInprogress!.eventid!, pid: messageQueue[0].fromUserid)
        print("update partner")
        connector.readMessage(message: messageQueue[0])
        connector.sendMessageById(type: "ACCEPT", event: eventInprogress!, senderId: eventInprogress!.holder.userid, touserid: messageQueue[0].fromUserid)
        
        // connector.disconnected()
        messageView.isHidden = true
    }
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageView.isHidden = true
        startTimer()
        

        // Do any additional setup after loading the view.
    }
    func startTimer(){
        addCycleTimer()
    }
    @IBAction func testComment(_ sender: Any) {
        performSegue(withIdentifier: "toComment", sender: self)
    }
    fileprivate func addCycleTimer() {
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoop.Mode.common)
    }
    @objc private func handleTimer (){
        //let connector = DBConnector()
        
        messageQueue = connector.checkMessage(currentUserId: currentUser!.userid)
        if messageQueue.count > 0{
            print(messageQueue[0].fromUserid)
            let user = connector.fectchUserInformationById(id: messageQueue[0].fromUserid)!
            setupMessageView(user: user)
        }
        let currentDate = Date(timeIntervalSinceNow: 1)
        
        //        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //"HH:mm:ss"
        
        let now = dateFormatter.string(from: currentDate)
        let date1 = dateFormatter.date(from: now)!
        let date2 = dateFormatter.date(from: (eventInprogress?.dueTime)!)!
        let diff = Int(date2.timeIntervalSince(date1))
        let hours = diff/3600
        let minutes = (diff-hours*3600)/60
        let seconds = diff-hours*3600-minutes*60
        print(dateFormatter.string(from: currentDate))
        print(diff/3600)
        timeLable.text = String(format: "%02d", hours)+":"+String(format: "%02d", minutes)+":"+String(format: "%02d", seconds)
        
        
        if hours <= 0 {
            if minutes <= 0 && seconds <= 0 {
                
                
                timer?.invalidate()
                userStatus = UserState.free
                Saver.saveInformation()
                if !connector.checkPartnerAvaliable(eventid: eventInprogress!.eventid!){
                    performSegue(withIdentifier: "toComment", sender: self)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
                
                //self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    func setupMessageView(user:UserObject){
        do{
            userInfoLabel.text = "\(user.name) want you join your activity"
            let url = URL(string: user.userImageSrc)
            let data = try Data(contentsOf: url!)
            userImageView.image = UIImage(data: data)
        }catch{
            print(error)
        }
        messageView.isHidden = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toComment"{
            print("HELLO")
            let des = segue.destination as! CommentViewController
            des.studyTimerController = self
            print(des.studyTimerController)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
