import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/chrome_safari_browser.dart';
import 'package:partial_translation/view_model/app_state_view_model.dart';

class FooterButtonBar extends HookWidget {
  FooterButtonBar({Key key, this.url}) : super(key: key);

  String url;

  final ChromeSafariBrowser browser =
      new MyChromeSafariBrowser(new MyInAppBrowser());

  @override
  Widget build(BuildContext context) {
    final webViewController =
        useProvider(appStateProvider.state).webViewController;
    return Container(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        buttonMinWidth: 2.5,
        children: <Widget>[
          RaisedButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              if (webViewController != null) {
                webViewController.goBack();
              }
            },
          ),
          RaisedButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              if (webViewController != null) {
                webViewController.goForward();
              }
            },
          ),
          RaisedButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              if (webViewController != null) {
                webViewController.reload();
              }
            },
          ),
          RaisedButton(
              child: Icon(Icons.show_chart),
              onPressed: () async {
                final localStorage =
                    await webViewController.webStorage.localStorage.getItems();
                print(localStorage);
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
        ],
      ),
    );
  }
}
