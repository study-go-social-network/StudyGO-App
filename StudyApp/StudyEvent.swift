//
//  StudyEvent.swift
//  Let's Study
//
//  Created by Alexander on 17/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import Foundation
//class StudyEvent{
//    var eventId : String?
//    var eventTitle: String?
//    var capacityLimit: Int?
//    var currentCapacity: Int?
//    var eventHolder:User?
//    var joiners:[User]?
//    
//    
//    
//}
struct StudyEvent{
    var userId:String
    var title:String
    var dueTime:String
    var lat:String
    var long:String
    
    var userImage:String
    var holder:User
    var capacity:Int
    var joiners:[User]
}

class EventObject{
    var eventid:Int?
    var holder:UserObject
    var title:String
    var dueTime:String
    var slat:String
    var slng:String
    var description:String
    init(holder:UserObject,title:String,dueTime:String,slat:String,slng:String, description:String) {
        self.holder = holder
        self.title = title
        self.dueTime = dueTime
        self.slat = slat
        self.slng = slng
        self.description = description
    }
    
}
