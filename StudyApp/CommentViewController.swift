//
//  CommentViewController.swift
//  StudyApp
//
//  Created by Alexander on 20/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit
import Cosmos
class CommentViewController: UIViewController {
    var studyTimerController:StudyTimerViewController!
    var score = 0

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scoreIndicator: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBAction func finish(_ sender: Any) {
        score = Int(rateView.rating)
       
        if currentUser!.userid == eventInprogress?.holder.userid{
            if !connector.checkPartnerAvaliable(eventid: eventInprogress!.eventid!){
                connector.addPartnerRateByEventId(eventid: eventInprogress!.eventid!, prate: score)
                // send message to event partner
                
               // connector.sendMessageById(type: "RATE", event: eventInprogress!, senderId: currentUser!.userid, touserid: connector.checkPartnerId(eventid: eventInprogress!.eventid!)!)
                let partnerid = connector.checkPartnerId(eventid: eventInprogress!.eventid!)!
                let studyHours = connector.loadPartnerStudyHour(eventid: eventInprogress!.eventid!, userid: partnerid)
                connector.updateRanking(id: partnerid, time: studyHours, rate: score)
            }
        }else{
            connector.addUserRateByEventId(eventid: eventInprogress!.eventid!, urate: score)
            // send message to the holder
           //            connector.sendMessageById(type: "RATE", event: eventInprogress!, senderId: currentUser!.userid, touserid: eventInprogress!.holder.userid)
            let studyHours = connector.loadHolderStudyHour(eventid: eventInprogress!.eventid!, userid: eventInprogress!.holder.userid)
            connector.updateRanking(id: eventInprogress!.holder.userid, time: studyHours, rate: score)
        }
        self.dismiss(animated: true, completion: nil)
        studyTimerController.dismiss(animated: true, completion: nil)
    }
//    @IBAction func first(_ sender: Any) {
//        score = 1
//    }
//    @IBAction func second(_ sender: Any) {
//        score = 2
//    }
//    @IBAction func third(_ sender: Any) {
//        score = 3
//    }
//
//    @IBAction func forth(_ sender: Any) {
//        score = 4
//    }
//
//    @IBAction func fifth(_ sender: Any) {
//        score = 5
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rateView.didTouchCosmos = {rating in
            self.scoreIndicator.text = rating.description
            if rating == 5 {
                self.commentLabel.text = "Excellent"
                self.commentLabel.textColor = UIColor(displayP3Red: 247/255, green: 204/255, blue: 81/255, alpha: 1)
            }else if rating < 5 && rating > 2{
                self.commentLabel.text = "Good"
                self.commentLabel.textColor = UIColor(displayP3Red: 96/255, green: 249/255, blue: 206/255, alpha: 1)
            }else{
                self.commentLabel.text = "Poor"
                self.commentLabel.textColor = UIColor(displayP3Red: 170/255, green: 121/255, blue: 66/255, alpha: 1)
                
            }
        }

        // Do any additional setup after loading the view.
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
