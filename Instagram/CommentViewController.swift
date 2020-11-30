//
//  CommentViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/30.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var CommentTextFiled: UITextField!
    
    @IBAction func CommentAddButton(_ sender: Any) {
        //一つ前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CommentCancelButton(_ sender: Any) {
        //一つ前の画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
}
