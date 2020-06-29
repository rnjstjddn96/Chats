//
//  LoginController+handler.swift
//  Chats
//
//  Created by 권성우 on 2020/06/15.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import Firebase

extension LoginController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    

    @objc func handleSelectProfileImageView(){
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        picker.allowsEditing = true
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1{
            present(picker, animated:  true , completion:  nil)
        }
    }
    
    @objc func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
            
            if error != nil {
                let alertFail = UIAlertController(title: "Register", message: "Register Failed", preferredStyle: .actionSheet)
                let actionfail = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertFail.addAction(actionfail)
                self.present(alertFail, animated: true, completion:  nil)
                return
            }
            
            guard let uid = res?.user.uid else {
                return
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg. ")
            
            
            //업로드 된 이미지의 크기를 10퍼센트로 줄여 JPEG형태로 저장한다.
            if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1){
//            if let uploadData = self.profileImageView.image?.pngData(){
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    
                    if error != nil, metadata != nil{
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if error != nil{
                            return
                        }
                        if let profileImageUrl = url?.absoluteString{
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                        }
                    }
                    
                }
                
            }
            
        })
        
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String:AnyObject]){
        let ref = Database.database().reference(fromURL: "https://swktest-20083.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print(err)
                return
            }
            let user = User()
            user.name = values["name"] as? String
            user.email = values["email"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String
            self.messageController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            //print(editedImage.size)
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
}
