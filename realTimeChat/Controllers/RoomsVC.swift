//
//  RoomsVC.swift
//  realTimeChat
//
//  Created by youssef on 2/19/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import Firebase

class RoomsVC: UIViewController {

    var rooms = [Rooms]()
    @IBOutlet weak var newRoomTxt: UITextField!
    @IBOutlet weak var RoomTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        RoomTableView.dataSource = self
        RoomTableView.delegate = self
        observeRooms()
        
    }
    
    func observeRooms(){
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (DataSnapshot) in
            if let dataRooms = DataSnapshot.value as? [String : Any]{
                if let roomName = dataRooms["roomName"] as? String{
                    let room = Rooms.init(roomName: roomName, roomId: DataSnapshot.key)
                    self.rooms.append(room)
                    self.RoomTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser == nil){
            self.presentLoginScreen()
        }
    }

    
    @IBAction func createRoomAction(_ sender: Any) {
        
        guard let roomName = self.newRoomTxt.text, !roomName.isEmpty else {
            return
        }
        
        let dataBaseRe = Database.database().reference()
        let room = dataBaseRe.child("rooms").childByAutoId()
        let arrayRoom :[String: Any] = ["roomName" : roomName]
        room.setValue(arrayRoom) { (erorr, def) in
            if erorr == nil{
                self.newRoomTxt.text = ""
            }
        }
    }
    
    
    
    @IBAction func didPressLogOut(_ sender: UIBarButtonItem) {
        do{
            try! Auth.auth().signOut()
        }
        self.presentLoginScreen()
        
    }
    
    func presentLoginScreen(){
        let formScreen = self.storyboard?.instantiateViewController(withIdentifier: "formScreen") as! ViewController
        self.present(formScreen, animated: true, completion: nil)
    }
    
}

extension RoomsVC : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        cell.textLabel?.text = rooms[indexPath.row].roomName
        return cell
    }
}

extension RoomsVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRoom = self.rooms[indexPath.row]
        let chatRoom = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomVC
        chatRoom.room = selectedRoom
        self.navigationController?.pushViewController(chatRoom, animated: true)
        
    }
}
