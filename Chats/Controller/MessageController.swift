//
//  ViewController.swift
//  Chats
//
//  Created by 권성우 on 2020/06/13.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class MessageController: UITableViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "NMIcon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        
        //not logged in
        checkIfUserIsLoggedIn()
        
        
        observeMessage()
    }
    
    var messages = [Message]()
    
    //Firebase DB로 부터 메시지 데이터를 불러온다.
    func observeMessage(){
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let message = Message()
                message.fromId = dictionary["fromId"] as? String
                message.toId = dictionary["toId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["time"] as? NSNumber
                self.messages.append(message)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.toId
        cell.detailTextLabel?.text = message.text
        return cell
    }
    
    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        newMessageController.messasgeController = self
        //NewMessageController에서 특정 Cell 클릭시 ChatLogController를 불러오기 위한 조치
        
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    //Log-in/register 시 NavBar 상단에 username 출력 + profileImage 출력
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = Auth.auth().currentUser?.uid else{
            //uid가 nil값을 가질 경우
            return
        }
        //Firebase DB로부터 userData를 불러온다.
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject]{
                //self.navigationItem.title = dictionary["name"] as? String
                let user = User()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    //navBar에 Container추가, 정보출력(image, name)
    //nameLabel, profileImageView in containerView in titleView
    func setupNavBarWithUser(user : User){
        //self.navigationItem.title = user.name
        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        containerView.snp.makeConstraints { (m) in
            m.center.equalTo(titleView)
        }
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl{
            profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        
        //snapKit
        profileImageView.snp.makeConstraints { (m) in
            m.left.equalTo(containerView.snp.left)
            m.centerY.equalTo(containerView)
            m.height.equalTo(40)
            m.width.equalTo(40 )
        }
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //snapKit
        nameLabel.snp.makeConstraints { (m) in
            m.left.equalTo(profileImageView.snp.right).offset(8)
            m.centerY.equalTo(profileImageView.snp.centerY)
            m.right.equalTo(containerView.snp.right)
            m.height.equalTo(profileImageView.snp.height)
        }
        self.navigationItem.titleView = titleView
        
        // titleView.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        //ChatLogController를 불러온다.
    }
    
    func showChatControllerForUser(user : User){
        let chatLogController = ChatLogController(collectionViewLayout : UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc func handleLogout(){
        
        do{
            try Auth.auth().signOut()
        }catch let logoutError{
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messageController = self
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }
    
    
}

