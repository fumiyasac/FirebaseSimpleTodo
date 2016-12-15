//
//  FormController.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Photos
import SVProgressHUD

class FormController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    //画像のバリデーションカウント
    let validaionCount: Int = 3
    
    //PhotoLibraryで取得した画像を格納する配列
    var photoAssetLists: [PHAsset] = []
    
    //画像のインデックスと画像データを格納するDictionary
    var photoListDictionary: [Int : PHAsset] = [:]
    
    //UIパーツの配置
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoDetail: UITextField!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    //データ登録時の半透明のビュー
    @IBOutlet weak var wrappedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTitle.delegate = self
        todoTitle.placeholder = "(例）ごはんをつくる"

        todoDetail.delegate = self
        todoDetail.placeholder = "(例）お米を炊いてカレーをつくる"
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        addButton.isEnabled = true
        wrappedView.alpha = 0
        wrappedView.isHidden = true
        
        //画像のセルを定義する
        let nibPhotoCell: UINib = UINib(nibName: "PhotoCell", bundle: nil)
        photoCollectionView.register(nibPhotoCell, forCellWithReuseIdentifier: "PhotoCell")
        
        //画像をフォトライブラリから読み込む
        dispatchPhotoLibraryAndReload()
    }

    /* (UITextFieldDelegate) */
    
    //テキストフィールドの編集が終了した際にキーボードを引っ込める
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* (UICollectionViewDelegate) */
    
    //このコレクションビューのセクション数を決める
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /* (UICollectionViewDataSource) */
    
    //このコレクションビューのセル数を決める
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssetLists.count
    }
    
    //このコレクションビューのセル内へ写真の配置を行う
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell

        //cellの表示時の選択中の部分
        if photoListDictionary[indexPath.row] != nil {
            
            UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                cell?.photoSelectedLabel.alpha = 1
                cell?.photoAlphaView.alpha = 0
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                cell?.photoSelectedLabel.alpha = 0
                cell?.photoAlphaView.alpha = 0.35
            }, completion: nil)
            
        }
        cell?.photoImageView.image = convertAssetThumbnail(asset: photoAssetLists[indexPath.row], rectSize: 100)
        
        return cell!
    }
    
    //このコレクションビューのセルをタップした際の写真を選択する
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //選択したセル要素を取得する
        let selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        
        //選択中でないセルの場合は写真を選択する（逆の場合は写真の選択をキャンセルする）
        if selectedCell?.photoSelectedLabel.alpha == 0 {
            
            //写真選択を行う
            if (photoListDictionary.count < validaionCount) {
                
                photoListDictionary[indexPath.row] = photoAssetLists[indexPath.row]
                UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                    selectedCell?.photoSelectedLabel.alpha = 1
                    selectedCell?.photoAlphaView.alpha = 0
                }, completion: nil)
            }

        } else {
            
            //写真選択解除を行う
            photoListDictionary.removeValue(forKey: indexPath.row)
            UIView.animate(withDuration: 0.28, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations:{
                selectedCell?.photoSelectedLabel.alpha = 0
                selectedCell?.photoAlphaView.alpha = 0.35
            }, completion: nil)
        }
        
        //画像の枚数の表示を変更する
        photoCountLabel.text = "写真選択：\(photoListDictionary.count)枚"
    }
    
    //画像の同期のアクション
    @IBAction func syncPhotoAction(_ sender: UIButton) {
        
        //選択状態をクリアして画像をリロード
        photoAssetLists.removeAll()
        dispatchPhotoLibraryAndReload()

        //画像の枚数の表示を変更する
        photoCountLabel.text = "写真選択：\(photoListDictionary.count)枚"
    }
    
    //データの追加アクション
    @IBAction func addDataAction(_ sender: UIButton) {
        
        //バリデーションを行う
        if ((todoTitle.text?.isEmpty)! || (todoDetail.text?.isEmpty)! || photoListDictionary.count == 0) {

            let errorAlert = UIAlertController(
                title: "エラー",
                message: "入力必須の項目に不備があります。",
                preferredStyle: UIAlertControllerStyle.alert
            )
            errorAlert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: nil
                )
            )
            present(errorAlert, animated: true, completion: nil)
            
        //OK:データを1件Firebaseにセーブする
        } else {
            
            //ボタンを押せなくしてインジケーターを表示する
            addButton.isEnabled = false
            wrappedView.alpha = 0.35
            wrappedView.isHidden = false
            SVProgressHUD.show(withStatus: "読み込み中...")
            
            //PHAssetから取得したデータをリネームしてFile型に変換してDictonaryに詰め直す
            var saveImageData: [Int : File] = [:]
            var newIndex = 1
            
            for (_, value) in photoListDictionary {

                let targetImage = convertAssetOriginPhoto(asset: value)
                let photoData: Data = UIImageJPEGRepresentation(targetImage, 0.1)!
                let photoIdentifier = String(format: "%02d", newIndex) + ".jpg"
                
                let thumbnail: File = File(name: photoIdentifier, data: photoData)
                saveImageData[newIndex] = thumbnail
                
                newIndex += 1
            }

            //Todolistクラスのインスタンスを作成してそれぞれのプロパティに対応する値を入れる
            let todolist: Todolist = Todolist()
            todolist.title = todoTitle.text
            todolist.detail = todoDetail.text
            todolist.image1 = saveImageData[1] ?? nil
            todolist.image2 = saveImageData[2] ?? nil
            todolist.image3 = saveImageData[3] ?? nil
            todolist.progress = "これから着手"
            todolist.photo_count = String(saveImageData.count)
            
            //saveメソッドを実行して、正常処理の終了時のコールバックを記載する
            todolist.save({ (ref, error) in
                
                if ref != nil {
                    
                    //プログレスバーを非表示にする
                    SVProgressHUD.dismiss()
                    self.wrappedView.alpha = 0
                    self.wrappedView.isHidden = true
                    
                    //登録されたアラートを表示してOKを押すと戻る
                    let correctAlert = UIAlertController(
                        title: "完了",
                        message: "入力データが登録されました。",
                        preferredStyle: UIAlertControllerStyle.alert
                    )
                    correctAlert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: UIAlertActionStyle.default,
                            handler: { (action: UIAlertAction!) in
                                self.dismiss(animated: true, completion: nil)
                            }
                        )
                    )
                    self.present(correctAlert, animated: true, completion: nil)
                }
            })
        }

    }
    
    //戻るボタンのアクション
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    //PHAsset型のデータを表示用に変換する
    fileprivate func convertAssetOriginPhoto(asset: PHAsset) -> UIImage {

        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var photo = UIImage()
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
            photo = result!
        })
        return photo
    }
    
    //フォトライブラリを非同期で読み込む処理
    fileprivate func dispatchPhotoLibraryAndReload() {
        
        //一旦全てを空にする
        photoListDictionary.removeAll()
        
        //データの取得はサブスレッドで行う
        DispatchQueue.global().async {
            self.photoCollectionView.isUserInteractionEnabled = false
            self.getPHAssetsForImageLibrary()
            
            //テーブルビューのリロードはメインスレッドで行う
            DispatchQueue.main.async {
                self.photoCollectionView.isUserInteractionEnabled = true
                self.photoCollectionView.reloadData()
            }
        }
    }
    
    //PHAssetクラスを使用して画像を取得する
    fileprivate func getPHAssetsForImageLibrary() {
        
        //データの並べ替え条件
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        //Photoライブラリから画像を取得する
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects( { (asset, index, stop) -> Void in
            self.photoAssetLists.append(asset as PHAsset)
        })
        photoAssetLists.reverse()
    }
    
    //PHAsset型のデータをサムネイルに変換する（UICollectionViewCell表示用）
    fileprivate func convertAssetThumbnail(asset: PHAsset, rectSize: Int) -> UIImage {
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true

        manager.requestImage(for: asset, targetSize: CGSize(width: rectSize, height: rectSize), contentMode: .aspectFill, options: option, resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
