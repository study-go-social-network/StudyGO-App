import UIKit
import OHMySQL

var coordinator = OHMySQLStoreCoordinator()
let context = OHMySQLQueryContext()
let dbName = "social_network"
let tableName = "usr"
let SQLUserName = "iostester"
let SQLPassword = "123"
let SQLServerName = "95.179.235.90"
let SQLServerPort:UInt = 3306

let user = OHMySQLUser(userName: SQLUserName, password: SQLPassword, serverName: SQLServerName, dbName: dbName, port: SQLServerPort, socket: nil)
coordinator = OHMySQLStoreCoordinator(user:user!)
coordinator.encoding = .UTF8MB4
coordinator.connect()
let sqlConnected:Bool = coordinator.isConnected
context.storeCoordinator = coordinator
//let query = OHMySQLQueryRequestFactory.select("usr", condition: nil)
//query.queryString
//let insertQuery = OHMySQLQueryRequestFactory.insert("usr", set: ["id":"4","username":"Cindy","password":"100"])
//let deleteQuery = OHMySQLQueryRequestFactory.delete("usr", condition: "id = 4")
//do{
//    let respone = try context.executeQueryRequestAndFetchResult(query)
//    print(respone)
//}catch{
//    print(error)
//}
let userInformationQuery = OHMySQLQueryRequestFactory.select("user", condition: "name = 'f'")
let imageSrcQuery = OHMySQLQueryRequestFactory.select("avatar", condition: "userid = 26")
var imageResult:[[String:Any]] = []
var result:[[String:Any]] = []
do{
    let respone = try context.executeQueryRequestAndFetchResult(userInformationQuery)
    
    result = respone
    imageResult = try context.executeQueryRequestAndFetchResult(imageSrcQuery)
    
    print(respone)
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
        sex = "Unknown"
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
}
var imageSrc = "http://95.179.235.90:8080/static/upload/user/"
if imageResult.count == 1 {
    let entry = imageResult[0]
    if let value = entry["photo"] as? String{
        imageSrc += value
    }else{
        imageSrc = "http://95.179.235.90:8080/static/img/head.png"
    }
}
print(imageSrc)

class User{
    
}
func userAuthentication(username:String,password:String)->Bool{
    let userInformationQuery = OHMySQLQueryRequestFactory.select("user", condition: "name = '\(username)' and password = '\(password)'")
    var result:[[String:Any]] = []
    do{
        result = try context.executeQueryRequestAndFetchResult(userInformationQuery)
    }catch{
       // print(error)
    }
    if result.count == 1 {
        return true
    }
    
    return false
    
}
class EventObject{
    var eventid:Int?
    var userid:Int
    var title:String
    var dueTime:String
    var slat:String
    var slng:String
    var description:String
    init(userid:Int,title:String,dueTime:String,slat:String,slng:String, description:String) {
        self.userid = userid
        self.title = title
        self.dueTime = dueTime
        self.slat = slat
        self.slng = slng
        self.description = description
    }
    
}
func insertEvent(event:EventObject)->Bool{
    let eventQuery = OHMySQLQueryRequestFactory.insert("event", set: ["userid":event.userid,"slat":event.slat,"slng":event.slng,"end_time":event.dueTime,"description":event.description,"title":event.title])
    do{
       let bol = try context.executeQueryRequestAndFetchResult(eventQuery)
       print(bol)
    }catch{
       //
    }
    let validateQuery = OHMySQLQueryRequestFactory.select("event", condition:"userid = \(event.userid) and title = '\(event.title)'")
    var result:[[String:Any]] = []
    do{
       result = try context.executeQueryRequestAndFetchResult(validateQuery)
    }catch{
        
    }
    if result.count == 1 {
        // successfully
       return true
    }else{
        
    }
    return false

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
    for entry in result{
        events.append(EventObject(userid: entry["userid"] as! Int, title: entry["title"] as! String, dueTime: entry["end_time"] as! String, slat: (entry["slat"] as! NSDecimalNumber).doubleValue.description, slng: (entry["slng"] as! NSDecimalNumber).doubleValue.description, description: entry["description"] as! String))
    }
    return events
}
func sendMessage(type:String,event:EventObject,senderId:Int){
    let messageInsert = OHMySQLQueryRequestFactory.insert("message", set: ["fromuserid":senderId,"touserid":event.userid,"messageType": event.eventid])
    do{
        try context.executeQueryRequestAndFetchResult(messageInsert)
    }catch{
        print(error)
    }
}
//userAuthentication(username: "Jack", password: "1234")
//let event = EventObject(userid: 100, title: "Learn COMP220", dueTime: "2019-04-15 15:00:00", slat: "53.406566", slng: "-2.966531", description: "Hello")
//insertEvent(event: event)
//loadEvent()
//var h:NSDecimalNumber = 1.2
//h.doubleValue.description

// 1 convert

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
    if checkPartnerAvaliable(eventid: eventid) == false{
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
    let query = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(userid) and time>\(time)")
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
func checkRateByUserIdInRank(userid:Int)->Int{
    let selectQuery = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(userid)")
    do{
        
        let respone = try context.executeQueryRequestAndFetchResult(selectQuery)
        let rate = (respone.first?["rate"] as? Int)!
        print(respone)
        return rate
        
    }catch{
        print(error)
    }
    return 0
}

func checksstimeByUserIdInRank(userid:Int)->Int{
    let selectQuery = OHMySQLQueryRequestFactory.select("ranking", condition: "userid = \(userid)")
    do{
        
        let respone = try context.executeQueryRequestAndFetchResult(selectQuery)
        let sstime = (respone.first?["sstime"] as? Int)!
        print(respone)
        return sstime
        
    }catch{
        print(error)
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
        let level = (total*1000)/250
        let query2 = OHMySQLQueryRequestFactory.update("ranking", set: ["total":total,"level":Int(level)], condition: "userid = \(id)")
        do{
            try context.executeQueryRequestAndFetchResult(query2)
        }catch{
            print(error)
        }
        
    }
    
    
}
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
//checkPartnerAvaliable(eventid: <#T##Int#>)

updateRanking(id: 55, time: 2, rate: 5)
//updateRankTable(id:26,time: 8, rate: 5)
checksstimeByUserIdInRank(userid: 55)
checkPartnerAvaliable(eventid: 1000)

