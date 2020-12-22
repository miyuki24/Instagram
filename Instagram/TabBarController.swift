//
//  TabBarController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/13.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //アイコン
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //TabBarControllerDelegateメソッドをこのクラスで処理する
        self.delegate = self
    }
    
    //遷移後すぐ呼ばれる
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //AuthクラスのcurrentUserがnilならログインしてない
        if Auth.auth().currentUser == nil {
            //loginViewControllerを読み込む
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            //モーダル遷移
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    
    //shouldSelectはタブ切り替えしていいかどうかを応答する
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //切り替え先の画面がImageSelectViewController(カメラボタン)の時
        if viewController is ImageSelectViewController {
            //imageSelectViewControllerを読み込む
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            //モーダル遷移する(下から)
            present(imageSelectViewController, animated: true)
            //タブ切り替えさせない
            return false
        } else {
            //通常のタブ切り替えを実施
            return true
        }
    }

}
