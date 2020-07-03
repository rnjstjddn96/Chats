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
    let textView : UITextView = {
        let tv  = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .right
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        
        //snapKit
        //x,y,height, width 지정
        textView.snp.makeConstraints { (m) in
            m.right.equalTo(self.snp.right)
            m.top.equalTo(self)
            m.width.equalTo(200)
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
