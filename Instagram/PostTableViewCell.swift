//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/18.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import UIKit
//画像処理を簡単に実装してくれる
import FirebaseUI

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var displayCommentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //データを送る
    override func prepare(for segue: UIStoryboard, sender: Any?){
        let commentViewController: CommentViewController = segue.destination as! CommentViewController
        var commentText = displayCommentLabel.text = ""
    }
    
    func setPostData(_ postData: PostData){
        //ダウンロード中である事を示すグレーのぐるぐる・FirebaseUIをインポートして事で利用可能になるプロパティ
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //Cloud Storageの画像保存場所を指定してダウンロード＆UIImageViewに表示・二回目以降の表示は素早い
        postImageView.sd_setImage(with: imageRef)
        //キャプションを表示
        self.captionLabel.text = "\(postData.name!): \(postData.caption!)"
        //Dateクラスに入っている日時情報を文字列に変換する
        self.dateLabel.text = ""
        if let date = postData.date{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        self.displayCommentLabel.text = "\(postData.commentUser!): \(postData.comments)"
        //いいね数・postData.likesにいいねを押した人が格納されている
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        //いいねを押すとUIButtonクラスのsetImageメソッドが使われてlike_exist(赤ハート)がセットされる
        if postData.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
