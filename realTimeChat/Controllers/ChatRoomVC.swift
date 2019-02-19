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

    var room:Rooms?
    @IBOutlet weak var chattextMassage: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMassage(_ sender: Any) {
        guard let message = chattextMassage.text,!message.isEmpty, let userID = Auth.auth().currentUser?.uid else{
            return
        }
        
        let databaseRe = Database.database().reference()
        let username = databaseRe.child("users").child(userID)
        username.child("username").observeSingleEvent(of: .value) { (snapshot) in
            if let userName = snapshot.value as? String{
                let arrayMassage : [String:Any ] = ["username" : userName, "text" : message]
                if let roomId = self.room?.roomId
                {
                    let room = databaseRe.child("rooms").child(roomId)
                    room.child("messages").childByAutoId().setValue(arrayMassage, withCompletionBlock: { (error, snapshot) in
                        if error == nil {
                            self.chattextMassage.text = ""
                            print("database seccess")
                        }
                    })
                }
               
            }else{
                print("no value")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
