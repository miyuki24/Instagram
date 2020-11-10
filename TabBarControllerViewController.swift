//
//  TabBarControllerViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/10.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit

class TabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //UITabBarControllerDelegateはここで処理をする
        self.delegate = self
    }
    
    //タブバーアイコンがタップされたときに呼ばれるdelegateメソッド処理
    //shouldSelectはタブ切り替えをしていいか否か応答するメソッド
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //切り替え先の画面がImageSelectViewController（カメラボタン）かどうか判断する
        //ImageSelectViewControllerだけ特殊な遷移
        if viewController is ImageSelectViewController {
            //storyboardに定義されているImageSelectViewControllerを読み込む
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            //モーダル画面遷移(下から出るやつ)
            present(imageSelectViewController, animated: true)
            //タブ切り替えさせない
            return false
            
        //ImageSelectViewController以外の切り替え先
        } else {
            //通常のタブ切り替え
            return true
        }
    }
}
