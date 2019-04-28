//
//  MyTableViewCell.swift
//  StudyApp
//
//  Created by Alexander on 26/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    

  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        awakeFromNib()
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
        //self.frame.height = 100
//        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.accessibilityFrame().width, height: 100)
       
        self.contentView.backgroundColor = .init(red: 69/255, green: 130/255, blue: 247/255, alpha: 1)

        self.contentView.layer.cornerRadius = 30

        self.contentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
