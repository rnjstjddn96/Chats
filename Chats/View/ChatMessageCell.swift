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
    
    let textView : UITextView = {
        let tv  = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
//        tv.textAlignment = .right
        tv.textColor = UIColor.white
        return tv
    }()
    
    let bubbleView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        
        
        //x,y,height, width 지정
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
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
        
//        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
