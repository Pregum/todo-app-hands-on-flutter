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

<h1 class="tes"> 今日作るアプリについて </h1>

---
## 今日作るアプリについて
#### 今日できるアプリ

https://github.com/Pregum/todo-app-hands-on-flutter

機能一覧

* タスク作成機能
* タスク編集機能
* タスク削除機能
* タスク完了チェック機能




---
## アプリを作り始める前に

#### FlutterのUIについて

FlutterのUIは全て**ウィジェット**

* テキスト
* ボタン
* チェックボックス
* etc...

---
### FlutterのUIについて
ウィジェットは大きく分けて2種類存在する

* **状態(State)を持つStateful Widget**
  * setState()で状態を変更可能
* **状態(State)を持たないStateless Widget**
  * setState()は使用不可
  * 親ウィジェットや外部から受け取るデータによって更新可能

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

  何を表示させるかを記述する。
  </div>

  <div class="center">
  </div>

  <div class="left">

  ###### 命令的UI (UIKit, WinForms, etc...)

    text.frame = CGRect(
      x: 50,
      y: 50,
      width: 50,
      height: 50
    )
    text.text = "taro"
    text.textAlignment = NSTextAlignment.Center

  レイアウトの配置からテキストの文字列まで記述する。
    
  </div>
</div>

---
### 一言で表すと

宣言的UIは**何をしたいかをコードで伝える** (What)

命令的UIは**どのようにしたいかをコードで伝える** (How)

---
## Flutterでの描画

どのウィジェットを使用する場合でもレイアウトは `build` メソッドに記述されています。

Text, ListView, Slider, Container, etc...
どのウィジェットでも`build` メソッドに記載されています。
レイアウトを確認したいときは`build` で検索すると良いです。

---

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

## 【注意】画面の更新にはルールが存在する


画面の更新処理は必ず `setState()` メソッドの中に記述すること

<div class="container">
  <div class="left">

  ✅  OK

    // :
    Text(count)
    // :

    // ヨシ！
    setState(() {
      count = count + 1;
    });

  </div>
  <div class="center">
  </div>
  <div class="right">

  :x: NG

    // :
    Text(count)
    // :

    // これでは画面に+1された値が反映されない
    count = count + 1;

  </div>
</div>




---
## Todoアプリで使う主なウィジェット

* **MaterialApp**
  * 根本にとりあえず置いておくウィジェット

* **Scaffold**
  * 画面の大枠を作ってくれるウィジェット

* **ListView**
  * いい感じにリスト形式で表示してくれる便利なウィジェット 

* **Container**
  * 十徳ナイフのような万能ウィジェット

---
## 作成の流れ

1. プロジェクト作成
2. サンプルアプリ(カウンターアプリ)動作確認
3. 1つのタスクのUI作成
4. リスト形式に並べるUIを作成
5. ウィジェット切り出し
6. ローカルDB(Hive)のライブラリを追加

---
## プロジェクト作成

下記URLからGit Cloneをお願いします。

https://github.com/Pregum/todo-app-hands-on-flutter

ssh
`git@github.com:Pregum/todo-app-hands-on-flutter.git`

---

<style scoped>
  img .bottom {

  }
</style>
## サンプル(カウンターアプリ)動作確認

CloneしたプロジェクトをAndroid エミュレータで動かしてみます。

ここではVS Codeを使用します。

`main.dart`をVSCode上で選択後、起動先エミュレータを設定します。

![](images/image_1_1.png)

---

## 1つのタスクUI作成
#### TodoTileWidgetクラスの作成

`todo_tile_widget.dart` ファイルを作成し、
ファイル内に`TodoTileWidget` クラスを作成します。

```dart
class TodoTileWidget extends StatefulWidget {
  // :
}


class _TodoTileWidgetState extends State<TodoTileWidget> {
  // :
}
```

---
## 1つのタスクUI作成

#### todo.dart, todo.g.dartファイルを配置

