//
//  ChatViewController.swift
//  BarberApp
//
//  Created by 최지원 on 4/18/22.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
//import SDWebImage

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {


    var currentUser: User
    
    var user2Name: String?
    var user2ImgUrl: String?
    var user2UID: String?
    
    private var docReference: DocumentReference?
    
    var messages: [Message] = []
    
    init(user: User, user2: User) {
        self.currentUser = user
        self.user2Name = user2.firstname
        self.user2UID = user2.id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = user2Name ?? "Chat"

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true

        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        loadChat()
        
    }
    
    // MARK: - Custom messages handlers
    
    func createNewChat() {
        let users = [self.currentUser.id, self.user2UID]
         let data: [String: Any] = [
             "users":users
         ]
         
         let db = Firestore.firestore().collection("rooms")
         db.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                 self.loadChat()
             }
         }
    }
    
    func loadChat() {
        
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("rooms")
                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Room(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(self.user2UID!))! {
                            
                            self.docReference = doc.reference
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {

                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg!)
                                        print("Data: \(msg?.content ?? "No message found")")
                                    }
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    
    private func insertNewMessage(_ message: Message) {
        
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            
        })
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
            func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

                let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.id!, senderName: currentUser.firstname!)
                
                  //messages.append(message)
                  insertNewMessage(message)
                  save(message)
    
                  inputBar.inputTextView.text = ""
                  messagesCollectionView.reloadData()
                  messagesCollectionView.scrollToBottom(animated: true)
            }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return Sender(senderId: self.currentUser.id!, displayName: self.currentUser.firstname ?? "Name not found")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }
    
        private func removeMessageAvatars() {
          guard
            let layout = messagesCollectionView.collectionViewLayout
              as? MessagesCollectionViewFlowLayout
          else {
            return
          }
          layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
          layout.textMessageSizeCalculator.incomingAvatarSize = .zero
          layout.setMessageIncomingAvatarSize(.zero)
          layout.setMessageOutgoingAvatarSize(.zero)
          let incomingLabelAlignment = LabelAlignment(
            textAlignment: .left,
            textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
          layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
          let outgoingLabelAlignment = LabelAlignment(
            textAlignment: .right,
            textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
          layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
        }

//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//
//        if message.sender.senderId == currentUser.id! {
//            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
//        } else {
//            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
//        }
//    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }
    
}

//import UIKit
//import MessageKit
//import InputBarAccessoryView
//import Photos
//import FirebaseFirestore
//import FirebaseAuth
//
//class ChatViewController: MessagesViewController, MessagesDataSource {
//
//    private let user: User
//    let chatFirestoreHelper = ChatFirestoreHelper()
//    let room: Room
//    var messages = [Message]()
//    //private let database = Firestore.firestore()
//    //private var reference: CollectionReference?
//
//    init(user: User, room: Room) {
//            self.user = user
//            self.room = room
//            super.init(nibName: nil, bundle: nil)
//
//            title = room.name
//        }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    deinit {
//        chatFirestoreHelper.removeListener()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
//        title = room.name
//        messageInputBar.delegate = self
//
//        removeMessageAvatars()
//        listenToMessages()
//    }
//
//    private func listenToMessages() {
//      guard let id = room.id else {
//        //navigationController?.popViewController(animated: true)
//        return
//      }
//
//      //reference = database.collection("rooms/\(id)/thread")
//
//        chatFirestoreHelper.subscribe(id: id) { [weak self] result in
//            switch result {
//            case .success(let messages):
//                self?.loadImageAndUpdateCells(messages)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//    private func loadImageAndUpdateCells(_ messages: [Message]) {
//        messages.forEach { message in
//            let message = message
////            if let url = message.downloadURL {
////                FirebaseStorageManager.downloadImage(url: url) { [weak self] image in
////                    guard let image = image else { return }
////                    message.image = image
////                    self?.insertNewMessage(message)
////                }
////            } else {
////                insertNewMessage(message)
////            }
//            insertNewMessage(message)
//        }
//    }
//
//    private func insertNewMessage(_ message: Message) {
//        if messages.contains(message) {
//            return
//          }
//        messages.append(message)
//        messages.sort()
//
////        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
////          let shouldScrollToBottom =
////            messagesCollectionView.isAtBottom && isLatestMessage
//
//          messagesCollectionView.reloadData()
//
////          if shouldScrollToBottom {
////            messagesCollectionView.scrollToLastItem(animated: true)
////          }
//
//    }
//
//    func currentSender() -> SenderType {
//        return Sender(senderId: user.id!, displayName: user.firstname!)
//    }
//
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return messages[indexPath.section]
//    }
//
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return messages.count
//    }
//
//    private func removeMessageAvatars() {
//      guard
//        let layout = messagesCollectionView.collectionViewLayout
//          as? MessagesCollectionViewFlowLayout
//      else {
//        return
//      }
//      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
//      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
//      layout.setMessageIncomingAvatarSize(.zero)
//      layout.setMessageOutgoingAvatarSize(.zero)
//      let incomingLabelAlignment = LabelAlignment(
//        textAlignment: .left,
//        textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
//      layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
//      let outgoingLabelAlignment = LabelAlignment(
//        textAlignment: .right,
//        textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
//      layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
//    }
//}
//
//extension ChatViewController: MessagesLayoutDelegate {
//    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//        return CGSize(width: 0, height: 8)
//    }
//
//    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return 20
//    }
//}
//
//extension ChatViewController: MessagesDisplayDelegate {
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .yellow : .gray
//    }
//
//    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .black : .white
//    }
//
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(cornerDirection, .curved)
//    }
//}
//
//extension ChatViewController: InputBarAccessoryViewDelegate {
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        let message = Message(user: user, content: text)
//
//        chatFirestoreHelper.save(message) { [weak self] error in
//            if let error = error {
//                print(error)
//                return
//            }
//            self?.messagesCollectionView.scrollToLastItem()
//        }
//        inputBar.inputTextView.text.removeAll()
//    }
//}
//
