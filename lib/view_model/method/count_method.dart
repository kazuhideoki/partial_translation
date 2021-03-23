import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:partial_translation/net/connect_local_storage.dart';

Future<int> getCountMethod(InAppWebViewController  webView) async {
    try {
      var count = await ConnectLocalStorage(webView).getCount();
      if (count == null) {
        await setCountMethod(webView, 0);
        return 0;
      }
      return count; 
    } catch (err) {
      print('AppStateNotifier.getCount: 【error】 $err');
    }
  }

  Future<void> setCountMethod(InAppWebViewController  webView, int count) async {
    try {
      await ConnectLocalStorage(webView).setCount(count);
    } catch (err) {
      print('AppStateNotifier.setCount: 【error】 $err');
    }
  }