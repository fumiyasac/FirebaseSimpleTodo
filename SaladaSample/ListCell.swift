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
        
        //TEST: constraintsの張り方が正しいか
        setLayoutConstraintSetting(count: 2)
    }

    func setLayoutConstraintSetting(count: Int) {

        if count == 1 {
            
            let mainRectWidth: CGFloat = CGFloat(DeviceSize.screenWidth() - 30)
            let mainRectHeight: CGFloat = 160

            listImageView1Width.constant = mainRectWidth
            listImageView1Height.constant = mainRectHeight
            listImageView1Width.priority = 750
            
            listImageView2Width.constant = 0
            listImageView2Height.constant = mainRectHeight
            listImageView2Width.priority = 750
            
            self.layoutIfNeeded()

        } else if count == 2 {
            
            let mainRectWidth: CGFloat = CGFloat(DeviceSize.screenWidth() - 30) / 2
            let mainRectHeight: CGFloat = 160
            
            listImageView1Width.constant = mainRectWidth
            listImageView1Height.constant = mainRectHeight
            listImageView1Width.priority = 750
            
            listImageView2Width.constant = mainRectWidth
            listImageView2Height.constant = mainRectHeight
            listImageView2Width.priority = 750

            self.layoutIfNeeded()
            
        } else {

            listImageView1Width.constant = CGFloat(DeviceSize.screenWidth() - 16)
            listImageView1Height.constant = 0
            
            listImageView2Width.constant = 0
            listImageView2Height.constant = 0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
