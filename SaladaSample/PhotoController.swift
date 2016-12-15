//
//  PhotoController.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/15.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class PhotoController: UIViewController, UIScrollViewDelegate {

    //遷移元から受け取るTodoリストのデータ格納用
    var targetTodoList: Todolist!
    
    //UIパーツの配置
    @IBOutlet weak var todoTitle: UILabel!
    @IBOutlet weak var todoPhotoScrollView: UIScrollView!
    @IBOutlet weak var todoDetailTextView: UITextView!
    @IBOutlet weak var itemsPerPage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIScrollViewのデリゲート
        todoPhotoScrollView.delegate = self
        
        //初回呼び出し時にはコンテンツ全体を非表示状態にしておく
        self.view.alpha = 0.0
    }

    //Viewの表示が完了した際に呼び出されるメソッド
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ポップアップ表示を実行する
        showAnimatePopup()
    }
    
    //レイアウト処理が完了した際のライフサイクル
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //コンテンツ用のScrollViewを初期化
        initScrollViewDefinition()
        
        //タイトルと詳細を入れる
        todoTitle.text = targetTodoList.title
        todoDetailTextView.text = targetTodoList.detail
        todoDetailTextView.textColor = UIColor.white
        
        //写真の枚数を元にスクロールビューの横幅を決定する
        let imageCount: Int = Int(targetTodoList.photo_count!)!
        let imageScrollWidth: CGFloat = CGFloat(Int(todoPhotoScrollView.frame.width) * imageCount)

        //スクロールビュー内のサイズを決定する（AutoLayoutで配置を行った場合でもこの部分はコードで設定しないといけない）
        todoPhotoScrollView.contentSize = CGSize(
            width:  imageScrollWidth,
            height: todoPhotoScrollView.frame.height
        )
        
        //メインのスクロールビューの中にコンテンツ表示用のコンテナを一列に並べて配置する
        for i in 0...imageCount {
            
            //メニュー用のスクロールビューにUIImageViewを配置
            let imageView: UIImageView = UIImageView()
            todoPhotoScrollView.addSubview(imageView)
            
            imageView.frame = CGRect(
                x: CGFloat(Int(todoPhotoScrollView.frame.width) * i),
                y: 0,
                width: todoPhotoScrollView.frame.width,
                height: todoPhotoScrollView.frame.height
            )
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            //ダウンロード中のインジケータを配置する
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            todoPhotoScrollView.addSubview(activityIndicator)
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            activityIndicator.center = imageView.center
            activityIndicator.startAnimating()
            
            //1枚目の写真のセット
            if i == 0 {
                
                //画像データのダウンロードタスクを実行する
                targetTodoList.image1?.dataWithMaxSize(1 * 2000 * 2000, completion: { (data, error) in
                    if let error: Error = error {
                        print(error)
                        return
                    }
                    
                    //UIImageをセット＆インジケーターを消す
                    imageView.image = UIImage(data: data!)
                    imageView.alpha = 0
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    //アニメーションをかけてアルファを1にする
                    UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                        imageView.alpha = 1
                    }, completion: nil)
                    
                })?.resume()

            //2枚目の写真のセット(※2枚目の写真がある場合)
            } else if i == 1 {

                targetTodoList.image2?.dataWithMaxSize(1 * 2000 * 2000, completion: { (data, error) in
                    if let error: Error = error {
                        print(error)
                        return
                    }

                    imageView.image = UIImage(data: data!)
                    imageView.alpha = 0
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()

                    UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                        imageView.alpha = 1
                    }, completion: nil)
                    
                })?.resume()

            //3枚目の写真のセット(※3枚目の写真がある場合)
            } else if i == 2 {
                
                targetTodoList.image3?.dataWithMaxSize(1 * 2000 * 2000, completion: { (data, error) in
                    if let error: Error = error {
                        print(error)
                        return
                    }
                    
                    imageView.image = UIImage(data: data!)
                    imageView.alpha = 0
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                        imageView.alpha = 1
                    }, completion: nil)
                    
                })?.resume()
            }
        }
    }
    
    //ポップアップを閉じるボタンアクション
    @IBAction func closePopupAction(_ sender: UIButton) {
        
        //ポップアップ削除を実行する
        removeAnimatePopup()
    }
    
    /* (Fileprivate functions) */
    
    //コンテンツ用のUIScrollViewの初期化を行う
    fileprivate func initScrollViewDefinition() {
        
        //スクロールビュー内の各プロパティ値を設定する
        todoPhotoScrollView.isPagingEnabled = true
        todoPhotoScrollView.isScrollEnabled = true
        todoPhotoScrollView.isDirectionalLockEnabled = false
        todoPhotoScrollView.showsHorizontalScrollIndicator = true
        todoPhotoScrollView.showsVerticalScrollIndicator = false
        todoPhotoScrollView.bounces = false
        todoPhotoScrollView.scrollsToTop = false
    }
    
    //ポップアップアニメーションを実行する（実行するまではアルファが0でこのUIViewControllerが拡大している状態）
    fileprivate func showAnimatePopup() {
        self.view.transform = CGAffineTransform(scaleX: 1.38, y: 1.38)
        UIView.animate(withDuration: 0.16, animations: {
            
            //おおもとのViewのアルファ値を1.0にして拡大比率を元に戻す
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    //ポップアップアニメーションを閉じる（実行するまではアルファが1でこのUIViewControllerが等倍の状態）
    fileprivate func removeAnimatePopup() {
        UIView.animate(withDuration: 0.16, animations: {
            
            //おおもとのViewのアルファ値を0.0にして拡大比率を拡大した状態に変更
            self.view.transform = CGAffineTransform(scaleX: 1.38, y: 1.38)
            self.view.alpha = 0.0
            
        }, completion:{ finished in
            
            //アニメーションが完了した際に遷移元に戻す（このクラスで独自アニメーションを定義しているので第1引数:animatedをfalseにしておく）
            self.dismiss(animated: false, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
