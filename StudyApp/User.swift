//
//  User.swift
//  Let's Study
//
//  Created by Alexander on 17/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import Foundation
class User{
    let userName:String
    let userId:String
    let userProfileImageSrc:String
    var userLv:Int = 0
    init(userName:String,userId:String,userImageSrc:String) {
        self.userName = userName
        self.userId = userId
        self.userProfileImageSrc = userImageSrc
        
    }
    func setLv(newLv:Int){
        self.userLv = newLv
    }
}
class UserObject{
    var userid:Int = 0
    var family:String = ""
    var intro:String = ""
    var sex:String = ""
    var email:String = ""
    var name:String = ""
    var age:Int? = 0
    var userImageSrc:String = ""
    init(id:Int,family:String,intro:String,sex:String,email:String,name:String,age:Int?,userImageSrc:String) {
        self.userid = id
        self.family = family
        self.intro = intro
        self.sex = sex
        self.email = email
        self.name = name
        self.age = age
        self.userImageSrc = userImageSrc
    }
   
}
