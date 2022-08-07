abstract class Observer<T> {
  void onReceive(T item);
  void onCreation(T item);
}
