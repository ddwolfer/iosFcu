//
//  ViewController.swift
//  MCLABDemo01
//
//  Created by mclab on 2019/7/20.
//  Copyright © 2019 mclab.iosTest. All rights reserved.
//

import UIKit
import AVFoundation
import ImagePicker

class ViewController: UIViewController, ImagePickerDelegate{
    
    var imageSave : UIImage!
    
    @IBOutlet weak var mainTopBar: UINavigationItem!
    @IBOutlet weak var mainBackground: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //設定背景透明度
        mainBackground.alpha = 0.75
        //top bar設定
        //navigationController?.navigationBar.barTintColor = UIColor(red: 118/255, green: 184/255, blue: 188/255, alpha: 0.01)
        let alphaBackgroundImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(
            alphaBackgroundImage,for: .default)
    }
    
    //開始拍照or選照片
    @IBAction func startButton(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self as? ImagePickerDelegate
        imagePickerController.imageLimit = 1
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension ViewController{
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        imageSave = images as? UIImage
        dismiss(animated: true, completion: nil) //收起相機
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        dismiss(animated: true, completion: nil) //收起相機
    }
}
