//
//  NewMessageController.swift
//  Chats
//
//  Created by 권성우 on 2020/06/14.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 72
        fetchUser()
    }
    
   
    func fetchUser(){
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
            }
        }, withCancel: nil)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        //CustomCell인 UserCell의 imageview에 프로필 사진을 띄우기 위해 cell(UITableViewCell)을 UserCell로 다운캐스팅
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        
        if let profileImageUrl = user.profileImageUrl{
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
            //테이블뷰가 스크롤 될 때마다 이미를 반복해서 다운받는다.. -> Extensions.swift에서 ImageCache로 이미를 불러오기를 구현하여 적용
//            let url = URL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url!) { (data, reponse, error) in
//                if error != nil {
//                    return
//                }
//                DispatchQueue.main.async(execute: {
//                    cell.profileImageView.image = UIImage(data: data!)
//                })
//            }.resume()
        }
        return cell
    }
    
    var messasgeController = MessageController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let user = users[indexPath.row]
        self.messasgeController.showChatControllerForUser(user: user)
    }
    
}



//Custom Cell 생성
class UserCell : UITableViewCell{
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        //이미지 height, width크기의 절반으로 지정, 원형으로 표시
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
       return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier : reuseIdentifier)
        
        addSubview(profileImageView)
        //프로필 사진의 x,y,width,height의 constraints 지정
        //snapKit 사용
        profileImageView.snp.makeConstraints { (m) in
            m.left.equalTo(self.snp.left).offset(8)
            m.centerY.equalTo(self.snp.centerY)
            m.width.equalTo(48)
            m.height.equalTo(48)
        }
         //Anchor사용
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