<style scoped>
  .left {
    display: flex;
    width: 60%;
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
    width: 40%;
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

  先ほど共有しましたファイルから
  `todo.dart`, `todo.g.dart`ファイルを
   `lib` フォルダ直下へ配置します。

  </div>
  <div class="center">
  </div>
  <div class="right">
   <img src="images/todo_tile_create_1.png" width=340 />

  </div>
</div>

---
## 1つのタスクUI作成

#### Hiveプラグインのインポート

`pubspec.yaml`ファイルの
`dependencies`に下記ライブラリを記載し、保存します。

```yaml
dependencies:
  // :
  hive: ^2.2.3
  uuid: ^3.0.6
  hive_flutter: ^1.1.0
```

※ インデントがずれているとうまく読み込めないのでご注意下さい。

---
## 1つのタスクUI作成

#### Hiveの開発関連のプラグインをインポート

`pubspec.yaml` ファイルの
`dev_dependencies`に下記ライブラリを記載し、保存します。

```yaml
dev_dependencies:
  // :
  hive_generator: ^1.1.3
  build_runner: ^2.2.0
```

※ インデントがずれているとうまく読み込めないのでご注意下さい。

---
## 1つのタスクUI作成

#### 引数にTodoクラスのオブジェクトを設定

`TodoTileWidget` クラスの引数に Todoクラスの引数を追加します。

```dart
class TodoTileWidget extends StatefulWidget {
  final Todo todo;
  const TodoTileWidget({ Key? key, required this.todo, })
   : super(key: key);
}

class _TodoTileWidgetState extends State<TodoTileWidget> {
  // 使うときは widget.todo でアクセス可能
}
```

---
## 1つのタスクUI作成
#### Tileウィジェットを作成
`Card` > `CheckboxListTile` > `Text` の順でウィジェットを配置

```dart
Widget build(BuildContext context) {
  return Card(
    child: CheckboxListTile(
      value: widget.todo.isCompleted, // check用の変数を設定
      onChanged: (bool? value) { }, // チェックのON/OFF時のコールバックを設定 
      title: Text( widget.doto.taskName ), // タスク名を設定
      subtitle: Text( '更新日: ${ widget.todo.updatedAt }' ), // 更新日を設定
    )
  );
}
```

---
## 1つのタスクUI作成
#### 未チェック/チェック済 変数の設定

先ほどの`CheckboxListTile`の `onChanged` プロパティに
未チェック/チェック済の切り替え時に実行される処理を記述します。 

```dart
child: CheckboxListTile(
  // :
  onChanged: (bool? newValue) {
    if (newValue == null) { return; }
    widget.todo.isCompleted = newValue; // これだけだと画面に反映されない (・x・)
  }
  // :
)
```



---
## 1つのタスクUI作成
#### スライドで削除できるUIを作成

先ほどのCardウィジェットを`Dismissible` > `Container` で包みます。

```dart
Widget build(BuildContext context) {
  return Dismissible(
    child: Contaienr(
      child: Card(
        // :
      )
    )
  );
}
```

---

## 1つのタスクUI作成

#### 編集と削除用コールバックを引数に追加

`TodoTileWidget`クラスに編集と削除用のコールバックを追加します。

```dart
class TodoTileWidget extends StatefulWidget {
  final Todo todo;
  final Function()? onDismiss; // 削除用コールバック -- 追加した行
  final Function()? onLongTap; // 編集用コールバック -- 追加した行
  const TodoTileWidget({
    Key? key,
    required this.todo,
    this.onDismiss, // 削除用コールバック -- 追加した行
    this.onLongTap, // 編集用コールバック -- 追加した行
  }) : super(key: key);
```

---
## リスト形式のUIを作成

#### todo_page.dartファイルの作成

`lib`フォルダ直下に `todo_page.dart` ファイルを作成します。

`todo_page.dart`ファイル内に `TodoPage` クラスを作成します。

```dart
class TodoPage extends StatefulWidget {
  // :
}

class _TodoPageState extends State<TodoPage> {
  // :
}
```

---
## リスト形式のUIを作成

#### TodoTileWidget ウィジェットを配置

先ほど作成した `TodoPage` クラスの `build` メソッドに
`TodoTileWidget` ウィジェットを配置します。

```dart
@override
Widget build(BuildContext context) {
  return TodoTileWidget(todo: Todo);
}
```




---
## 参考サイト


* https://twitter.com/gethackteam/status/1268892357027663873?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1268892357027663873%7Ctwgr%5E12007820d2fc3fecbe0ca6381183ab580763b432%7Ctwcon%5Es1_&ref_url=https%3A%2F%2Fqiita.com%2FHiroyuki_OSAKI%2Fitems%2Ff3f88ae535550e95389d

* https://qiita.com/Hiroyuki_OSAKI/items/f3f88ae535550e95389d

* https://ui.dev/imperative-vs-declarative-programming

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
