import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<List<String>> extractUrlsFromClipBoard() async {
  String textData =
      await Clipboard.getData('text/plain').then((value) => value.text);
  final regExp =
      RegExp(r"^https?://[\w!?/+\-_~;.,*&@#$%()'[\]]+", multiLine: true);
  var texts = textData.split(' ');
  texts = texts
      .map((text) => text.split('\n'))
      .expand((i) => i)
      .toList(); // iosのばぐ回避→正しいurlに飛ばないと落ちる？, （要対応）存在しないURLだとローディングが止まる

  return texts.where((text) => text.contains(regExp)).toList();
}

void showSnackBarJumpUrl(
    BuildContext context, InAppWebViewController controller, List<String> urls) async {

  if (urls.length != 0) {
    print('urls.contains(regExp)!!!');
    print(urls);
    final snackBar = SnackBar(
      content: Text('クリップボードのurlにアクセスしますか？'),
      action: SnackBarAction(
        label: 'Go!',
        onPressed: () {
          // Some code to undo the change.
          try {
            controller.loadUrl(url: urls[0]);
          } catch (err) {
            controller.loadUrl(url: 'https://google.com');
          }
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
