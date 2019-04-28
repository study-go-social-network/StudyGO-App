//
//  ProfileViewController.swift
//  AlertTest
//
//  Created by Alexander on 26/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
class ProfileFinalViewController: UIViewController {
    
 
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var level: UILabel!
    
    @IBOutlet weak var rankView: UIView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageBackGround: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentControl: TwicketSegmentedControl!
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        segmentControl.delegate = self
        
        segmentControl.setSegmentItems(["Profiles","Ranking","Settings"])
        segmentControl.backgroundColor = UIColor.clear
        
        
        name.text = currentUser?.name
        if currentUser?.age == nil {
            age.text = "Secret"
        }else{
            age.text = currentUser?.age?.description
        }
        
       gender.text = currentUser?.sex
        level.text = "\(+connector.checkRankByUserIdInRank(userid: currentUser!.userid))"
        //studytime.text = "\(connector.checkTimeByUserIdInRank(userid:  currentUser!.userid))"
        email.text = connector.checkEmailByUserId(userid: currentUser!.userid)
       // intro.text = connector.checkIntroByUserId(userid: currentUser!.userid)
        rank.text = connector.calculateRank().description
        do{
            let url = URL(string:currentUser!.userImageSrc)
            let data = try Data(contentsOf:url!)
            let image = UIImage(data:data)
            imageView.image = image
            imageBackGround.image = image
        }catch{
            print(error)
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
extension ProfileFinalViewController:TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            profileView.setNeedsLayout()
            profileView.isHidden = false
            rankView.isHidden = true
            settingView.isHidden = true
        }else if segmentIndex == 1{
            rankView.setNeedsLayout()
            rankView.isHidden = false
            profileView.isHidden = true
            settingView.isHidden = true
        }else{
            profileView.isHidden = true
            rankView.isHidden = true
            settingView.isHidden = false
        }
        print(segmentIndex)
    }
    
    
}

