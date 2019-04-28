//
//  Message.swift
//  StudyApp
//
//  Created by Alexander on 19/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import Foundation
class Message{
    var fromUserid:Int = 0
    var toUserid:Int = 0
    var eventid:Int = 0
    var messageType = ""
    init(from:Int,to:Int,eventId:Int,messageType:String){
        self.fromUserid = from
        self.toUserid = to
        self.eventid = eventId
        self.messageType = messageType
    }
}
