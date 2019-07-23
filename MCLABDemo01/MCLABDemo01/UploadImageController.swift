//
//  UploadImageController.swift
//  MCLABDemo01
//
//  Created by mclab on 2019/7/22.
//  Copyright © 2019 mclab.iosTest. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase

class UploadImageController: UIViewController {
    
    
    //接收照片
    var getImage : UIImage!
    var getScore : String!
    var getString : String!
    //展示圖片
    @IBOutlet weak var showImage: UIImageView!
    //愛心
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    //回應文字
    @IBOutlet weak var wordFeedback: UILabel!
    //不同愛心數目的文字
    var resultWord : [String] = [
    "1 heart looks strange",
    "2 heart get closer",
    "3 heart no bad",
    "4 heart good couple",
    "5 heart wonderful!"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //code
        let alphaBackgroundImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(
            alphaBackgroundImage,for: .default)
        //back圖片
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        print(getString as Any)
        HeartCount(Score: getScore)
        showImage.image = getImage
    }
    
    //更改愛心數量
    func HeartCount(Score: String){
        switch Score {
        case "5":
            heart5.image = UIImage(named: "heart5")
            heart4.image = UIImage(named: "heart5")
            heart3.image = UIImage(named: "heart5")
            heart2.image = UIImage(named: "heart5")
            heart1.image = UIImage(named: "heart5")
            wordFeedback.text = resultWord[4]
            break
        case "4":
            heart1.isHidden = true
            wordFeedback.text = resultWord[3]
            break
        case "3":
            heart1.isHidden = true
            heart2.isHidden = true
            wordFeedback.text = resultWord[2]
            break
        case "2":
            heart1.isHidden = true
            heart2.isHidden = true
            heart3.isHidden = true
            wordFeedback.text = resultWord[1]
            break
        case "1":
            heart1.isHidden = true
            heart2.isHidden = true
            heart3.isHidden = true
            heart4.isHidden = true
            wordFeedback.text = resultWord.first
            break
        default:
            print("error : have no Score")
            break
        }
    }
    //重新開始
    @IBAction func RestartBtn(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
