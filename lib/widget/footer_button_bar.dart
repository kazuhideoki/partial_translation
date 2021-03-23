import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final switchSelectParagraph =
        useProvider(appStateProvider).switchSelectParagraph;
    return Container(
      color: Colors.white,
      child: ButtonBar(
        
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
                webView.goBack();
            },
          ),
          
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
                webView.goForward();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
                webView.reload();
            },
          ),
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () async {
              await browser.open(
                  url: currentUrl,
                  options: ChromeSafariBrowserClassOptions(
                      android: AndroidChromeCustomTabsOptions(
                          addDefaultShareMenuItem: false),
                      ios: IOSSafariOptions(barCollapsingEnabled: true)));
            },
          ),

          IconButton(
            icon: Icon(Icons.article),
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
