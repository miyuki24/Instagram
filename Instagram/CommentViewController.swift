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
    
    //投稿者のコメント
    @IBOutlet weak var commentLabel: UILabel!
    
    //コメントテキスト
    @IBOutlet weak var CommentTextFiled: UITextField!
    
    //コメント保存ボタン
    @IBAction func CommentAddButton(_ sender: Any) {
        //保存場所
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        if let displaycomment = CommentTextFiled.text{
            //コメント未入力の場合
            if displaycomment.isEmpty{
                SVProgressHUD.showError(withStatus: "コメントを入力してください")
                return
            }
            let name = Auth.auth().currentUser?.displayName
            let commentDic = [
                "commentUser":name!,
                "comments":self.CommentTextFiled.text!
                ] as [String: Any]
            postRef.setData(commentDic)
            SVProgressHUD.showSuccess(withStatus: "コメントしました")
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
