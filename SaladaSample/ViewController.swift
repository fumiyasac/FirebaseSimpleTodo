//
//  ViewController.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UIパーツの配置
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //テーブルビューのデリゲート設定
        listTableView.delegate = self
        listTableView.dataSource = self
        
        //セルの高さの予測値を設定する（高さが可変になる場合のセルが存在する場合）
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 10000
        
        //リストのセルを定義する
        let nibList: UINib = UINib(nibName: "ListCell", bundle: nil)
        listTableView.register(nibList, forCellReuseIdentifier: "ListCell")

        //リフレッシュコントロールの設定を行う
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refresh(sender:)), for: UIControlEvents.valueChanged)
        listTableView.addSubview(refreshControl)
    }

    /* (UITableViewDataSource) */
    
    //Cellの総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //FIXME: 後で直す
        return 10
    }
    
    //Cellに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell
        
        //セルのアクセサリタイプの設定
        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    //リフレッシュコントロールのイベント発火時に呼ばれる
    func refresh(sender: UIRefreshControl) {
        
        /**
         * （参考）iOS10.x〜このようにリフレッシュコントロールの記載が可能になった
         * 参考リンク：
         * http://dev.classmethod.jp/smartphone/ios-10-support-refresh-control-in-all-scroll-views/
         *
         * 以下引用：
         * 1. ここに通信処理などデータフェッチの処理を書く
         * 2. データフェッチが終わったらUIRefreshControl.endRefreshing()を呼ぶ必要がある
         * 3. 処理の最後にsender.endRefreshing()
         */
        sender.endRefreshing()
    }
    
    //Firebaseにデータを入力するフォームのアクション
    @IBAction func dataFormAction(_ sender: UIButton) {
        
        //遷移先のインスタンスを作成してコードで遷移を行う
        let toVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormController") as! FormController
        self.present(toVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

