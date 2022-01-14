//
//  NotificationResult.swift
//  Infoapteka
//
//

import UIKit
import ObjectMapper

struct NotifResult: Mappable {

    var count    : Int?
    var next     : Int?
    var previous : Int?
    var results  : [Notif] = []

    init(map: Map) {}

    mutating func mapping(map: Map) {
        count    <- map["count"]
        next     <- map["next"]
        previous <- map["previous"]
        results  <- map["results"]
    }
}

struct Notif: Mappable {
    var id    : Int?
    var title : String?
    var isActive  : Bool = false
    var createdAt : String?
    var type : NotifType?
    var body : NotifBody?
    var isViewed: Bool = false {
        didSet {
            statusColor = isViewed ? Asset.mainWhite.color : Asset.notifIsViewed.color
            switchModel()
        }
    }
    var icon: UIImage?
    var statusColor: UIColor?

    init(map: Map) {}

    mutating func mapping(map: Map) {
        id     <- map["id"]
        title  <- map["title"]
        type <- map["notice_type"]
        isViewed   <- map["is_viewed"]
        isActive   <- map["is_active"]
        createdAt  <- map["created_at"]
        body <- map["body"]
    }

    private mutating func switchModel() {
        switch type {
        case .accountApproved, .drugApproved:
            icon = !isViewed ? Asset.icViewedAccountApproved.image : Asset.icNotViewedAccountApproved.image
            break
        case .accountRejected, .drugRejected:
            icon = !isViewed ? Asset.icViewedAccountRejected.image : Asset.icNotViewedAccountRejected.image
            break
        case .orderProcessed:
            icon = Asset.icOrderProcessed.image
            break
        case .orderDelivered:
            icon = Asset.icOrderDelivered.image
            break
        case .none, .some(_): break
        }
    }
}

class NotifBody: NSObject, Mappable  {

    var object_id: Int?
    var title: String?
    var desc: String?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        object_id <- map["object_id"]
        title <- map["title"]
        desc <- map["description"]
    }
}
