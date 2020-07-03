//
//  ChatLogController.swift
//  Chats
//
//  Created by 권성우 on 2020/06/29.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ChatLogController : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    let cellId = "cellId"
    var messages = [Message]()
    var user : User?{
        didSet{//property observer(값이 변경된 직후에 호출)
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    //메시지 입력 공간
    lazy var inputTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "메시지를 입력하세요.."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.delegate = self//return 키를 사용하기 위해 delegate UITextField 사용
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        //CollectionViewCell 사용을 위한 등록
        SetupInputContainer()
    }
    
    func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value) { (snapshot) in
                //                print(snapshot)
                
                guard let dictionary = snapshot.value as? [String:AnyObject]else {return}
                let message = Message()
                message.text = dictionary["text"] as? String
                message.fromId = dictionary["fromId"] as? String
                message.toId = dictionary["toId"] as? String
                message.timestamp = dictionary["time"] as? NSNumber
                
                
                //채팅방안의 맴버와 관련된 메시지만 messages 배열에 추가, collectionView의 재로딩
                if message.chatPartnerId() == self.user!.id{
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
            }
        }, withCancel: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //UICollectionView의 셀은 default textLabel이 존재하지 않는다 -> ChatMessageCell 모델을 생성, 등록한다
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 80 )
    }
    
    func SetupInputContainer(){
        
        //하단 input container
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        //snapKit, x,y,height,width constraint 지정
        containerView.snp.makeConstraints { (m) in
            m.left.equalTo(view)
            m.bottom.equalTo(view)
            m.width.equalTo(view)
            m.height.equalTo(50)
        }
        
        //Send 버튼
        let sendBtn = UIButton(type: .system)
        sendBtn.setTitle("Send", for: .normal)
        sendBtn.translatesAutoresizingMaskIntoConstraints = false
        sendBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendBtn)
        
        //Send 버튼, x,y,height,width constraint 지정
        sendBtn.snp.makeConstraints { (m) in
            m.right.equalTo(containerView)
            m.centerY.equalTo(containerView)
            m.width.equalTo(80)
            m.height.equalTo(containerView)
        }
        
        
        
        containerView.addSubview(inputTextField)
        //메시지 입력 공간, x,y,height,width constraint 지정
        inputTextField.snp.makeConstraints { (m) in
            m.left.equalTo(containerView).offset(8)
            m.centerY.equalTo(containerView)
            m.height.equalTo(containerView)
            //m.width.equalTo(100)
            m.right.equalTo(sendBtn.snp.left)
        }
        
        //입력 창 분리 bar
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorView)
        
        //입력 창 분리 bar x,y,height,width constraint 지정
        seperatorView.snp.makeConstraints { (m) in
            m.left.equalTo(containerView)
            m.bottom.equalTo(containerView.snp.top)
            m.width.equalTo(containerView)
            m.height.equalTo(1)
        }
    }
    
    
    @objc func handleSend(){
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        //referencd를 위한 unique키를 생성해 준다 -> 메시지 리스트를 생성할 수 있다
        let toId = user!.id! //Message 수신 측 id
        let fromId = Auth.auth().currentUser!.uid// Message 송신 측 id
        let timeStamp : NSNumber = NSNumber(value: NSDate().timeIntervalSince1970) 
        
        let values = ["text" : inputTextField.text!, "toId" : toId, "fromId" : fromId, "time": timeStamp ] as Dictionary? ?? [ : ]
        //user의 name을 받아 오지 않는 이유 : user가 name을 변경할 시 주고 받은 message들의 처리가 어렵다(비효율적)
        //        childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, nil) in
            if error != nil{
                print(error!)
                return
            }
        }
        
        //메시지DB의 key값과 보낸 사람의 key를 연동하기위한 조치
        let userMessages = Database.database().reference().child("user-messages").child(fromId)
        let messageId = childRef.key!
        userMessages.updateChildValues([messageId : 1])
        
        //메시지DB의 key값과 받는 사람의 key를 연동하기위한 조치
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
        recipientUserMessagesRef.updateChildValues([messageId : 1])
    }
    
    //return 키 처리를 위한 method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
