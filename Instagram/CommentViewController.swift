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
        
        if let displaycomment = CommentTextFiled.text{
            //コメント未入力の場合
            if displaycomment.isEmpty{
                SVProgressHUD.showError(withStatus: "コメントを入力してください")
                return
            }
            let comment = Auth.auth().currentUser
            if let comment = comment{
                let addcomment = comment
            }
        }
        //一つ前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    //コメントキャンセルボタン
    @IBAction func CommentCancelButton(_ sender: Any) {
        //一つ前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let maincomment = Auth.auth().currentUser
        if let maincomment = maincomment {
            commentLabel.text = maincomment.Comment
        }
    }
}

//投稿者のコメント引き継ぎ
//コメントを得る
//コメントを保存する
//コメントを表示する
//ラベルにコメントを表示
