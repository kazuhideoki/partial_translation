import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends HookWidget {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    // final useState
    final url = useState('');
    final progress = useState(0.1 as double); // 0でうまく出来なかった

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              "CURRENT URL\n${url.value}"),
        ),
        body: Container(
            child: Column(children: <Widget>[
          Container(
              child: progress.value < 1.0
                  ? LinearProgressIndicator(value: progress.value)
                  : Container()),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: InAppWebView(
                initialUrl: "https://flutter.dev/",
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  webView = controller;
                },
                onLoadStart:
                    (InAppWebViewController controller, String newUrl) {
                  url.value = newUrl;
                },
                onLoadStop:
                    (InAppWebViewController controller, String newUrl) async {
                  url.value = newUrl;
                },
                onProgressChanged:
                    (InAppWebViewController controller, int newProgress) {
                    progress.value = newProgress / 100;
                },
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
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
            ],
          ),
        ])),
      ),
    );
  }
}
