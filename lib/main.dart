import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'dart:convert';
import 'package:partial_translation/apis/translate.dart';
import 'package:partial_translation/model/pt_data.dart';
import 'package:partial_translation/footer_button_bar.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends HookWidget {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    final webViewState = useState(null as InAppWebViewController);
    final url = useState('');
    final progress = useState(0.1 as double); // 0でうまく出来なかった

    void partialTranslate() async {
      final webView = webViewState.value;

      TargetData targetData;
      try {
        await webView.injectJavascriptFileFromAsset(
            assetFilePath: 'javascript/modigyDomBeforeTranslate.js');

        // final targetDataJson =
        //     await webView.webStorage.localStorage.getItem(key: 'targetData');
        // targetData = TargetData.fromJson(targetDataJson);
      } catch (e) {
        print('mainのcatch error');
        // targetData = TargetData(await webView.getSelectedText(), true);
      }

      // if (targetData.isTranslating == false) return null;

      // final targetText = await webView.evaluateJavascript(
      //     source: "document.getElementById('translating_target').innerHTML");
      final targetText = await webView.getSelectedText();

      final translatedData = await GoogleTranslateApi().getApi([targetText]);
      if (translatedData == null) return null;

      final translatedText =
          translatedData['translations'][0]['translatedText'] as String;

      var count = await webView.webStorage.localStorage.getItem(key: 'count');
      if (count == null) {
        count = 0;
        webView.webStorage.localStorage.setItem(key: 'count', value: 0);
      }
      final ptData = PtData(count, targetText, translatedText);

      final value = jsonEncode(ptData);
      print(value);
      await webView.webStorage.localStorage
          .setItem(key: 'ptData$count', value: value);

      await webView.injectJavascriptFileFromAsset(
          assetFilePath: 'javascript/replaceText.js');

      count++;
      webView.webStorage.localStorage.setItem(key: 'count', value: count);
    }

    final contextMenu = ContextMenu(
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: true),
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: '翻訳',
              action: () {
                partialTranslate();
              })
        ],
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
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
                initialUrl: "https://google.com",
                contextMenu: contextMenu,
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                )),
                onWebViewCreated: (InAppWebViewController controller) {
                  webViewState.value = controller;
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
                onConsoleMessage: (InAppWebViewController controller,
                    ConsoleMessage consoleMessage) {
                  print("console message: ${consoleMessage.message}");
                },
              ),
            ),
          ),
          FooterButtonBar(
            webView: webViewState.value,
            url: url.value,
          )
        ])),
      ),
    );
  }
}
