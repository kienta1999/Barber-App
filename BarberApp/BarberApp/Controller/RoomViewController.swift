//
//  RoomViewController.swift
//  BarberApp
//
//  Created by 최지원 on 4/20/22.
//

import UIKit
import FirebaseAuth
import Firebase

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    @IBOutlet weak var roomTable: UITableView!
    
    
//    var rooms = [Room]()
//    private let currentUser: User
    var userId: String?
    var roomsData: [[String: Any]] = []
    
    func configurate(userId: String?, roomsData: [[String: Any]]){
        self.userId = userId
        self.roomsData = roomsData
    }
    
    //private let roomHelper = RoomFirestoreHelper()

//    init(currentUser: User) {
//        self.currentUser = currentUser
//        super.init(nibName: nil, bundle: nil)
//
//        title = "Rooms"
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }

//    deinit {
//        roomHelper.removeListener()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        roomTable.register(UITableViewCell.self, forCellReuseIdentifier: "roomCell")
        roomTable.dataSource = self
        roomTable.delegate = self
        roomTable.reloadData()
        //print("line 43")
        //print(Auth.auth().currentUser?.uid ?? "Not found")
        //loadRooms()
//        roomHelper.subscribe { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.updateCell(to: data)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
//    func loadRooms(){
        
        
        
        //Fetch all the chats which has current user in it
//        let db = Firestore.firestore().collection("rooms")
//                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
//
//        db.getDocuments { (chatQuerySnap, error) in
//
//            if let error = error {
//                print("Error: \(error)")
//                return
//            } else {
//
//                var newRooms: [Room] = []
//
//                //Count the no. of documents returned
//                guard let queryCount = chatQuerySnap?.documents.count else {
//                    return
//                }
//
//                if queryCount >= 1 {
//                    //Chat(s) found for currentUser
//                    for doc in chatQuerySnap!.documents {
//                        let room = Room(dictionary: doc.data())
//                        newRooms.append(room!)
//                    }
//                    self.rooms = newRooms
//                    print("rooms!!!!!")
//                    print(self.rooms)
//                    //self.updateTable()
//                    self.roomTable.reloadData()
//                }
//            }
//        }
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.roomsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
        let room = self.roomsData[indexPath.row]
        //let roomUsers = room["id"]
        let roomUsers = room["users"] as! [String]
        let roomUserNames = room["names"] as! [String]
        // print("line 117")
        // print(room)
        let indexOfCurUser = roomUsers.firstIndex(of: Auth.auth().currentUser!.uid)
        let indexOfUser2: Int
        if indexOfCurUser==0 {
            indexOfUser2 = 1
        }
        else {
            indexOfUser2 = 0
        }
        cell.textLabel?.text = roomUserNames[indexOfUser2]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let room = self.roomsData[indexPath.row]
        let roomUsers = room["users"] as! [String]
        let indexOfCurUser = roomUsers.firstIndex(of: Auth.auth().currentUser!.uid)
        let indexOfUser2: Int
        if indexOfCurUser==0 {
            indexOfUser2 = 1
        }
        else {
            indexOfUser2 = 0
        }
        
        var roomUser1: [String: Any] = [:]
        var roomUser2: [String: Any] = [:]
        
        print("checkpoint")
        print(roomUsers[indexOfCurUser!])
        
        //print("line 150")
        //print(roomUser1)
        
        //getCurUser(roomUsers: roomUsers, ind: indexOfCurUser!)
        
        User.getUser(roomUsers[indexOfCurUser!]) { (roomUserData) in
            roomUser1 = roomUserData!
            User.getUser(roomUsers[indexOfUser2]) {(roomAnotherUserData) in
                roomUser2 = roomAnotherUserData!
                
                let curUser = User.init(
                    id: roomUser1["id"] as? String,
                    firstname: roomUser1["firstname"] as? String,
                    lastname: roomUser1["lastname"] as? String,
                    email: roomUser1["email"] as! String,
                    password: roomUser1["password"] as! String,
                    role: roomUser1["role"] as? String,
                    age: roomUser1["age"] as? Int,
                    gender: roomUser1["gender"] as? String,
                    bio: roomUser1["bio"] as? String,
                    profilePicPath: roomUser1["profilePicPath"] as? String,
                    phoneNumber: roomUser1["phoneNumber"] as? Int
                )
                let anotherUser = User.init(
                    id: roomUser2["id"] as? String,
                    firstname: roomUser2["firstname"] as? String,
                    lastname: roomUser2["lastname"] as? String,
                    email: roomUser2["email"] as! String,
                    password: roomUser2["password"] as! String,
                    role: roomUser2["role"] as? String,
                    age: roomUser2["age"] as? Int,
                    gender: roomUser2["gender"] as? String,
                    bio: roomUser2["bio"] as? String,
                    profilePicPath: roomUser2["profilePicPath"] as? String,
                    phoneNumber: roomUser2["phoneNumber"] as? Int
                )
                let chatVC = ChatViewController(user: curUser, user2: anotherUser)
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
            
        }
//        let curUser = User.init(
//            id: roomUser1["id"] as? String,
//            firstname: roomUser1["firstname"] as? String,
//            lastname: roomUser1["lastname"] as? String,
//            email: roomUser1["email"] as! String,
//            password: roomUser1["password"] as! String,
//            role: roomUser1["role"] as? String,
//            age: roomUser1["age"] as? Int,
//            gender: roomUser1["gender"] as? String,
//            bio: roomUser1["bio"] as? String,
//            profilePicPath: roomUser1["profilePicPath"] as? String,
//            phoneNumber: roomUser1["phoneNumber"] as? Int
//        )
//        let anotherUser = User.init(
//            id: roomUser2["id"] as? String,
//            firstname: roomUser2["firstname"] as? String,
//            lastname: roomUser2["lastname"] as? String,
//            email: roomUser2["email"] as! String,
//            password: roomUser2["password"] as! String,
//            role: roomUser2["role"] as? String,
//            age: roomUser2["age"] as? Int,
//            gender: roomUser2["gender"] as? String,
//            bio: roomUser2["bio"] as? String,
//            profilePicPath: roomUser2["profilePicPath"] as? String,
//            phoneNumber: roomUser2["phoneNumber"] as? Int
//        )
//        let viewController = ChatViewController(user: curUser, user2: anotherUser)
//        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
//    func getCurUser(roomUsers: [String], ind: Int){
//        User.getUser(roomUsers[ind]) { (roomUserData) in
//            self.curUser = roomUserData!
//        }
////        let db = Firestore.firestore().collection("users").document(roomUsers[ind])
////
////        db.getDocument{ (snapshot, err) in
////            if let err = err {
////                print("Error: \(err)")
////                return
////            }
////            else {
////                let userData = snapshot!.data()
////                print("omg")
////                print(userData)
////                self.curUser = userData!
////            }
////        }
//    }

}
