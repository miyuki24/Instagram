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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData){
        //ダウンロード中である事を示すグレーのぐるぐる・FirebaseUIをインポートして事で利用可能になるプロパティ
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        //Cloud Storageの画像保存場所を指定してダウンロード＆UIImageViewに表示
        postImageView.sd_setImage(with: imageRef)
        self.captionLabel.text = "\(postData.name!): \(postData.caption!)"
        self.dateLabel.text = ""
        if let date = postData.date{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        if postData.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
