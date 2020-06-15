//
//  Extensions.swift
//  Chats
//
//  Created by 권성우 on 2020/06/16.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    //테이블뷰가 스크롤 될 때마다 이미를 반복해서 다운받는다.. -> Extensions.swift에서 ImageCache로 이미를 불러오기를 구현하여 적용
    func loadImageUsingCacheWithUrlString(urlString : String){
        
        //기존의 이미지를 재사용, 즉 이미지가 flash하며 바뀌는 현상을 막기 위해 초기 이미지를 nil값으로 지정
        self.image = nil
        
        //image cache를 먼저 확인한다.
        if let cacheImage = imageCache.object(forKey: urlString as NSString) as? UIImage{
            self.image = cacheImage
        }
        
        //새로운 다운로드 실행
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, reponse, error) in
            //error 발생 시 리턴
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
        }.resume()
    }
}

