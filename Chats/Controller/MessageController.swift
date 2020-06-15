//
//  ViewController.swift
//  Chats
//
//  Created by 권성우 on 2020/06/13.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class MessageController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "NMIcon")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        //not logged in
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfUserIsLoggedIn()
    }

    @objc func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else{
                let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : AnyObject]{
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout(){
        
        do{
            try? Auth.auth().signOut()
        }catch{
            print("error")
        }
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: true, completion: nil)
    }
    
    
}

