//
//  RemotePush.swift
//  Infoapteka
//
//

import Foundation

struct RemotePush: Decodable {
    let aps         : APS
    let sound       : String?
    let badge       : Int?
    let object_id   : String?
    let type        : PostType?

    struct APS: Decodable {
        let alert: Alert

        struct Alert: Decodable {
            let title   : String
            let body    : String
        }
    }

    enum PostType: String, Codable {
        case new_follower, new_publication, new_comment
    }

    init(decoding userInfo: [AnyHashable : Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        self = try JSONDecoder().decode(RemotePush.self, from: data)
    }
}
