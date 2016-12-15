//
//  Todolist.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation

class Todolist: Ingredient {
    
    //typealiasの設定（必須）
    typealias Tsp = Todolist
    
    //登録対象のカラム名と型を定義する
    dynamic var title: String?
    dynamic var detail: String?
    dynamic var progress: String?
    dynamic var photo_count: String?
    dynamic var image1: File?
    dynamic var image2: File?
    dynamic var image3: File?
}
