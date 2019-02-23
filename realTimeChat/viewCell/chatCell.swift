//
//  chatCell.swift
//  realTimeChat
//
//  Created by youssef on 2/20/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit


enum bubbleType {
    case incoming
    case outcoming
}

class chatCell: UITableViewCell {

   
    @IBOutlet weak var viewTextBubble: UIView!
    @IBOutlet weak var chatsatck: UIStackView!
    @IBOutlet weak var usernamelabel: UILabel!
    
    @IBOutlet weak var chatTxetView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTextBubble.layer.cornerRadius = 6
    }
    
    func setBubbleType(type:bubbleType){
        if (type == .incoming){
            chatsatck.alignment = .leading
            viewTextBubble.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            chatTxetView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else if (type == .outcoming){
            chatsatck.alignment = .trailing
            viewTextBubble.backgroundColor = #colorLiteral(red: 4.883310502e-05, green: 0.2540053934, blue: 0.1458200461, alpha: 1)
            chatTxetView.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    func setMassageText(message : Messages){
        usernamelabel.text = message.username
        chatTxetView.text = message.textMessage
    }
}
