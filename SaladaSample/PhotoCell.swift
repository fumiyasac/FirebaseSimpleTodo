//
//  PhotoCell.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    //UIパーツの配置
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoAlphaView: UIView!
    @IBOutlet weak var photoSelectedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
