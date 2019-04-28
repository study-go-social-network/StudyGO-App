//
//  DBConnector.swift
//  StudyApp
//
//  Created by Alexander on 18/04/2019.
//  Copyright © 2019 sgqyang4. All rights reserved.
//

import Foundation
import OHMySQL
class DBConnector {
    var coordinator = OHMySQLStoreCoordinator()
    let context = OHMySQLQueryContext()
    let dbName = "social_network"
    let tableName = "usr"
    let SQLUserName = "iostester"
    let SQLPassword = "123"
    let SQLServerName = "95.179.235.90"
    let SQLServerPort:UInt = 3306
    let user:OHMySQLUser!
    init() {
        user = OHMySQLUser(userName: SQLUserName, password: SQLPassword, serverName: SQLServerName, dbName: dbName, port: SQLServerPort, socket: nil)
        
        coordinator = OHMySQLStoreCoordinator(user:user!)
        coordinator.encoding = .UTF8MB4
        coordinator.connect()
        let sqlConnected:Bool = coordinator.isConnected
        context.storeCoordinator = coordinator
    }
    
    func checkValidEvent(eventId:Int)->Bool{
        let query = OHMySQLQueryRequestFactory.select("event", condition: "eventid = \(eventId)")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            let end = result.first!["end_time"] as! String
            let currentDate = Date(timeIntervalSinceNow: 1)
            
            //        let currentDate = Date()
            
            let dateFormatter = DateFormatter()
            
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //"HH:mm:ss"
            let currentTime = Date(timeInterval: dateFormatter.date(from: end)!.timeIntervalSinceNow, since: dateFormatter.date(from: end)!)
            
            let now = dateFormatter.string(from: currentDate)
            let date1 = dateFormatter.date(from: now)!
            let date2 = dateFormatter.date(from: end)!
            let diff = Int(date2.timeIntervalSince(date1))
            if diff <= 0 {
                return false
            }else{
                return true
            }
            
        }
        
