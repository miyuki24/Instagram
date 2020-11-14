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
    }
    
    //キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //受け取った画像をImageViewに設定する
        imageView.image = image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
