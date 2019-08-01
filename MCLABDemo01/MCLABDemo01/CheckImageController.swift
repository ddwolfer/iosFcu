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
import RSLoadingView

class CheckImageController : UIViewController,ImagePickerDelegate{
    var scoreFlag = 1
    var FinalScoreResult : String!
    //接收相機的照片
    var imageSave : UIImage!
    var getString : String!
    var getImage : UIImage!
    var getFakeScore : String!
    //預覽照片
    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var reButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bar透明
        let alphaBackgroundImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(
            alphaBackgroundImage,for: .default)
        //back圖片
        let backButton = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(backViewCustume))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        
        
        print("test :\(getString)")
        showImage.image = getImage
    }
    //開啟相機
    func CameraTrigger(){
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self as? ImagePickerDelegate
        imagePickerController.imageLimit = 2
        present(imagePickerController, animated: true, completion: nil)
    }
    //重拍一次
    @IBAction func ReTakePhoto(_ sender: Any) {
        self.CameraTrigger()
    }
    //按下確認
    @IBAction func ConfirmPhoto(_ sender: Any) {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.show(on: view)
        //FinalScoreResult = getFakeScore
        //延迟3秒执行
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            //self.GetScoreDone()
        //}
        
        self.UploadImage(self.showImage.image!, filename: "upload.jpg")
    }
    //傳值給下一個Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sendPicController = segue.destination as! UploadImageController
        sendPicController.getImage = showImage.image
        sendPicController.getString = "send success"
        //sendPicController.getScore = "3"
        sendPicController.getScore = FinalScoreResult
    }
    @objc func backViewCustume(){
        self.navigationController?.popViewController(animated: true)
    }
}

//相機用
extension CheckImageController{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper")
        imageSave = images.first
        showImage.image = imageSave
        print(images)
        confirmButton.isHidden = false
        reButton.isHidden = false
        dismiss(animated: true, completion: nil) //收起相機
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

//上傳照片
extension CheckImageController{
    //上傳
    func UploadImage(_ image:UIImage , filename:String){
        //設定儲存位置 哪個storage 哪個資料夾 （這邊是直接放根目錄
        let storageRef = Storage.storage().reference().child(filename)
        //抓圖片資料 && 設定圖片品質
        let imgData = image.jpegData(compressionQuality: 0.1)
        //設定圖片的類型（要跟上面filename的副檔名一樣 不要問我不一樣會怎樣 ）
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        //上傳並產生回饋
        storageRef.putData(imgData!, metadata: metaData){(metaData, error) in
            if error == nil{
                print("upload succes")
                print("flag : \(self.scoreFlag)")
                self.FinalScoreResult = "獲取分數"
                
                self.AfterUpload()
            }else{
                print("error in save image \n error msg:")
                //如果有BUG看一下error是什麼 拿去google會有人po解決辦法
                print(error!)
            }
        }
    }
    //上傳後
    func AfterUpload(){
        //垃圾swift要再寫一個ＦＵＮ才給我跑 操
        self.GetFinalResult()
    }
    //獲取資料表數據
    func GetFinalResult(){
        //設定database位置
        let databaseRef: DatabaseReference!
        databaseRef = Database.database().reference().child("ios2019")
        //獲取資料表
        databaseRef.observeSingleEvent(of: .value, with: {(snapshot) in
            //資料表
            let getData = snapshot.value as? NSDictionary
            //將分數轉成String ＳＴＡＲＴ
            let Score = self.getJSONStringFromDictionary(dictionary: getData!)
            print("Score: \(Score)")
            var ScoreStr : String
            ScoreStr = (Score as? String)!
            print("ScoreStr: \(ScoreStr)")
            ScoreStr = String(ScoreStr.split(separator: ":")[1])
            print("ScoreStr: \(ScoreStr)")
            ScoreStr = String(ScoreStr.split(separator: "}")[0])
            print("ScoreStr: \(ScoreStr)")
            //將分數轉成String ＥＮＤ
            //如果有結果 放進去
            if(ScoreStr != "-1"){
                self.FinalScoreResult = ScoreStr
                print("success")
                self.ResetDatabaseData() //重置分數
                if(ScoreStr != "0"){
                    self.GetScoreDone()
                }else{
                    self.GetErrorScore()
                }
            }else{ //沒結果重跑
                print("fail again")
                self.GetFinalResult()
            }
        })
    }
    func ResetDatabaseData(){
        //設定database位置
        let databaseRef: DatabaseReference!
        databaseRef = Database.database().reference()
        let updateRef = databaseRef.child("ios2019")
        updateRef.updateChildValues(["ScoreResult" : -1])
    }
    
    //把NSDictionary轉乘string
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> NSString {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString!
    }
    //獲得分數後的動作
    func GetScoreDone(){
        //sleep(3)
        RSLoadingView.hide(from: view)
        performSegue(withIdentifier: "getScore", sender: nil)
    }
    //如果接受到0分
    func GetErrorScore(){
        RSLoadingView.hide(from: view)
        let errorController = UIAlertController(title: "圖片錯誤", message: "畫面需要兩個人才能進行偵測呦, 請更換圖片", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorController.addAction(okAction)
        self.present(errorController, animated: true, completion: nil)
    }
}
