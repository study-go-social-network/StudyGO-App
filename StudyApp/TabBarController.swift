//
//  TabBarController.swift
//  StudyApp
//
//  Created by Alexander on 19/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit
//var messageQueue:[Message] = []
var currentMessage:Message?
// 0 -> free  1 - > on event 2 -> waiting for respones 3 -> accepted
struct UserState{
    public static let free = 0
    public static let onEvent = 1
    public static let waiting = 2
    public static let accepted = 3
}
var userStatus = 0
class TabBarController: UITabBarController {
    var timer:Timer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startListener()
        

        // Do any additional setup after loading the view.
    }
    func startListener(){
        addCycleTimer()
    }
    fileprivate func addCycleTimer() {
        timer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode:RunLoop.Mode.common)
    }
    @objc private func handleTimer (){
        print("start listening message")
      //  print(messageQueue)
        if currentUser != nil{
         //  let connector = DBConnector()
           //messageQueue = connector.checkMessage(currentUserId: currentUser!.userid)
            //connector.disconnected()
          //  messageQueue = connector.checkReply(currentUserid: currentUser!.userid)
            currentMessage = connector.checkReply(currentUserid: currentUser!.userid).first
            
            
            
        }
//        if messageQueue.count != 0 {
//            if messageQueue.first?.messageType == "REJECT"{
//                createAlert(title: "Request rejected", message: "Event holder rejected your request", isAccepted: false, relatedMessage: messageQueue.first!)
//            }else if messageQueue.first?.messageType == "ACCEPT"{
//                createAlert(title: "Request Accepted", message: "Event holder accepted your request", isAccepted: true, relatedMessage: messageQueue.first!)
//            }
//        }
        if currentMessage != nil {
            if currentMessage?.messageType == "REJECT"{
                createAlert(title: "Request rejected", message: "Event holder rejected your request", isAccepted: false, relatedMessage: currentMessage!)
            }else if currentMessage?.messageType == "ACCEPT"{
                createAlert(title: "Request Accepted", message: "Event holder accepted your request", isAccepted: true, relatedMessage: currentMessage!)
            }
        }
    }
    
    func createAlert(title:String,message:String,isAccepted:Bool,relatedMessage:Message){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            if isAccepted {
                //
               // messageQueue.removeFirst()
                connector.readReply(message: relatedMessage)
                currentMessage = nil
                userStatus = UserState.accepted
                for event in events{
                    if event.eventid == relatedMessage.eventid{
                        eventToJoin = event
                    }
                }
                // save context
                Saver.saveInformation()
                
                
                
                alert.dismiss(animated: true, completion: nil)
                
                
            }else{
               // messageQueue.removeFirst()
                connector.readReply(message: relatedMessage)
               
                currentMessage = nil
                 userStatus = UserState.free
                Saver.saveInformation()
                alert.dismiss(animated: true, completion: nil)
                
                
            }
            
        }))
        self.present(alert,animated: true,completion: nil)
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
