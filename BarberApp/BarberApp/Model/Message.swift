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

//
//struct Message: MessageType {
//
//    let id: String?
//    var messageId: String {
//        return id ?? UUID().uuidString
//    }
//    let content: String
//    let sentDate: Date
//    let sender: SenderType
//    var kind: MessageKind {
//        if let image = image {
//            let mediaItem = ImageMediaItem(image: image)
//            return .photo(mediaItem)
//        } else {
//            return .text(content)
//        }
//    }
//
//    var image: UIImage?
//    var downloadURL: URL?
//
//    init(user: User, content: String) {
//        sender = Sender(senderId: user.id!, displayName: user.firstname!)
//        self.content = content
//        sentDate = Date()
//        id = nil
//    }
//
//    init(user: User, image: UIImage) {
//        sender = Sender(senderId: user.id!, displayName: user.firstname!)
//        self.image = image
//        sentDate = Date()
//        content = ""
//        id = nil
//    }
//
//    init?(document: QueryDocumentSnapshot) {
//        let data = document.data()
//        guard let sentDate = data["created"] as? Timestamp,
//              let senderId = data["senderId"] as? String,
//              let senderName = data["senderName"] as? String else { return nil }
//        id = document.documentID
//        self.sentDate = sentDate.dateValue()
//        sender = Sender(senderId: senderId, displayName: senderName)
//
//        if let content = data["content"] as? String {
//            self.content = content
//            downloadURL = nil
//        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
//            downloadURL = url
//            content = ""
//        } else {
//            return nil
//        }
//    }
//
//}
//
//extension Message: DatabaseRepresentation {
//    var representation: [String : Any] {
//        var representation: [String: Any] = [
//            "created": sentDate,
//            "senderId": sender.senderId,
//            "senderName": sender.displayName
//        ]
//
//        if let url = downloadURL {
//            representation["url"] = url.absoluteString
//        } else {
//            representation["content"] = content
//        }
//
//        return representation
//    }
//}
//
//extension Message: Comparable {
//  static func == (lhs: Message, rhs: Message) -> Bool {
//    return lhs.id == rhs.id
//  }
//
//  static func < (lhs: Message, rhs: Message) -> Bool {
//    return lhs.sentDate < rhs.sentDate
//  }
//}
