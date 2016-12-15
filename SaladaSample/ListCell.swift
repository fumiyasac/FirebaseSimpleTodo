//
//  ListCell.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

struct DeviceSize {
    
    //デバイスの画面の横サイズを取得
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
}

class ListCell: UITableViewCell {

    //UIパーツの配置
    @IBOutlet weak var listTitle: UITextView!
    @IBOutlet weak var listStatus: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
