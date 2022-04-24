//
//  RoomFirestoreHelper.swift
//  BarberApp
//
//  Created by 최지원 on 4/22/22.
//

//import Foundation
//import FirebaseFirestore
//import FirebaseStorage
//import FirebaseFirestoreSwift
//
//class RoomFirestoreHelper {
//    private let storage = Storage.storage().reference()
//    let firestoreDatabase = Firestore.firestore()
//    var listener: ListenerRegistration?
//    lazy var RoomListener: CollectionReference = {
//        return firestoreDatabase.collection("rooms")
//    }()
//    
//    func createChannel(with roomName: String) {
//        let room = Room(name: roomName)
//        RoomListener.addDocument(data: room.representation) { error in
//            if let error = error {
//                print("Error saving Room: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func subscribe(completion: @escaping (Result<[(Room, DocumentChangeType)], Error>) -> Void) {
//        RoomListener.addSnapshotListener { snaphot, error in
//            guard let snapshot = snaphot else {
//                completion(.failure(error!))
//                return
//            }
//            
//            let result = snapshot.documentChanges
//                .filter { Room($0.document) != nil }
//                .compactMap { (Room($0.document)!, $0.type) }
//            
//            completion(.success(result))
//        }
//    }
//    
//    func removeListener() {
//        listener?.remove()
//    }
//}
