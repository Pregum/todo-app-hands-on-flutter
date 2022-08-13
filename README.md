# todo_app

ハンズオン用に作成したTodo アプリです。

## 機能一覧

* タスク作成機能
* タスク編集機能
* タスク削除機能
* タスクDB保存機能
* タスク完了チェック機能

## 動画

* Web




https://user-images.githubusercontent.com/19755685/184498864-797905a1-c08a-4db3-bc73-550d5d0f5e40.mov




* Android


https://user-images.githubusercontent.com/19755685/184498846-b8e799cb-61a0-4329-9942-812df42d0c31.mov



## 起動方法

### Android

#### コマンドラインの場合

1. `flutter pub get`コマンドを実行

2. `flutter run` コマンドを実行し、デバイスの指定画面が表示されるので、androidの実機もしくはエミュレータを選択する

#### vscodeの場合

1. Shift + cmd + d (WindowsはShift + Ctrl + d) で起動する環境リストを「todo_app」を選択し、`main.dart` ファイルを起動している状態でF5で起動

### Chrome

#### コマンドラインの場合

1. `flutter pub get` コマンドを実行

2. `flutter run` コマンドを実行し、起動可能なデバイス一覧からChromeを選択する。

#### vscodeの場合

1. Shift + cmd + d(WindowsはShift + Ctrl + d)で起動する環境リストから「todo_app(chrome)」を選択し、`main.dart`ファイルを起動している状態でF5で起動

※ Chromeの場合は、-web--rendererオプションを指定しないまま起動すると２バイト文字がTofuになるので注意

