//
//  Message.swift
//  BarberApp
//
//  Created by 최지원 on 4/19/22.
//

import Foundation
import MessageKit
import UIKit
import Firebase

// https://ibjects.medium.com/simple-text-chat-app-using-firebase-in-swift-5-b9fa91730b6c
// Reference to the website I got help from when developing the messaging feature
struct Message {
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    var dictionary: [String: Any] {
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName":senderName]
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let content = dictionary["content"] as? String,
              let created = dictionary["created"] as? Timestamp,
              let senderID = dictionary["senderID"] as? String,
              let senderName = dictionary["senderName"] as? String
        else {return nil}
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
    }
}

extension Message: MessageType {
    
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    var sentDate: Date {
        return created.dateValue()
    }
    var kind: MessageKind {
        return .text(content)
    }
}
