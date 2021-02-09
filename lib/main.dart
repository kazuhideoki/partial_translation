import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:partial_translation/apis/translate.dart';
import 'dart:io';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends HookWidget {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    final url = useState('');
    final progress = useState(0.1 as double); // 0でうまく出来なかった
    final selectedPart = useState('');
    final translatedPart = useState('');
    void partialTranslate() async {
      final text = await webView.getSelectedText();
      selectedPart.value = text;
      final translatedData = await GoogleTranslateApi().getApi([text]);
      print('★translatedDataは $translatedData');
      if (translatedData != null) {
        translatedPart.value =
            translatedData['translations'][0]['translatedText'];
        print(translatedPart.value);
      }
    }
    final contextMenu = ContextMenu(
      options: ContextMenuOptions(hideDefaultSystemContextMenuItems: true),
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Partial Translate",
              action: () => partialTranslate(),
              )
        ],
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webView.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " +
              id.toString() +
              " " +
              contextMenuItemClicked.title);
        });

    

    

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CURRENT URL\n${url.value}"),
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
                contextMenu: contextMenu,
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
              RaisedButton(
                child: Icon(Icons.translate),
                onPressed: () => partialTranslate(),
              ),
            ],
          ),
          Container(
            child: Text('${selectedPart.value}の意味は「${translatedPart.value}」'),
          )
        ])),
      ),
    );
  }
}
