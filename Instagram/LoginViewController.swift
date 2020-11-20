//
//  LoginViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/13.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//
import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //ログインボタンを押した時
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            //アドレスとパスワードのどっちも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            //HUDの表示を開始・処理中を表す
            SVProgressHUD.show()
            
            //ログインする
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                //エラーが起きた時
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    //エラーを伝えるHUDを表示する
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                //HUDの表示を終了
                SVProgressHUD.dismiss()
                
                //画面を閉じてタブ画面に切り替える
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //アカウント作成ボタンを押した時
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            
            //何かが空文字の場合（isEmptyで文字が入力されているか判断）
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                //エラーを伝えるHUDを表示する
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                //メソッドを抜ける
                return
            }
            
            //HUDの表示を開始・処理中を表す
            SVProgressHUD.show()
            
            //createUserメソッドを使ってユーザー作成
            //completionではクロージャを指定（クロージャ：処理の塊を変数や引数にしておく物）
            //createUserメソッドの呼び出しはすぐに戻って来る。アカウント作成完了の通知がサーバーから届いた時クロージャが呼ばれる
            //クロージャのauthResultに認証結果情報・errorにエラー発生時のエラー情報
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    //returnして以降の処理を実行せずに終了
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
                //ユーザーの表示名を設定・ProfileChangeRequestクラスはユーザー情報の更新に使う
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        //エラーが起きた時
                        if let error = error {
                            //localizedDescriptionは値を取り出す時に使う
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            //エラーを伝えるHUDを表示する
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        //HUDの表示を終了
                        SVProgressHUD.dismiss()
                        
                        //LoginViewControllerを閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
