//
//  AddProductCategoryViewController.swift
//  AdminAddProducts
//
//  Created by 胡嘉诚 on 2021/4/18.
//

import UIKit
import Firebase

class AddProductCategoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImgAction(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .photoLibrary
            
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            
            print("Camera is not available")
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let pickedImage = info[.originalImage] as? UIImage
            
        imgView.image = pickedImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadAction(_ sender: UIButton) {
        
        let name = txtName.text
        
        if name == "" {
            return
        }
        
        let data = imgView.image?.jpegData(compressionQuality: 1.0)
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let categoryRef = storageRef.child("categories/" + name! + ".jpg")
        categoryRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            categoryRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
                print(downloadURL)
            }
        
        }
    
    }
    
}
