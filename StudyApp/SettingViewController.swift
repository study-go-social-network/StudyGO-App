//
//  SettingViewController.swift
//  StudyApp
//
//  Created by Alexander on 26/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit

class SettingViewController: ViewController {

    @IBAction func logoff(_ sender: Any) {
        currentUser = nil
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
