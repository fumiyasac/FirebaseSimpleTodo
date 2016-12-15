//
//  ViewController.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //UIパーツの配置
    @IBOutlet weak var listTableView: UITableView!
    
    //Salada経由で取得したデータを格納する配列
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
        
        //Firebaseに登録されているデータを取得する
        let todo = todoList[indexPath.row] as Todolist
        
        //データをセルに書く
        cell?.listTitle.text = todo.title
        cell?.listStatus.text = todo.progress

        //セルのアクセサリタイプの設定
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    //セルがタップされた際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Firebaseに登録されているデータを取得する
        let todo = todoList[indexPath.row] as Todolist
        
        //アクションシートの呼び出し
        let alertActionSheet = UIAlertController(
            title: "ToDo名：「\(todo.title!)」について",
            message: "選択した項目の詳細を見る or 削除(完了)します。\nよろしいですか？",
            preferredStyle: UIAlertControllerStyle.actionSheet
        )

        //詳細と画像を表示するページへ遷移する
        alertActionSheet.addAction(
            UIAlertAction(
                title: "詳細と画像を見る",
                style: UIAlertActionStyle.default,
                handler: { (action: UIAlertAction!) in
                    
                    //遷移元から画像表示用のViewControllerのインスタンスを作成する
                    let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoController") as! PhotoController
                    
                    photoVC.modalPresentationStyle = .overCurrentContext
                    photoVC.view.backgroundColor = UIColor.clear
                    photoVC.targetTodoList = todo
                    
                    self.present(photoVC, animated: false, completion: nil)
                }
            )
        )
        
        //Todoを削除する
        alertActionSheet.addAction(
            UIAlertAction(
                title: "このToDo項目を削除(完了)する",
                style: UIAlertActionStyle.destructive,
                handler: { (action: UIAlertAction!) in
                    todo.remove()
                    self.loadTodoData()
                }
            )
        )

        //キャンセルする
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
    
    //※ observeSingle内ではFirebaseのobserveSingleEventメソッドが実行されて対応するクラスのデータ取得を行なっている
    fileprivate func loadTodoData() {
        
        SVProgressHUD.show(withStatus: "データ取得中...")
        
        //データの取得を行う
        Todolist.observeSingle(.value, block: { todos in
            
            self.todoList.removeAll()

            todos.forEach({ (todo) in
                self.todoList.append(todo)
            })

            SVProgressHUD.dismiss()
            self.todoList.reverse()
            self.listTableView.reloadData()
        })
    }
    
    //Firebaseにデータを入力するフォームへ遷移するアクション
    @IBAction func dataFormAction(_ sender: UIButton) {
        
        //遷移先のインスタンスを作成してコードで遷移を行う
        let toVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FormController") as! FormController
        self.present(toVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

