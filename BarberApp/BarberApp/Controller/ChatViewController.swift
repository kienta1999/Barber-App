//
//  ChatViewController.swift
//  BarberApp
//
//  Created by 최지원 on 4/18/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Photos
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: MessagesViewController, MessagesDataSource {
    
    private let user: User
    let chatFirestoreHelper = ChatFirestoreHelper()
    let room: Room
    var messages = [Message]()
    //private let database = Firestore.firestore()
    //private var reference: CollectionReference?
    
    init(user: User, room: Room) {
            self.user = user
            self.room = room
            super.init(nibName: nil, bundle: nil)
            
            title = room.name
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        chatFirestoreHelper.removeListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        title = room.name
        messageInputBar.delegate = self
        
        removeMessageAvatars()
        listenToMessages()
    }
    
    private func listenToMessages() {
      guard let id = room.id else {
        //navigationController?.popViewController(animated: true)
        return
      }

      //reference = database.collection("rooms/\(id)/thread")
        
        chatFirestoreHelper.subscribe(id: id) { [weak self] result in
            switch result {
            case .success(let messages):
                self?.loadImageAndUpdateCells(messages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadImageAndUpdateCells(_ messages: [Message]) {
        messages.forEach { message in
            let message = message
//            if let url = message.downloadURL {
//                FirebaseStorageManager.downloadImage(url: url) { [weak self] image in
//                    guard let image = image else { return }
//                    message.image = image
//                    self?.insertNewMessage(message)
//                }
//            } else {
//                insertNewMessage(message)
//            }
            insertNewMessage(message)
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        if messages.contains(message) {
            return
          }
        messages.append(message)
        messages.sort()
        
//        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
//          let shouldScrollToBottom =
//            messagesCollectionView.isAtBottom && isLatestMessage

          messagesCollectionView.reloadData()

//          if shouldScrollToBottom {
//            messagesCollectionView.scrollToLastItem(animated: true)
//          }
        
    }
    
    func currentSender() -> SenderType {
        return Sender(senderId: user.id!, displayName: UserDefaultManager.displayName)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
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
}

extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .yellow : .gray
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .black : .white
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let cornerDirection: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(cornerDirection, .curved)
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: user, content: text)
        
        chatFirestoreHelper.save(message) { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            self?.messagesCollectionView.scrollToLastItem()
        }
        inputBar.inputTextView.text.removeAll()
    }
}

