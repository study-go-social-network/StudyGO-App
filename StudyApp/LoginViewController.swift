//
//  LoginViewController.swift
//  StudyApp
//
//  Created by Alexander on 19/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit
var currentUser:UserObject? = nil
var connector = DBConnector()

//var authenticatedId:Int?
class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameInput: UITextField!
    
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        Saver.loadInformation()
        //        if currentUser != nil {
        //            print("666666666666666666666666666666666666")
        //             performSegue(withIdentifier: "successfullLogin", sender: nil)
        //            print("CNM")
        //        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func forceLogin(_ sender: Any) {
        performSegue(withIdentifier: "successfullLogin", sender: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func login(_ sender: Any) {
        if usernameInput?.text != nil && passwordInput?.text != nil {
            // let connector = DBConnector()
            if let value = connector.userAuthentication(username: usernameInput.text!, password: passwordInput.text!){
                //                if value.userid != authenticatedId {
                //                    currentUser = value
                //                    authenticatedId = currentUser?.userid
                //                    userStatus = 0
                //                    eventInprogress = nil
                //                    eventToJoin = nil
                //                    Saver.saveInformation()
                //                    performSegue(withIdentifier: "successfullLogin", sender: nil)
                //                }
                currentUser = value
                // save context
                // authenticatedId = currentUser?.userid
                Saver.saveInformation()
                Saver.loadUserState(userid: currentUser!.userid)
                
                performSegue(withIdentifier: "successfullLogin", sender: nil)
            }else{
                status.text = "Login failed"
            }
            // connector.disconnected()
            
        }
        
    }
}
class Saver{
    public static func saveInformation(){
        //        print("Save Info")
        //        UserDefaults.standard.set(authenticatedId, forKey: "authenticatedId")
        //        UserDefaults.standard.set(userStatus, forKey: "userStatus")
        //        if eventToJoin != nil {
        //             UserDefaults.standard.set(eventToJoin!.eventid!, forKey: "eventToJoinId")
        //        }else{
        //             UserDefaults.standard.set(-1, forKey: "eventToJoinId")
        //        }
        //        if eventInprogress != nil {
        //            UserDefaults.standard.set(eventInprogress!.eventid!, forKey: "eventInProgressId")
        //
        //        }else{
        //             UserDefaults.standard.set(-1, forKey: "eventInProgressId")
        //        }
        //
        //
    }
    public static func loadInformation(){
        //        let authenticatedId = UserDefaults.standard.integer(forKey: "authenticatedId")
        //        let status = UserDefaults.standard.integer(forKey: "userStatus")
        //        let eventToJoinId = UserDefaults.standard.integer(forKey: "eventToJoinId")
        //        let eventInprogressId = UserDefaults.standard.integer(forKey: "eventInProgressId")
        //
        //        print("User id")
        //        print(authenticatedId)
        //        print("event to Join id")
        //        print(eventToJoinId)
        //        print("eventInprogress id")
        //        print(eventInprogressId)
        //
        //        currentUser = connector.fectchUserInformationById(id: authenticatedId)
        //        userStatus = status
        //        eventToJoin = connector.loadEventById(id:eventToJoinId)
        //        eventInprogress = connector.loadEventById(id:eventInprogressId)
        //        print(currentUser?.userid)
        //        print(currentUser != nil)
        //        print(userStatus)
        //
    }
    public static func loadUserState(userid:Int){
        if let event = connector.findEventToJoinByUserId(userid: userid){
            eventToJoin = event
            userStatus = UserState.accepted
        }
        if let event = connector.findEventInProgress(userid: userid){
            eventInprogress = event
            userStatus = UserState.onEvent
        }
        if eventInprogress == nil {
            if let event = connector.findEventInProgressAsPartner(userid: userid){
                eventInprogress = event
                userStatus = UserState.onEvent
            }
        }
        
    }
    
}
