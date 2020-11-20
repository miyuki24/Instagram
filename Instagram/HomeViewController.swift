//
//  HomeViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/10.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
//FireStoreへアクセスできるようにする
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    //投稿データを表示するために格納する配列
    var postArray: [PostData] = []
    
    //データ更新の監視をするためのリスナー
    var listener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        //ファイルを読み込む
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        //カスタムセルをCellというIdentifierで登録する
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    //投稿データを読み込む処理・画面が表示されるたびに呼ばれるため複数リスナー登録しないようにする
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBAG_PRINT: ViewWillAppear")
        
        if Auth.auth().currentUser != nil {
            //ログイン済み
            if listener == nil {
                //postsフォルダに格納されているドキュメントを新しい順に取得
                let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
                //postsRefのドキュメントをaddSnapshotListenerメソッドで監視
                //クロージャのquerySnapshotに最新のデータが送られる
                listener = postsRef.addSnapshotListener() {(querySnapshot, error)in
                    if let error = error{
                        print("DEBAG_PRINT: snapshotの取得が失敗しました")
                        return
                    }
                    //
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBAG_PRINT: document取得\(document.documentID)")
                        let postData = PostData(document: document)
                        return postData
                    }
                    self.tableView.reloadData()
                }
            }
        } else {
            //未ログイン
            if listener != nil{
                //データの監視を停止
                listener.remove()
                listener = nil
                postArray = []
                //表示データをクリア
                tableView.reloadData()
            }
        }
    }
    
    //要素数を返す必須メソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    //セルを表示する必須メソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        //対応するデータをセルへ表示
        cell.setPostData(postArray[indexPath.row])

        return cell
    }
}
