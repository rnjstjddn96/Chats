//
//  ChatMessageCell.swift
//  Chats
//
//  Created by 권성우 on 2020/07/03.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import SnapKit

class ChatMessageCell: UICollectionViewCell {
    
    var bubbleViewWidthAnchor : NSLayoutConstraint?
    var bubbleViewRight : NSLayoutConstraint?
    var bubbleViewLeft : NSLayoutConstraint?
    
    let textView : UITextView = {
        let tv  = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
//        tv.textAlignment = .right
        tv.textColor = UIColor.white
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubbleView : UIView = {
       let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView : UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "NMIcon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        
        //x,y,height, width 지정
        bubbleViewRight = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRight?.isActive = true
        
        bubbleViewLeft = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:  8)
//        bubbleViewLeft?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //snapKit
        //x,y,height, width 지정
        textView.snp.makeConstraints { (m) in
            m.left.equalTo(bubbleView.snp.left).offset(8)
            m.top.equalTo(self)
            m.right.equalTo(bubbleView)
            m.height.equalTo(self)
        }
        
        //snapKit
        //x,y,height, width 지정
        profileImageView.snp.makeConstraints { (m) in
            m.left.equalTo(self).offset(8)
            m.bottom.equalTo(self)
            m.width.equalTo(32)
            m.height.equalTo(32)
        }
        
        
//        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
