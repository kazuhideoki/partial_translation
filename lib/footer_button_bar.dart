import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/util/web_view/chrome_safari_browser.dart';
import 'package:partial_translation/view_model/app_state.dart';

class FooterButtonBar extends HookWidget {
  FooterButtonBar({Key key, this.url, this.webView, this.partialTranslate}) : super(key: key);

  InAppWebViewController webView;
  String url;
  Function partialTranslate;

  final ChromeSafariBrowser browser =
      new MyChromeSafariBrowser(new MyInAppBrowser());

  @override
  Widget build(BuildContext context) {
    final isLongTapToTranslate =
        useProvider(appStateProvider.state).isLongTapToTranslate;
    final switchLongTapToTranslate =
        useProvider(appStateProvider).switchLongTapToTranslate;
    final isSelectParagraph =
        useProvider(appStateProvider.state).isSelectParagraph;
    final switchSelectParagraph =
        useProvider(appStateProvider).switchSelectParagraph;
    return Container(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        buttonMinWidth: 2.5,
        children: <Widget>[
          RaisedButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              if (webView != null) {
                webView.goBack();
              }
            },
          ),
          RaisedButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              if (webView != null) {
                webView.goForward();
              }
            },
          ),
          RaisedButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              if (webView != null) {
                webView.reload();
              }
            },
          ),
          RaisedButton(
              child: Icon(Icons.show_chart),
              onPressed: () async {
                final localStorage =
                    await webView.webStorage.localStorage.getItems();
                print(localStorage);
                // final localStorage2 =
                //     await webView.webStorage.localStorage.getItem(key: 'isSelectParagraph');
                // print(localStorage2);
              }),
          RaisedButton(
            child: Icon(Icons.open_in_browser),
            onPressed: () async {
              await browser.open(
                  url: url,
                  options: ChromeSafariBrowserClassOptions(
                      android: AndroidChromeCustomTabsOptions(
                          addDefaultShareMenuItem: false),
                      ios: IOSSafariOptions(barCollapsingEnabled: true)));
            },
          ),
          // RaisedButton(
          //   child: Icon(Icons.touch_app),
          //   color: isLongTapToTranslate ? Colors.orangeAccent : Colors.grey,
          //   onPressed: () {
          //     switchLongTapToTranslate(webView, partialTranslate);
          //   },
          // ),
          RaisedButton(
            child: Icon(Icons.article),
            color: isSelectParagraph ? Colors.orangeAccent : Colors.grey,
            onPressed: () {
              switchSelectParagraph(webView);
            },
          ),
        ],
      ),
    );
  }
}
