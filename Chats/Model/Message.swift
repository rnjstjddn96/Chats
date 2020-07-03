//
//  Message.swift
//  Chats
//
//  Created by 권성우 on 2020/06/29.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId : String?
    var toId : String?
    var text : String?
    var timestamp : NSNumber?
    
    
    //채팅하고 있는 상대의 ID key값 반환 메소드
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
