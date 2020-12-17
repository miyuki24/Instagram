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
    
    var commentArry: [PostData] = []
    
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
                    //querySnapshotのdocumentsプロパティをPostDataに変換してpostArrayに格納する
                    //mapメソッドは配列の要素を変換して新しい配列を作成するメソッド
                    self.postArray = querySnapshot!.documents.map { document in
                        print("DEBAG_PRINT: document取得\(document.documentID)")
                        let postData = PostData(document: document)
                        //引数documentで変換元の配列要素を受け取り返却する。これで配列を変換できる
                        return postData
                    }
                    //再読み込み
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

        //セル内のボタンだからメソッド内で設定する・addTargetメソッドが青い線を引っ張る設定法の代わり
        //#selectorで指定したメソッドが呼び出されるメソッド
        //第一引数にはUIButtonのインスタンス・第二引数にはタップイベントが格納される
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        //コメントアクション
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
 
    }
    
    //selector指定で呼び出されるメソッドは@objcがつく
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        //タッチ情報を取り出す
        let touch = event.allTouches?.first
        //TableView内のタッチした座標を割り出す
        let point = touch!.location(in: self.tableView)
        //タッチした座標がtableView内のどのindexPath位置なのか取得する
        let indexPath = tableView.indexPathForRow(at: point)
        
        //タップしたセルの投稿データを取得する
        let postData = postArray[indexPath!.row]
        
        if let myid = Auth.auth().currentUser?.uid {
            var updateValue: FieldValue
            //すでにいいねボタンが押されている時
            if postData.isLiked {
                //myidを取り除く
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //myidを追加する
                updateValue = FieldValue.arrayUnion([myid])
            }
            //投稿データの保存場所を定義
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            //更新する
            postRef.updateData(["likes": updateValue])
        }
    }
    
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBAG_PRINT: commentボタンがタップされました。")
        
        //タップしたセル
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //投稿データ
        let postData = postArray[indexPath!.row]
        
        //コメント入力画面に遷移
        self.performSegue(withIdentifier: "toComment", sender: self)
    }
    //データを送る
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let commentViewController: CommentViewController = segue.destination as! CommentViewController
    }
    
}
