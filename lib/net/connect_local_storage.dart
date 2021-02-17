import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ConnectLocalStorage {
  ConnectLocalStorage(this.webView);

  InAppWebViewController webView;

  Future _getItem(String key) async {
    return await webView.webStorage.localStorage.getItem(key: key);
  }

  Future<void> _setItem(String key, dynamic value) async {
    await webView.webStorage.localStorage.setItem(key: key, value: value);
  }

  Future getCount() async {
    return await _getItem('count');
  }

  Future<void> setCount(int value) async {
    await _setItem('count', value);
  }
  Future getIsSelectParagraph() async {
    return await _getItem('isSelectParagraph');
  }

  Future<void> setIsSelectParagraph(bool value) async {
    await _setItem('isSelectParagraph', value);
  }
}
