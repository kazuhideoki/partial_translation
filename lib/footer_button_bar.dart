import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/net/connect_local_storage.dart';
import 'package:partial_translation/util/web_view/chrome_safari_browser.dart';
import 'package:partial_translation/view_model/app_state.dart';

class FooterButtonBar extends HookWidget {
  FooterButtonBar({Key key}) : super(key: key);

  final ChromeSafariBrowser browser =
      new MyChromeSafariBrowser(new MyInAppBrowser());

  @override
  Widget build(BuildContext context) {
    final webView = useProvider(appStateProvider.state).webView;
    final currentUrl = useProvider(appStateProvider.state).currentUrl;
    final isSelectParagraph =
        context.read(appStateProvider.state).isSelectParagraph;
    print('footer isSelectParagraph $isSelectParagraph');
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
                final isSelectParagraphLocal = await webView
                    .webStorage.localStorage
                    .getItem(key: 'isSelectParagraph');
                print('''ローカルストレージのisSelectParagraphは $isSelectParagraphLocal, 
                    stateのisSelectParagraphは $isSelectParagraph''');
                webView.webStorage.localStorage.clear();
              }),
          RaisedButton(
            child: Icon(Icons.open_in_browser),
            onPressed: () async {
              await browser.open(
                  url: currentUrl,
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
          // Consumer(
          //   builder: (BuildContext context, watch, child) {
          //     final isSelectParagraph = watch(appStateProvider.state).isSelectParagraph;
          //     print('FooterButtonBarのisSelectParagraph $isSelectParagraph');

          RaisedButton(
            child: Icon(Icons.article),
            color: isSelectParagraph ? Colors.orangeAccent : Colors.grey,
            onPressed: () async {
              await switchSelectParagraph();
            },
          ),
        ],
      ),
    );
  }
}
