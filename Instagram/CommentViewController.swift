//
//  CommentViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/30.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    var commentData: PostData!
    
    //投稿者のコメント
    @IBOutlet weak var commentLabel: UILabel!
    
    //コメントテキスト
    @IBOutlet weak var CommentTextFiled: UITextField!
    
    //コメント保存ボタン
    @IBAction func CommentAddButton(_ sender: Any) {
        if let displaycomment = CommentTextFiled.text{
            //コメント未入力の場合
            if displaycomment.isEmpty{
                SVProgressHUD.showError(withStatus: "コメントを入力してください")
                return
            }
            //ユーザー情報(名前)
            let commentUser = Auth.auth().currentUser?.displayName
            //更新データを作成
            var updateValue: FieldValue
            //保存場所
            let postRef = Firestore.firestore().collection(Const.PostPath).document(commentData.id)
            updateValue = FieldValue.arrayUnion([commentUser! + ":" + displaycomment])
            postRef.updateData(["comments": updateValue])
            SVProgressHUD.showSuccess(withStatus: "コメントしました")
            //画面遷移
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //コメントキャンセルボタン
    @IBAction func CommentCancelButton(_ sender: Any) {
        //一つ前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    //コメントをラベルに表示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let commentUser = Auth.auth().currentUser
        let comment = Auth.auth().currentUser
        if let commentUser = commentUser{
            if let comment = comment{
                commentLabel.text = "\(commentUser): \(comment)"
            }
        }
    }
}

//投稿者のコメント引き継ぎ：クリア？
//ラベルにコメントを表示：コメントがない場合、「コメントはまだありません」と表記したい
//ホームラインに戻ったら更新し直す
