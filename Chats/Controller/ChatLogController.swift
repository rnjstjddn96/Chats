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

class ChatLogController : UICollectionViewController, UITextFieldDelegate{
    
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
        navigationItem.title = "aaa"
        collectionView.backgroundColor = UIColor.white
        SetupInputContainer()
    }
    
    func SetupInputContainer(){
        
        //하단 input container
        let containerView = UIView()
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
        
        let values = ["text" : inputTextField.text!, "name" : "권성우"] as Dictionary? ?? [ : ]
        childRef.updateChildValues(values)
    }
    
    //return 키 처리를 위한 method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
