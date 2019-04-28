//
//  ViewController.swift
//  StudyApp
//
//  Created by Alexander on 18/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBAction func queryDb(_ sender: Any) {
        let db = DBConnector()
        //label.text = db.query()
        label.text = db.insertEvent()
    }
    @IBOutlet weak var queryDb: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

