//
//  ChatRoomVC.swift
//  realTimeChat
//
//  Created by youssef on 2/19/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomVC: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    var room:Rooms?
    var chatMessages = [Messages]()
    @IBOutlet weak var chattextMassage: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        chatTableView.separatorStyle = .none
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.allowsSelection = false
        observeSendMessage()
        
        title = room?.roomName
    }
    
    func observeSendMessage() {
        guard let roomId = room?.roomId else{
            return
        }
        let databaseRf = Database.database().reference()
        databaseRf.child("rooms").child(roomId).child("messages").observe(.childAdded) { (snapchat) in
            if let arrayData = snapchat.value as? [String : Any]{
                guard let sendermessage = arrayData["username"] as? String, let textMessage = arrayData["text"] as? String, let useId = arrayData["senderId"]as? String  else {
                    return
                }
                
                let message = Messages.init(messageKey: snapchat.key, username: sendermessage, textMessage: textMessage, userId: useId)
                self.chatMessages.append(message)
                self.chatTableView.reloadData()
            }
        }
    }
    
    func getUserNameById(id: String,complation : @escaping (_ usreName:String?)->Void){
        let databaseRe = Database.database().reference()
        let username = databaseRe.child("users").child(id)
        username.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String{
                
                complation(userName)
            }else{
                complation(nil)
            }
        }
            
    }
    
    func messageTosend(text : String, complation : @escaping (_ isSeccuss : Bool)->Void){
        
        guard let userID = Auth.auth().currentUser?.uid else{
            return
        }
         let databaseRe = Database.database().reference()
        getUserNameById(id: userID) { (userNameText) in
            if let userName = userNameText, let userid = Auth.auth().currentUser?.uid {
                let arrayMassage : [String:Any ] = ["username" : userName, "text" : text,"senderId" : userid]
                if let roomId = self.room?.roomId
                {
                    let room = databaseRe.child("rooms").child(roomId)
                    room.child("messages").childByAutoId().setValue(arrayMassage, withCompletionBlock: { (error, snapshot) in
                        if error == nil {
                            complation(true)
                            self.chattextMassage.text = ""
                            print("database seccess")
                        }
                    })
                }
                
            }else{
                complation(false)
                print("no value")
            }
        }

    }
    
    @IBAction func sendMassage(_ sender: Any) {
        
        guard let message = chattextMassage.text,!message.isEmpty else{
            return
        }
        
        messageTosend(text: message) { (success) in
            if success{
                print("done message")
            }
        }
    }
    
}
extension ChatRoomVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! chatCell
       let message = self.chatMessages[indexPath.row]
        cell.setMassageText(message: message)
        if let uidCurrent = Auth.auth().currentUser?.uid  {
            if(message.userId == uidCurrent){
                cell.setBubbleType(type: .outcoming)
            }else{
                cell.setBubbleType(type: .incoming)
            }
        }
        
        return cell
    }
}
extension ChatRoomVC : UITableViewDelegate{
    
}
