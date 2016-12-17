# FirebaseSimpleTodo
[ING] Firebaseとそのデータを扱いやすくするライブラリ（Salada）を用いたToDoリストの簡易サンプル（iOS Sample Study: Swift）

Firebaseのデータを扱い易くするライブラリを用いた、画像の複数アップロード機能付きのToDoリストのサンプルアプリになります。

### 実装機能一覧

本サンプル内で実装している機能の一覧は下記になります。

+ 登録したToDoの一覧を表示する画面（ActionSheetで詳細表示orデータ削除を選択し該当の処理を行う）
+ ToDoに関するデータを登録する画面（内訳は「ToDo名」・「具体的にすること」・「画像は1枚～3枚アップロード可能」）
+ ToDoの詳細表示をする画面（登録されたデータに紐づくFirebase Storage内の画像をダウンロードして表示する）

### 本サンプルの画面キャプチャ

__キャプチャ画像その1：__

![sample_capture1.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/f3971006-0437-89f3-a4e7-908aed2105be.jpeg)

__キャプチャ画像その2：__

![sample_capture2.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/57b0f1e9-9d26-4fdc-2b1d-dbd198c0206a.jpeg)

### 本サンプルでのFirebase内でのデータの持ち方

__Database：__

![firebase_capture1.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/184350b9-40b6-c00f-3ae5-0416ec132f0c.jpeg)

__Storage：__

![firebase_capture2.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/ae045458-041a-f061-bc91-29ba4956b2f9.jpeg)

### 使用ライブラリ

Firebaseまわりに関する処理に関しては、下記のライブラリを使用しました。

+ [Salada (Firebaseを扱いやすくするためのライブラリ)](https://github.com/1amageek/Salada)

Databaseへのデータの追加・削除及びStorageへの画像のアップロード処理に関してはこのライブラリを活用して作成をしています。
作者の[@1_am_a_geek](https://twitter.com/1_am_a_geek)様、本当にありがとうございます！

### その他

詳細な解説＆実装のポイントになる部分はこちらに掲載しておりますので、是非とも実機などがおありの場合はインストールをして挙動や振る舞いをご確認いただければと思います。

+ http://qiita.com/fumiyasac@github/items/40f143a53895282f80f8
