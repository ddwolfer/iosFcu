//
//  CheckImageController.swift
//  MCLABDemo01
//
//  Created by mclab on 2019/7/22.
//  Copyright © 2019 mclab.iosTest. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker
import FirebaseStorage
import Firebase

class CheckImageController : UIViewController,ImagePickerDelegate{
    //接收相機的照片
    var imageSave : UIImage!
    var getString : String!
    var getImage : UIImage!
    //預覽照片
    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var reButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //code
        //confirmButton.isHidden = true
        //reButton.isHidden = true
        
        let alphaBackgroundImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(
            alphaBackgroundImage,for: .default)
        print("test :\(getString)")
        showImage.image = getImage
    }
    //開啟相機
    func CameraTrigger(){
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self as? ImagePickerDelegate
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func ReTakePhoto(_ sender: Any) {
        self.CameraTrigger()
    }
    
    @IBAction func ConfirmPhoto(_ sender: Any) {
    }
    
    //傳值
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendPicController = segue.destination as! UploadImageController
        sendPicController.getImage = showImage.image
        sendPicController.getString = "send success"
    }
}

extension CheckImageController{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imageSave = images.first
        showImage.image = imageSave
        print(images)
        confirmButton.isHidden = false
        reButton.isHidden = false
        dismiss(animated: true, completion: nil) //收起相機
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil) //收起相機
        if showImage.image == nil{
            print("no image")
        }
    }
}
