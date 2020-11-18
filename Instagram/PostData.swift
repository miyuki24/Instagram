//
//  PostData.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/18.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
import Firebase

//クラスの機能を最低限備えたクラス
class PostData: NSObject {
    
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false

    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID

        //data()メソッドで辞書形式のデータを取り出す
        let postDic = document.data()

        //postDic[]で値を取り出す
        self.name = postDic["name"] as? String
        self.caption = postDic["caption"] as? String
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            //likes(いいね)の中にmyidが含まれているか確認：自分がいいねを押しているか
            if self.likes.firstIndex(of: myid) != nil {
                self.isLiked = true
            }
        }
    }
}
