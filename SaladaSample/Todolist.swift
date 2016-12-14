//
//  Todolist.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import Foundation

class Todolist: Ingredient {
    typealias Tsp = Todolist
    dynamic var title: String?
    dynamic var detail: String?
    dynamic var progress: String?
    dynamic var photo_count: String?
    dynamic var image1: File?
    dynamic var image2: File?
}
