/// 更新通知をやりとりするインタフェースです。
///
/// dartは暗黙的に全てのクラスがinterfaceを持ちます。
///
/// なので通常classでも問題ないですが、実装ができてしまうため、
///
/// [ abstract ]キーワードをつけることで、実装を強制させています。
abstract class MyObserver<T> {
  /// 更新時に呼び出されます。
  ///
  /// 更新後のデータは [item] です。
  void onReceive(T item);

  /// 作成時に呼び出されます。
  ///
  /// 作成されたデータは [item] です。
  void onCreate(T item);
}
