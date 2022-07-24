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

<https://user-images.githubusercontent.com/19755685/180635648-6903cac3-4846-4632-a37c-ac7ed01ad312.mov>

* Android

<https://user-images.githubusercontent.com/19755685/180637409-e9405421-bfff-496d-9b89-53f1c0cb8fbf.mov>

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

