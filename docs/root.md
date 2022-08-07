---
marp: true
theme: gaia
author: pregum
header: Todo アプリ ハンズオン
paginate: true
footer: pregum
size: 16:9

---
<!-- headingDivider: 1 -->

 
# Todoアプリハンズオン <marquee behaivor="slide" scrolldelay="10">by Flutter</marquee>
 
# 目次

* Flutterとは？
* ネイティブアプリとの違い
* 今日作るアプリについて
* 早速アプリを作る

# Flutterとは？(2min)

* Googleが開発中のクロスプラットフォーム(以降XP)開発が可能なフレームワークです。
* 今現在(2022/8/7)では、iOS/Android/Web/Linux/macOS/Windowが開発可能です。


---
## なぜ他のXPではなくFlutterなのか？:thinking:

色々ありますが以下が大きな要因です。

<ul>
  <li>いい感じのUIが標準ライブラリで作れる</li>
  <li>アプリを起動しながらレイアウトの微調整が可能</li>
  <li>Debugツールが使いやすい</li>
  <li>対応プラットフォームが多い</li>
  <li>UIのソースがWeb上で共有できる(DartPad)</li>
</ul>

<!-- ---
<style scoped>
  .red-border {
    border: solid red;
  }
</style>
## なぜ他のXPではなくFlutterなのか？:thinking:

今回のハンズオンでは赤枠の部分を実際に体験できる箇所です。

<ul> 
  <li class="red-border"> いい感じのUIが標準ライブラリで作れる </li>
  <li class="red-border"> アプリを起動しながらレイアウトの微調整が可能 </li>
  <li class="red-border"> Debugツールが使いやすい </li>
  <li> 対応プラットフォームが多い </li>
  <li> UIのソースがWeb上で共有できる(DartPad) </li>
</ul> -->

---
## なぜ他のXPではなくFlutterなのか？:thinking:

### --> UIのソースがWeb上で共有できる(DartPad)

下記のurlからサンプルコードが実行可能

https://dartpad.dev/7942cc454f0937046632c7c61ea3e773 



---
## 実行結果

<style scoped>
  .middle-center {
    margin: 0 auto;
    width: 100%;
    object-fit: contain;
    /* background-color: red; */
  }
</style>

<img class="middle-center" src="./images/counter_sample_1.png" height=440 />


---
##  開発も全てDartPadで良いのでは:thinking:

<!-- ✅ UIレイアウトの共有が簡単(Code Penみたいに共有可能) -->
❌ 端末上では確認できない
❌ 複数ファイル必要な複雑なレイアウトは確認できない
❌ MySQLなどのDBや端末のセンサを使用するライブラリは使用不可

上記の点で実際の開発環境として使うのは厳しい 😓 

軽く挙動を見たい時に使うのが良さそう

---
## ネイティブアプリとの違い 

開発スピードと処理速度

ネイティブアプリ
✅  処理速度が速い
:x: 各プラットフォームごとにコードを書く必要がある

Flutter
✅  1つのソースで複数のプラットフォームで実行可能
:x: ネイティブアプリに比べると処理速度が若干遅い

---
<style scoped>
  .tes {
    width: 100%;
    justify-content: center;
    align-content: center;
    display: flex;
    height: 60vh;
    /* background-color: green; */
    text-align: center;
    line-height: 60vh;
  }
</style>

<h2 class="tes"> 今日作るアプリについて </h2>

# 今日作るアプリについて
#### 今日のできる成果物

機能一覧

* タスク作成機能
* タスク編集機能
* タスク削除機能
* タスク完了チェック機能

https://github.com/Pregum/todo-app-hands-on-flutter



---
## アプリを作り始める前に

#### FlutterのUIの仕組みについて

FlutterのUIは全て**ウィジェット**

* テキスト
* ボタン
* チェックボックス
* etc...

---
### FlutterのUIの仕組みについて
ウィジェットは大きく分けて2種類存在する

* **状態(State)を持つStateful Widget**
  * setState()で状態を変更できる
* **状態(State)を持たないStateless Widget**
  * setState()は使用不可
  * 親ウィジェットや外部から受け取るデータによって更新は可能

