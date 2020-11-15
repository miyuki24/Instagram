//
//  PostViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/10.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    //投稿ボタン
    @IBAction func handlePostButton(_ sender: Any) {
        //jpegDataメソッドでJPEG形式の画像データに変換する・compressionQualityは圧縮率
        let imageData = image.jpegData(compressionQuality: 0.75)
        //投稿データの保存場所・Constで定義したPostPathを引数に指定する・Firestoreに保存する
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        //画像の保存場所・Storageに保存する・投稿データのdocumentIDを画像のファイル名に利用
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        //投稿処理中の表示
        SVProgressHUD.show()
        //ファイル形式・image/jpegを指定
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            //画像のアップロードが完了すると呼ばれる・失敗した時
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                //投稿処理をキャンセルして一気に先頭画面に戻る
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            //FireStoreに投稿者名・キャプション・投稿日時を保存する
            let name = Auth.auth().currentUser?.displayName
            //保存するデータは辞書の形でまとめる
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                //FireStoreのサーバー上の時計を使う
                "date": FieldValue.serverTimestamp(),
                ] as [String : Any]
            //setDataメソッドを使う
            postRef.setData(postDic)
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        //一つ前の画面(加工画面)に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //受け取った画像をImageViewに設定する
        imageView.image = image
    }
}
