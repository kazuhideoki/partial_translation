
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:partial_translation/chrome_safari_browser.dart';



class FooterButtonBar extends StatelessWidget {
  FooterButtonBar({Key key, this.webView, this.url}) : super(key: key);

  InAppWebViewController webView;
  String url;

  final ChromeSafariBrowser browser =
      new MyChromeSafariBrowser(new MyInAppBrowser());

  @override
  Widget build(BuildContext context) {
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
                child: Icon(Icons.remove),
                onPressed: () {
                  webView.evaluateJavascript(
                      source: 'window.getSelection().removeAllRanges();');
                },
              ),
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