最初はStateful Widgetを使っておけばOK:+1:

---
### Flutterは宣言的UI

<style scoped>
  .left {
    display: flex;
    width: 48%;
    flex-direction: column;
  }
  .center{
    display: flex;
    width: 4px;
    margin: 8px;
    background-color: black
  }
  .right {
    display: flex;
    width: 48%;
    flex-direction: column;
  }
  .container {
    display: flex;
    flex-direction: row;
    margin-top: 16px;
  }
</style>

<div class="container">
  <div class="left">

  ###### 宣言的UI (React, SwiftUI, etc...)

    String name = 'taro';

    Center(
      child: Text('Hello $name'),
    ),

    // -> Hello taro

  どのように配置させたいかだけを記述する。
  </div>

  <div class="center">
  </div>

  <div class="left">

  ###### 命令的UI (UIkit, WinForms, etc...)

      text.text = "taro"
      text.textAlignment = NSTextAlignment.Center
      text.frame = CGRect(
        x: 50,
        y: 50,
        width: 50,
        height: 50
      )

  レイアウトの配置からテキストの文字列まで記述する。
    
  </div>
</div>

---
### 簡単にいうと

宣言的UIは「画面中央にテキストを配置して、表示する文字はこれ」と指示する
--> 画面に描画する具体的な処理は、コンパイラにお任せ
<!-- --> 高さが変わってもコンパイラが勝手にやってくれる -->

命令的UIは「テキストを中央揃えに設定...」と指示する
--> 描画する具体的な処理についても指示を出す
<!-- --> 文字が更新された時、高さの調整なども自分で指示する -->

---
### 何となくわかる図

<style scoped>
  .left {
    display: flex;
    width: 48%;
    flex-direction: column;
  }
  .right {
    display: flex;
    width: 48%;
    flex-direction: column;
    margin-left: 16px;
  }
  .container {
    display: flex;
    flex-direction: row;
    margin-top: 16px;
  }
</style>


<div class="container">
  <img class="left" src="images/declartive_vs_imperative.png" />

  <div class="right">
  <a href="https://twitter.com/gethackteam/status/1268892357027663873/photo/1"> https://twitter.com/gethackteam/status/1268892357027663873/photo/1</a>

  左が宣言的、右が命令的

  左は進む(D)の1つだけで**ギアを意識しなくて良い**

  右は今どの**ギアにいるか意識しないといけない**

  </div>
</div>


---
## 参考サイト


* https://twitter.com/gethackteam/status/1268892357027663873?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1268892357027663873%7Ctwgr%5E12007820d2fc3fecbe0ca6381183ab580763b432%7Ctwcon%5Es1_&ref_url=https%3A%2F%2Fqiita.com%2FHiroyuki_OSAKI%2Fitems%2Ff3f88ae535550e95389d

* https://qiita.com/Hiroyuki_OSAKI/items/f3f88ae535550e95389d

---
* Flutterとは(2min)
* なんで他のクラスプラットフォームではないの？:thinking:
  * いい感じのUIが標準ライブラリで作れる
  * レイアウトの微調整が簡単
  * 対応プラットフォームが多い
  * UIのソースがWeb上で共有できる(DartPad)
* クロスプラットフォームアプリとネイティブアプリの違い(2min)
* 今日作るアプリのデモ画面(1min)
* ハンズオン開始
  * 画面を作ろう
    * 重要なウィジェット
      * StatefulWidget
        * MaterialApp
        * Scaffold
        * Container
    * このアプリのMVPウィジェット
      * ListView
    * 今日使うウィジェット達一覧
      * main.dart
        * CircularProgressIndicator.adaptive()
        * MaterialApp
        * Scaffold
        * AppBar
        * FloatingActionButton
        * Icon
        * SnackBar
        * Text
        * StatefulWidget
        * StatelessWidget
      * 
    * 画面一覧
      * main.dart
      * observer.dart
      * todo.dart
      * todo.g.dart
      * todo_manager.dart
      * todo_screen.dart
      * todo_service.dart
      * todo_tile_widget.dart
