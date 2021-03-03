import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ConnectLocalStorage {
  ConnectLocalStorage(this.webView);

  InAppWebViewController webView;

  Future _getItem(String key) async {
    return webView.webStorage.localStorage.getItem(key: key);
  }

  Future<void> _setItem(String key, dynamic value) async {
    webView.webStorage.localStorage.setItem(key: key, value: value);
  }

  Future getCount() async {
    return _getItem('count');
  }

  Future<void> setCount(int value) async {
    _setItem('count', value);
  }

  Future getIsSelectParagraph() async {
    return _getItem('isSelectParagraph');
  }

  Future<void> setIsSelectParagraph(bool value) async {
    _setItem('isSelectParagraph', value);
  }
}