        return false
        
    }
    func query() ->String{
        
        let query = OHMySQLQueryRequestFactory.select("usr", condition: nil)
        
        var result = "No respones"
        do{
            let respone = try context.executeQueryRequestAndFetchResult(query)
            print(respone)
            result = respone.description
            
        }catch{
            print(error)
        }
        return result
    }
    func insertEvent()->String{
        let insertQuery = OHMySQLQueryRequestFactory.insert("usr", set: ["id":4,"username":"Cindy","password":"100"])
        var result = ""
        do{
            let response = try context.executeQueryRequestAndFetchResult(insertQuery)
            result = response.description
            print(response)
            
        }catch{
            print(error)
        }
        return result
    }
    
    func deleteEvent(){
        let deleteQuery = OHMySQLQueryRequestFactory.delete("usr", condition: "id = 4")
        do{
            let response = try context.executeQueryRequestAndFetchResult(deleteQuery)
        }catch{
            print(error)
        }
    }
    func userAuthentication(username:String,password:String)->UserObject?{
        let userInformationQuery = OHMySQLQueryRequestFactory.select("user", condition: "name = '\(username)' and password = '\(password)'")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(userInformationQuery)
        }catch{
            print(error)
        }
        if result.count == 1 {
            if let id = result[0]["userid"] as? Int {
                return fectchUserInformationById(id: id)
            }
        }
        return nil
        
    }
    
    
    func fectchUserInformationById(id:Int) -> UserObject?{
        let userInformationQuery = OHMySQLQueryRequestFactory.select("user", condition: "userid = \(id)")
        let imageSrcQuery = OHMySQLQueryRequestFactory.select("avatar", condition: "userid = \(id)")
        var imageResult:[[String:Any]] = []
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(userInformationQuery)
            imageResult = try context.executeQueryRequestAndFetchResult(imageSrcQuery)
        }catch{
            print(error)
        }
        var userid:Int = 0
        var family:String = ""
        var intro:String = ""
        var sex:String = ""
        var email:String = ""
        var name:String = ""
        var age:Int? = 0
        
        if result.count == 1{
            let entry = result[0]
            
            if let value = entry["userid"] as? Int {
                userid = value
                print(value)
            }else{
                userid = 0
            }
            if let value = entry["family"] as? String{
                family = value
            }else{
                family = "Unknown"
            }
            if let value = entry["intro"] as? String{
                intro = value
            }else{
                intro = "Unknown"
            }
            if let value = entry["sex"] as? String{
                sex = value
            }else{
                sex = "Secret"
            }
            if let value = entry["email"] as? String{
                email = value
            }else{
                email = "Unknown"
            }
            if let value = entry["name"] as? String{
                name = value
            }else{
                name = "Unknown"
            }
            if let value = (result[0]["age"] as? Int){
                age = value
            }else{
                age = nil
            }
        }else{
            print("Invalid")
            return nil
        }
        var imageSrc = "http://95.179.235.90/static/img/head.png"
        if imageResult.count == 1 {
            let entry = imageResult[0]
            if let value = entry["photo"] as? String{
                imageSrc = "http://95.179.235.90/static/upload/user/" + value
            }else{
                imageSrc = "http://95.179.235.90/static/img/head.png"
            }
        }
        print(imageSrc)
        return UserObject(id: userid, family: family, intro: intro, sex: sex, email: email, name: name, age: age, userImageSrc: imageSrc)
    }
    
    func insertEvent(event:EventObject)->Bool{
        let eventQuery = OHMySQLQueryRequestFactory.insert("event", set: ["userid":event.holder.userid,"slat":event.slat,"slng":event.slng,"end_time":event.dueTime,"description":event.description,"title":event.title])
        do{
            let bol = try context.executeQueryRequestAndFetchResult(eventQuery)
            print(bol)
        }catch{
            //
        }
        let validateQuery = OHMySQLQueryRequestFactory.select("event", condition:"userid = \(event.holder.userid) and title = '\(event.title)'")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(validateQuery)
        }catch{
            
        }
        if result.count == 1 {
            // successfully
            event.eventid = result[0]["eventid"] as? Int
            return true
        }else{
            
        }
        return false
        
    }
    func loadEventById(id:Int) ->EventObject?{
        let events = loadEvent()
        for event in events{
            if event.eventid == id {
                return event
            }
        }
        return nil
    }
    func removeEvent(eventid:Int){
        let query = OHMySQLQueryRequestFactory.delete("event", condition: "eventid = \(eventid)")
        do{
            try context.executeQueryRequestAndFetchResult(query)
        }catch{
            
        }
    }
    func findEventToJoinByUserId(userid:Int) ->EventObject?{
        let query = OHMySQLQueryRequest(queryString: "select * from study where uend > convert_tz(now(),'+00:00','+01:00') and pid = \(userid) and pstart is null")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            let eventid = result.first!["eventid"] as! Int
            return loadEventById(id: eventid)
        }
        return nil
    }
    func findEventInProgress(userid:Int)->EventObject?{
        let query = OHMySQLQueryRequest(queryString: "select * from event where userid = \(userid) and end_time > convert_tz(now(),'+00:00','+01:00')")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            let eventid = result.first!["eventid"] as! Int
            return loadEventById(id:eventid)
        }
        return nil
    }
    func findEventInProgressAsPartner(userid:Int)->EventObject?{
        let query = OHMySQLQueryRequest(queryString: "select * from study where pid = \(userid) and pstart is not null and uend > convert_tz(now(),'+00:00','+01:00')")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            let eventid = result.first!["eventid"] as! Int
            return loadEventById(id:eventid)
        }
        return nil
    }
    func loadEvent()->[EventObject]{
        let eventQuery = OHMySQLQueryRequestFactory.select("event", condition: nil)
        var result:[[String:Any]] = []
        //    var userid = 0
        //    var title = ""
        //    var slat = ""
        //    var slng = ""
        //    var description = ""
        do{
            result = try context.executeQueryRequestAndFetchResult(eventQuery)
            
        }catch{
            print(error)
        }
        var events:[EventObject] = []
        print(result)
        for entry in result{
            let holder = fectchUserInformationById(id: entry["userid"] as! Int)
            print(holder)
            let event = EventObject(holder: holder!, title: entry["title"] as! String, dueTime: entry["end_time"] as! String, slat: (entry["slat"] as! NSDecimalNumber).doubleValue.description, slng: (entry["slng"] as! NSDecimalNumber).doubleValue.description, description: entry["description"] as! String)
            event.eventid = entry["eventid"] as! Int
            events.append(event)
            
        }
        return events
    }
    func sendMessage(type:String,event:EventObject,senderId:Int){
        let messageInsert = OHMySQLQueryRequestFactory.insert("message", set: ["fromuserid":senderId,"touserid":event.holder.userid,"messageType":type,"eventid": event.eventid!,"isRead":"NO"])
        do{
            try context.executeQueryRequestAndFetchResult(messageInsert)
        }catch{
            print(error)
        }
    }
    func sendMessageById(type:String,event:EventObject,senderId:Int,touserid:Int){
        let messageInsert = OHMySQLQueryRequestFactory.insert("message", set: ["fromuserid":senderId,"touserid":touserid,"messageType":type,"eventid": event.eventid!,"isRead":"NO"])
        do{
            try context.executeQueryRequestAndFetchResult(messageInsert)
        }catch{
            print(error)
        }
    }
    
    func checkMessage(currentUserId:Int)->[Message]{
        var result:[[String:Any]] = []
        var messagesUnread:[Message] = []
        let messageQuery = OHMySQLQueryRequestFactory.select("message", condition: "touserid = \(currentUserId) and isRead = 'NO' and messageType = 'REQUEST'")
        do{
            result = try context.executeQueryRequestAndFetchResult(messageQuery)
        }catch{
            print(error)
        }
        if result.count > 0 {
            for entry in result{
                let message = Message(from: entry["fromuserid"] as! Int, to: entry["touserid"] as! Int, eventId: entry["eventid"] as! Int, messageType: entry["messageType"] as! String)
                messagesUnread.append(message)
            }
        }
        return messagesUnread
    }
    func checkReply(currentUserid:Int)->[Message]{
        var result:[[String:Any]] = []
        var messagesUnread:[Message] = []
        let messageQuery = OHMySQLQueryRequestFactory.select("message", condition: "touserid = \(currentUserid) and isRead = 'NO'")
        do{
            result = try context.executeQueryRequestAndFetchResult(messageQuery)
        }catch{
            print(error)
        }
        if result.count > 0 {
            for entry in result{
                let message = Message(from: entry["fromuserid"] as! Int, to: entry["touserid"] as! Int, eventId: entry["eventid"] as! Int, messageType: entry["messageType"] as! String)
                messagesUnread.append(message)
            }
        }
        return messagesUnread
    }
    func disconnected(){
        self.coordinator.disconnect()
    }
    
    //读取成功的请求
    func readMessage(message:Message){
        let readUpdate = OHMySQLQueryRequestFactory.update("message", set: ["isRead":"YES"], condition: "fromuserid = \(message.fromUserid) and touserid = \(message.toUserid) and messageType = 'REQUEST'")
        do{
            try context.executeQueryRequestAndFetchResult(readUpdate)
        }catch{
            
        }
    }
    func readReply(message:Message){
        let readUpdate = OHMySQLQueryRequestFactory.update("message", set: ["isRead":"YES"], condition: "fromuserid = \(message.fromUserid) and touserid = \(message.toUserid) and messageType = '\(message.messageType)'")
        do{
            try context.executeQueryRequestAndFetchResult(readUpdate)
        }catch{
            
        }
    }
    
    //还要实现的功能
    // queryRankByUserid
    func queryRankByUserid(userid:Int)->Int{
        var rank:Int?
        return rank!
    }
    
    //updateRankBy study hours and user id
    func updateRankByUserid(userid:Int,studyTime:Int,score:Int){
        
    }
    
    //update
    
    
    
}
extension DBConnector{
    func checkPartnerAvaliable(eventid:Int) -> Bool{
        let query = OHMySQLQueryRequestFactory.select("study", condition: "eventid = \(eventid)")
        var result:[[String:Any]] = []
        
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }
        catch{
        }
        if result.count == 1{
            if let value = result.first?["pid"] as? Int{
                return false
            } else{
                return true
            }
        }
        return false
    }
    func checkPartnerId(eventid:Int) -> Int?{
        let query = OHMySQLQueryRequestFactory.select("study", condition: "eventid = \(eventid)")
        var result:[[String:Any]] = []
        
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }
        catch{
        }
        if result.count == 1{
            if let value = result.first?["pid"] as? Int{
                return value
            } else{
                return nil
            }
        }
        return nil
    }
    func addEventId(eventid:Int){
        let insertQuery = OHMySQLQueryRequestFactory.insert("study", set: ["eventid":eventid])
        do{
            let respone = try context.executeQueryRequestAndFetchResult(insertQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addUserByEventId(eventid:Int, userid:Int){
        let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["userid":userid], condition: "eventid = \(eventid)")
        do{
            let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addUserRateByEventId(eventid:Int, urate:Int) {
        let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["urate":urate], condition: "eventid = \(eventid)")
        do{
            let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addPartnerRateByEventId(eventid:Int, prate:Int) {
        let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["prate":prate], condition: "eventid = \(eventid)")
        do{
            let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addUserStartTimeByEventId(eventid:Int, ustart:String){
        let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["ustart":ustart], condition: "eventid = \(eventid)")
        do{
            let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addUserEndTimeByEventId(eventid:Int, uend:String){
        let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["uend":uend], condition: "eventid = \(eventid)")
        do{
            let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addPartnerStartTimeByEventId(eventid:Int, pstart:String){
        let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["pstart":pstart], condition: "eventid = \(eventid)")
        do{
            let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    func addPartnerByEventId(eventid:Int, pid:Int){
        if checkPartnerAvaliable(eventid: eventid) == true{
            let updateQuery = OHMySQLQueryRequestFactory.update("study", set: ["pid":pid], condition: "eventid = \(eventid)")
            do{
                let respone = try context.executeQueryRequestAndFetchResult(updateQuery)
                print(respone)
                
            }catch{
                print(error)
            }
        }
    }
    
    func addEvent(eventid:Int,userid:Int,ustart:String,uend:String){
        let insertQuery = OHMySQLQueryRequestFactory.insert("study", set: ["eventid":eventid,"userid":userid,"ustart":ustart,"uend":uend])
        do{
            let respone = try context.executeQueryRequestAndFetchResult(insertQuery)
            print(respone)
            
        }catch{
            print(error)
        }
    }
    
    
    //
    
    
    func checkRankByUserIdInRank(userid:Int)->Int{
        let selectQuery = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(userid)")
        do{
            
            let respone = try context.executeQueryRequestAndFetchResult(selectQuery)
            let level = (respone.first?["level"] as? Int)!
            print(respone)
            return level
            
        }catch{
            print(error)
        }
        return 0
    }
    
    func checkTimeByUserIdInRank(userid:Int)->Double{
        let selectQuery = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(userid)")
        do{
            
            let respone = try context.executeQueryRequestAndFetchResult(selectQuery)
            let time = (respone.first?["time"] as? Double)!
            print(respone)
            return time
            
        }catch{
            print(error)
        }
        return 0
    }
    
    func checkOrderByUserId(userid:Int,time:Double)->Int{
        let query = OHMySQLQueryRequestFactory.select("ranking", condition: " time >\(time)")
        var result:[[String:Any]]?
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            
        }
        return result!.count+1
    }
    
    func checkNameByOrder(order:Int)->String{
        let query = OHMySQLQueryRequestFactory.select("ranking", condition: nil)
        var result:[[String:Any]]?
        var o:Int
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            
        }
        if let name = result?.first?["name"] as? String{
            for _ in result!{
                o = order - 1
                print(o)
                if o==0{
                    return name
                }
                else{
                    result?.removeFirst()
                    
                }
            }
        }
        return "error"
    }
    
    func loadHolderStudyHour(eventid:Int,userid:Int) ->Double{
        let query = OHMySQLQueryRequestFactory.select("study", condition: "eventid = \(eventid)")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            
            let dateFormatter = DateFormatter()
            
            let startTime = result.first!["ustart"] as? String
            let endTime = result.first!["uend"] as? String
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //"HH:mm:ss"
            
            
            
            let date1 = dateFormatter.date(from: startTime! )!
            let date2 = dateFormatter.date(from: endTime!)!
            let diff = Double(date2.timeIntervalSince(date1))
            let hours = diff/3600
            return hours
        }
        return 0
    }
    func loadPartnerStudyHour(eventid:Int,userid:Int) ->Double{
        let query = OHMySQLQueryRequestFactory.select("study", condition: "eventid = \(eventid)")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            
            let dateFormatter = DateFormatter()
            
            let startTime = result.first!["pstart"] as? String
            let endTime = result.first!["uend"] as? String
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            //"HH:mm:ss"
            
            
            
            let date1 = dateFormatter.date(from: startTime! )!
            let date2 = dateFormatter.date(from: endTime!)!
            let diff = Double(date2.timeIntervalSince(date1))
            let hours = diff/3600
            return hours
        }
        return 0
    }
    func updateRankTable(id:Int,time:Double,rate:Int){
        // let query = OHMySQLQueryRequestFactory.update("ranking", set: ["time":"time + \(time)","rate":"rate + \(rate)","sstime":"sstime + 1"], condition: "userid = \(id)")
        let query2 = OHMySQLQueryRequest(queryString: "UPDATE ranking SET rate = rate + \(rate), sstime = sstime + 1, time = time + \(time) WHERE userid = \(id)")
        print(query2.queryString)
        do{
            try context.executeQueryRequestAndFetchResult(query2)
            
        }catch{
            print(error)
        }
    }
    func updateRanking(id:Int,time:Double,rate:Int){
        updateRankTable(id: id, time: time, rate: rate)
        let query = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(id)")
        var result:[[String:Any]] = []
        do{
            result =  try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            // let favouriteNumber = result.first!["favoritenum"] as! Int
            // let followNumber = result.first!["follownum"] as! Int
            //  let time = result.first!["time"] as! Double
            // let rate = result.first!["rate"] as! Int
            // let postNum = result.first!["postnum"] as! Int
            // let sstime = result.first!["sstime"] as! Int
            var total = result.first!["total"] as! Double
            
            // let total = calculateTotalStudyHours(studyTime: time, studyScore: rate, ssTime: sstime, likeNumber: favouriteNumber, followNumber: followNumber, postNumber: postNum)
            total = total + Double(rate)*time
            let level = total/10
            let query2 = OHMySQLQueryRequestFactory.update("ranking", set: ["total":total,"level":Int(level)], condition: "userid = \(id)")
            do{
                try context.executeQueryRequestAndFetchResult(query2)
            }catch{
                print(error)
            }
            
        }
        
        
    }
    
    func checkEmailByUserId(userid:Int)->String?{
        let selectQuery = OHMySQLQueryRequestFactory.select("user", condition: "userid = \(userid)")
        do{
            
            let respone = try context.executeQueryRequestAndFetchResult(selectQuery)
            let email = (respone.first?["email"] as? String)!
            print(respone)
            return email
            
        }catch{
            print(error)
        }
        return nil
    }
    
    func checkIntroByUserId(userid:Int)->String?{
        let selectQuery = OHMySQLQueryRequestFactory.select("user", condition: "userid = \(userid)")
        do{
            
            let respone = try context.executeQueryRequestAndFetchResult(selectQuery)
            if let intro = (respone.first?["intro"] as? String){
                print(respone)
                return intro
            }
            else{
                return "too lazy"
            }
            
        }catch{
            print(error)
        }
        return nil
    }
    
    
//    func updateRanking(id:Int,time:Double,rate:Int){
//        updateRankTable(id: id, time: time, rate: rate)
//        let query = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(id)")
//        var result:[[String:Any]] = []
//        do{
//            result =  try context.executeQueryRequestAndFetchResult(query)
//        }catch{
//            print(error)
//        }
//        if result.count == 1 {
//            let favouriteNumber = result.first!["favoritenum"] as! Int
//            let followNumber = result.first!["follownum"] as! Int
//            let time = result.first!["time"] as! Double
//            let rate = result.first!["rate"] as! Int
//            let postNum = result.first!["postnum"] as! Int
//            let sstime = result.first!["sstime"] as! Int
//            
//            let total = calculateTotalStudyHours(studyTime: time, studyScore: rate, ssTime: sstime, likeNumber: favouriteNumber, followNumber: followNumber, postNumber: postNum)
//            let level = (total*1000)/250
//            let query2 = OHMySQLQueryRequestFactory.update("ranking", set: ["total":total,"level":Int(level)], condition: "userid = \(id)")
//            do{
//                try context.executeQueryRequestAndFetchResult(query2)
//            }catch{
//                print(error)
//            }
//            
//        }
//        
//        
//    }
    private func sigmoid(input:Double)->Double{
        var result:Double = 0
        result = 1/(1+exp(-input))
        return result
    }
    private func contributionFunction(x:Double)->Double{
        if x == 0{
            return 0
        }else if x == 1 {
            return 1
        }else{
            return sigmoid(input:log(x))
        }
    }
    func calculateActiveStudyHours(studyTime:Double,studyScore:Int,ssTime:Int) ->Double{
        return studyTime*(Double(studyScore)/(5*Double(ssTime)))
    }
    func calculateContributionHours(likeNumber:Int,followNumber:Int,postNumber:Int) ->Double{
        if postNumber*followNumber == 0{
            return 0.5*Double(postNumber)
        }else{
            return 0.5*Double(postNumber)+contributionFunction(x: Double(likeNumber/(postNumber*followNumber)))
        }
        
    }
    func calculateTotalStudyHours(studyTime:Double,studyScore:Int,ssTime:Int,likeNumber:Int,followNumber:Int,postNumber:Int) ->Double{
        return calculateActiveStudyHours(studyTime: studyTime, studyScore: studyScore, ssTime: ssTime)+calculateContributionHours(likeNumber: likeNumber, followNumber: followNumber, postNumber: postNumber)
        
    }
    func fetchProfileData() -> [MyStruct]{
        var temp: [MyStruct] = []
        let query = OHMySQLQueryRequest(queryString: "select * from ranking where userid = \(currentUser!.userid)")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        if result.count == 1 {
            let studyTime = result.first!["time"] as! Double
            let totalRate = result.first!["rate"] as! Int
            let postnum = result.first!["postnum"] as! Int
            let like = result.first!["favoritenum"] as! Int
            let follow = result.first!["follownum"] as! Int
            let sstime = result.first!["sstime"] as! Int
            let totalScore = result.first!["total"] as! Double
            temp.append(MyStruct(title: "Like", description: like.description))
            temp.append(MyStruct(title: "Follow", description: follow.description))
            temp.append(MyStruct(title: "Post", description: postnum.description))
            temp.append(MyStruct(title: "Study Time", description: String(format: "%.3f", studyTime)+"H"))
            temp.append(MyStruct(title: "Successfully Study", description: sstime.description+" times"))
            temp.append(MyStruct(title: "Total Rates", description: totalRate.description))
            temp.append(MyStruct(title: "Total Score", description: Int(totalScore*1000).description))
        }
        return temp
    }
    
    func fetchRankInfo() ->[MyStruct]{
        var temp: [MyStruct] = []
        let query = OHMySQLQueryRequest(queryString: "select * from ranking order by total desc;")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        var rank = 1
        for entry in result {
            let name = entry["username"] as! String
            let score = entry["total"] as! Double
            temp.append(MyStruct(title: "Rank \(rank) \(name)", description: "\(Int(score*1000))"))
            rank = rank + 1
        }
        return temp
    }
    func calculateRank() ->Int{
        let query = OHMySQLQueryRequest(queryString: "select * from ranking order by total desc;")
        var result:[[String:Any]] = []
        do{
            result = try context.executeQueryRequestAndFetchResult(query)
        }catch{
            print(error)
        }
        var rank = 1
        for entry in result {
            let name = entry["username"] as! String
            if name == currentUser!.name {
                return rank
            }
            rank = rank + 1
            
        }
        return 0
    }
    
    
}

