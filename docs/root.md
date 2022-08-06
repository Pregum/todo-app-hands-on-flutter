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

---
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
</ul>

---
## なぜ他のXPではなくFlutterなのか？:thinking:

### --> UIのソースがWeb上で共有できる(DartPad)

下記のurlからサンプルコードが実行可能

https://dartpad.dev/7942cc454f0937046632c7c61ea3e773 



---
## 実行結果

<img src="./images/counter_sample_1.png" height=440 />


---
##  開発も全てDartPadで良いのでは:thinking:

<!-- ✅ UIレイアウトの共有が簡単(Code Penみたいに共有可能) -->
❌ 端末上では確認できない
❌ 複数ファイル必要な複雑なレイアウトは確認できない
❌ MySQLなどのDBや端末のセンサを使用するライブラリは使用不可

上記の点で実際の開発環境として使うのは厳しい 😓 

---
## ネイティブアプリとの違い 

開発スピードと処理速度

ネイティブアプリ
✅  処理速度が速い
:x: 各OSごとにコードを書く必要がある

Flutter
✅  1つのソースで複数のOSのコードが実行可能
:x: ネイティブアプリに比べると処理速度が若干遅い









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
