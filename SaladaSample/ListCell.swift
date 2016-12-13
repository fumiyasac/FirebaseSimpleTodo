//
//  ListCell.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var listTitle: UITextView!
    @IBOutlet weak var listDetail: UITextView!
    @IBOutlet weak var listImageView1: UIImageView!
    @IBOutlet weak var listImageView2: UIImageView!
    @IBOutlet weak var listStatus: UILabel!

    //ImageViewの制約
    @IBOutlet weak var listImageView1Height: NSLayoutConstraint!
    @IBOutlet weak var listImageView1Width: NSLayoutConstraint!
    @IBOutlet weak var listImageView2Height: NSLayoutConstraint!
    @IBOutlet weak var listImageView2Width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
