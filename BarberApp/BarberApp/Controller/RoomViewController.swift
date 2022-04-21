//
//  RoomViewController.swift
//  BarberApp
//
//  Created by 최지원 on 4/20/22.
//

import UIKit

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var roomTable: UITableView!
    var rooms = [Room]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) 
        cell.textLabel?.text = rooms[indexPath.row].name
        return cell
    }
    
}
