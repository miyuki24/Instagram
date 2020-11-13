//
//  SettingViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/10.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //表示名を変更ボタン
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text{
            
            //表示名が入力されていない場合何もしない
            if displayName.isEmpty{
                //エラーを伝えるHUDを表示する
                SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                return
            }
            
            //ユーザー情報を得る
            let user = Auth.auth().currentUser
            //ユーザーの表示名を設定
            if let user = user{
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges{ error in
                    //エラーが起きた時
                    if let error = error{
                        //エラーを伝えるHUDを表示する
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました")
                        //localizedDescriptionは値を取り出す時に使う
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    //成功した時
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    
    //ログアウトボタン
    @IBAction func handleLogoutButton(_ sender: Any) {
        //ログアウトする・signOutメソッドを呼び出す
        try! Auth.auth().signOut()

        //ログイン画面を読み込む
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        //モーダル遷移
        self.present(loginViewController!, animated: true, completion: nil)

        // tabBarController の selectedIndexに0を設定しておく・一番左のホーム画面に切り替えておく
        tabBarController?.selectedIndex = 0
    }
    
    //Viewが表示される直前に更新
    //一旦ログアウトして別アカウントにログインする場合もある。viewDidLoad(ずっと存在する)ではなくviewWillAppear(毎度更新)にする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
