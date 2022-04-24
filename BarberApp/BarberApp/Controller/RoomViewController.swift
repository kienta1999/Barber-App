//
//  RoomViewController.swift
//  BarberApp
//
//  Created by 최지원 on 4/20/22.
//

//import UIKit
//import FirebaseAuth
//import Firebase
//
//class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    
//    @IBOutlet weak var roomTable: UITableView!
//    var rooms = [Room]()
//    private let currentUser: User
//    private let roomHelper = RoomFirestoreHelper()
//    
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
//    
//    deinit {
//        roomHelper.removeListener()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        roomHelper.subscribe { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.updateCell(to: data)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    private func updateCell(to data: [(Room, DocumentChangeType)]) {
//        data.forEach { (room, documentChangeType) in
//            switch documentChangeType {
//            case .added:
//                addRoomToTable(room)
//            case .modified:
//                updateRoomInTable(room)
//            case .removed:
//                removeRoomFromTable(room)
//            }
//        }
//    }
//    
//    private func addRoomToTable(_ room: Room) {
//        guard rooms.contains(where: room) == false else { return }
//        
//        rooms.append(room)
//        rooms.sort()
//        
//        guard let index = rooms.firstIndex(of: room) else { return }
//        roomTable.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//    }
//    
//    private func updateRoomInTable(_ room: Room) {
//        guard let index = rooms.firstIndex(of: room) else { return }
//        rooms[index] = room
//        roomTable.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//    }
//    
//    private func removeRoomFromTable(_ room: Room) {
//        guard let index = rooms.firstIndex(of: room) else { return }
//        rooms.remove(at: index)
//        roomTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return rooms.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath)
//        cell.textLabel?.text = rooms[indexPath.row].name
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let room = rooms[indexPath.row]
//        let viewController = ChatViewController(user: currentUser, room: room)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//    
//}
