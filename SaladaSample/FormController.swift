//
//  FormController.swift
//  SaladaSample
//
//  Created by 酒井文也 on 2016/12/13.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Photos

class FormController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    //画像のバリデーションカウント
    let validaionCount: Int = 2
    
    //PhotoLibraryで取得した画像を格納する配列
    var photoAssetLists: [PHAsset] = []
    
    //画像のインデックスと画像データを格納するDictionary
    var photoListDictionary: [Int : PHAsset] = [:]
    
    //UIパーツの配置
    @IBOutlet weak var todoTitle: UITextField!
    @IBOutlet weak var todoDetail: UITextField!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCountLabel: UILabel!
    
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
        
        wrappedView.alpha = 0
        wrappedView.isHidden = true
        
        //画像のセルを定義する
        let nibPhotoCell: UINib = UINib(nibName: "PhotoCell", bundle: nil)
        photoCollectionView.register(nibPhotoCell, forCellWithReuseIdentifier: "PhotoCell")
        
        //画像をフォトライブラリから読み込む
        dispatchPhotoLibraryAndReload()
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

    //キーボードを隠すアクション
    @IBAction func hideKeyboardAction(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //データの追加アクション
    @IBAction func addDataAction(_ sender: UIButton) {
        //
    }
    
    //戻るボタンのアクション
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        //dismiss(animated: true, completion: nil)
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
    
    //PHAsset型のデータを表示用に変換する
    fileprivate func convertAssetThumbnail(asset: PHAsset, rectSize: Int) -> UIImage {
        
        //TODO:コメントをきちんと書く
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
