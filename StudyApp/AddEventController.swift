//
//  AddEventController.swift
//  StudyApp
//
//  Created by Alexander on 19/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {
    
    @IBOutlet weak var titleInputField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var locationDescription: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderColor = UIColor(displayP3Red: 204.0/255.0, green: 204.0/255, blue: 204.0/255, alpha: 1.0).cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5.0
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:))))

        // Do any additional setup after loading the view.
    }
    @objc func handleTap(sender: UITapGestureRecognizer){
        if sender.state == .ended{
            titleInputField.resignFirstResponder()
            descriptionTextView.resignFirstResponder()
        }
    }
    
    @IBAction func confirmEvent(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = dateFormatter.string(from: timePicker.date)
        
        if currentUser != nil{
            if titleInputField.text == nil {
                return
            }
            if titleInputField.text != nil && descriptionTextView.text != nil {
               //let connector = DBConnector()
                
                let newEvent = EventObject(holder: currentUser!, title: titleInputField.text!, dueTime: result, slat: (userLocationMonitor?.location?.coordinate.latitude.description)!, slng: (userLocationMonitor?.location?.coordinate.longitude.description)!, description: descriptionTextView.text)
                if connector.insertEvent(event: newEvent) {
                    
                    navigationController?.popViewController(animated: false)
                    eventInprogress = newEvent
                    userStatus = UserState.onEvent
                    Saver.saveInformation()
                    performSegue(withIdentifier: "toStudyClock", sender: nil)
                    //self.popoverPresentationController
                }
              //  connector.disconnected()
                connector.addEvent(eventid: newEvent.eventid!, userid: currentUser!.userid, ustart: dateFormatter.string(from: Date(timeIntervalSinceNow: 1)), uend: newEvent.dueTime)
                
            }
        }
        
        print(result)
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
