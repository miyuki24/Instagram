//
//  Const.swift
//  Instagram
//
//  Created by 田中美幸 on 2020/11/14.
//  Copyright © 2020 miyuki.tanaka2. All rights reserved.
//

import Foundation

//アプリ全体で使う定数を一つのファイルにまとめる
struct Const {
    //staticを使うことで構造体を生成する必要がない・Storage内の画像ファイルの保存場所
    static let ImagePath = "images"
    //Firestore内の投稿データの保存場所
    static let PostPath = "posts"
}
