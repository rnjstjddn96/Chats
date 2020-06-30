//
//  UserCell.swift
//  Chats
//
//  Created by 권성우 on 2020/06/29.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import Firebase

//Custom Cell 생성
class UserCell : UITableViewCell{
    
    var message : Message?{
        didSet{
            if let toId = message?.toId{
                let ref = Database.database().reference().child("users").child(toId)
                ref.observeSingleEvent(of: .value) { (snapshot) in
                    if let dictionary = snapshot.value as? [String : AnyObject] {
                        self.textLabel?.text = dictionary["name"] as? String
                        if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                        }
                        
                    }
                }
            }
            
            if let seconds = message?.timestamp?.doubleValue{
                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
                
            }
            
            detailTextLabel?.text = message?.text
        }
    }
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
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier : reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //프로필 사진의 x,y,width,height의 constraints 지정
        //snapKit 사용
        profileImageView.snp.makeConstraints { (m) in
            m.left.equalTo(self.snp.left).offset(8)
            m.centerY.equalTo(self.snp.centerY)
            m.width.equalTo(48)
            m.height.equalTo(48)
        
        //채팅시간의 x,y,width,height의 constraints 지정
        //snapKit 사용
            timeLabel.snp.makeConstraints { (m) in
                m.right.equalTo(self)
                m.top.equalTo(self).offset(13)
                m.width.equalTo(100)
                m.height.equalTo(self.timeLabel)
            }
            
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
