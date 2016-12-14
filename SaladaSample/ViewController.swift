//
//  ViewController.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseDatabase
//import FirebaseStorage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UIパーツの配置
    @IBOutlet weak var listTableView: UITableView!
    
    var todoList: [Todolist] = []
    
    override func viewWillAppear(_ animated: Bool) {
        loadTodoData()
    }
    
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
        return self.todoList.count
    }
    
    //Cellに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell
        
        let todo = todoList[indexPath.row] as Todolist
        
        cell?.listTitle.text = todo.title
        cell?.listDetail.text = todo.detail
        cell?.listStatus.text = todo.progress
        
        if Int(todo.photo_count!) == 1 {
            
            todo.image1?.dataWithMaxSize(1 * 2000 * 2000, completion: { (data, error) in
                if let error: Error = error {
                    print(error)
                    return
                }
                cell?.listImageView1?.image = UIImage(data: data!)
            })
                
            cell?.setLayoutConstraintSetting(count: 1)
            
        } else if Int(todo.photo_count!) == 2 {

            todo.image1?.dataWithMaxSize(1 * 2000 * 2000, completion: { (data, error) in
                if let error: Error = error {
                    print(error)
                    return
                }
                cell?.listImageView1?.image = UIImage(data: data!)
            })
            todo.image2?.dataWithMaxSize(1 * 2000 * 2000, completion: { (data, error) in
                if let error: Error = error {
                    print(error)
                    return
                }
                cell?.listImageView2?.image = UIImage(data: data!)
            })
            cell?.setLayoutConstraintSetting(count: 2)

        } else {
            cell?.setLayoutConstraintSetting(count: 0)
        }

        //セルのアクセサリタイプの設定
        cell?.accessoryType = UITableViewCellAccessoryType.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    //セルがタップされた際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let todo = todoList[indexPath.row] as Todolist
        
        //アクションシートの呼び出し
        let alertActionSheet = UIAlertController(
            title: "\(todo.title)のステータスについて",
            message: "選択したToDoリストの項目を変更 or 削除します。よろしいですか？",
            preferredStyle: UIAlertControllerStyle.actionSheet
        )
        
        //UIActionSheetの戻り値をチェック
        alertActionSheet.addAction(
            UIAlertAction(
                title: "ステータスを変更する",
                style: UIAlertActionStyle.default,
                handler: {(action: UIAlertAction!) in
                    
                    let currenTodoProgress = todo.progress
                    if currenTodoProgress == "これから着手" {
                       todo.progress = "完了しました"
                    } else {
                       todo.progress = "これから着手"
                    }
                    todo.save()
                    self.loadTodoData()
                }
            )
        )
        alertActionSheet.addAction(
            UIAlertAction(
                title: "このToDoを削除する",
                style: UIAlertActionStyle.destructive,
                handler: {(action: UIAlertAction!) in
                    todo.remove()
                    self.loadTodoData()
                }
                
            )
        )
        
        alertActionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertActionStyle.cancel,
                handler: nil
            )
        )
        present(alertActionSheet, animated: true, completion: nil)
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
        loadTodoData()
        sender.endRefreshing()
    }
    
    fileprivate func loadTodoData() {
        
        Todolist.observeSingle(.value, block: { todos in
            self.todoList.removeAll()
            todos.forEach({ (todo) in
                self.todoList.append(todo)
            })
            self.todoList.reverse()
            self.listTableView.reloadData()
        })
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

