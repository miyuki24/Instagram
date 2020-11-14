//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/10.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
import CLImageEditor

class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {

    //ライブラリボタン
    @IBAction func handleLibraryButton(_ sender: Any) {
        //isSourceTypeAvailableは利用可能か確かめるメソッド
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            //モーダル遷移
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //カメラボタン
    @IBAction func handleCameraButton(_ sender: Any) {
        //カメラを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    //写真を撮影・選択したときに呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        //撮影・選択された画像があったら
        if info[.originalImage] != nil{
            //info[.originalImage]で画像を得る
            let image = info[.originalImage] as! UIImage
            print("DEBAG_PRINT: image = \(image)")
            //CLImageEditorにimageを渡して、加工画面を起動する
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            //fullScreenでモーダル遷移
            editor.modalPresentationStyle = .fullScreen
            picker.present(editor, animated: true, completion: nil)
        }
    }
    
    //キャンセルしたときに呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        //タブ画面まで戻る・ImagePickerController画面ではなくImageSelectViewControllerを閉じる
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //編集が終わった後に呼ばれる
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //投稿画面を読み込む
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        //投稿画面に画像を渡す
        postViewController.image = image!
        //モーダル遷移
        editor.present(postViewController, animated: true, completion: nil)
    }
    
    //編集がキャンセルされた時に呼ばれる
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        //タブ画面まで戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
