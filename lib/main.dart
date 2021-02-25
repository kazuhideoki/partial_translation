import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/common/context_menu.dart';
import 'package:partial_translation/net/connect_local_storage.dart';
import 'dart:io';
import 'dart:convert';
import 'package:partial_translation/net/translate_api.dart';
import 'package:partial_translation/model/pt_data.dart';
import 'package:partial_translation/footer_button_bar.dart';
import 'package:partial_translation/view_model/app_state.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: '.env');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    // final searchBarUrl = useState('');
    final searchBarTextEdittingController = useState(TextEditingController());
    final searchBarForcusNode = useState(FocusNode());
    final url = useState('');
    final progress = useState(0.1 as double); // 0でうまく出来なかった

    final getCount = useProvider(appStateProvider).getCount;
    final setCount = useProvider(appStateProvider).setCount;
    final isLongTapToTranslate =
        useProvider(appStateProvider.state).isLongTapToTranslate;
    final isSelectParagraph =
        useProvider(appStateProvider.state).isSelectParagraph;

    void partialTranslate() async {
      print('partialTranslateのwebViewは $webView');

      await webView.injectJavascriptFileFromAsset(
          assetFilePath: 'javascript/modifyDomBeforeTranslate.js');

      final targetText = await webView.getSelectedText();

      final translatedData = await GoogleTranslateApi().getApi([targetText]);
      if (translatedData == null) return null;

      final translatedText =
          translatedData['translations'][0]['translatedText'] as String;

      var count = await getCount(webView);

      final ptData = PtData(count, targetText, translatedText);

      final value = jsonEncode(ptData);
      print(value);
      await webView.webStorage.localStorage
          .setItem(key: 'ptData$count', value: value);

      await webView.injectJavascriptFileFromAsset(
          assetFilePath: 'javascript/replaceText.js');

      count++;
      setCount(webView, count);
    }

    // 一度まとめてクラスに書き変えてみたが動作が不安定だったため戻した
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
          title: TextField(
            controller: searchBarTextEdittingController.value,
            focusNode: searchBarForcusNode.value,
            onSubmitted: (text) {
              webView.loadUrl(
                  url: 'https://google.com/search?q=$text'); //  よくおちる
            },
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: searchBarForcusNode.value.hasFocus
                    ? FlatButton(
                        onPressed: () =>
                            searchBarTextEdittingController.value.text = '',
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ))
                    : null),
          ),
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
                  debuggingEnabled: false,
                )),
                onWebViewCreated: (InAppWebViewController controller) async {
                  print('onWebViewCreated');
                  webView = controller;

                  // 右クリックができないページに出くわしたときに試す
                  controller.injectJavascriptFileFromAsset(
                      assetFilePath: 'javascript/enableContextMenu.js');

                  // ※ ここでローカルストレージの処理ができない？ SecurityError: The operation is insecure. Failed to read the 'localStorage' property from 'Window': Access is denied for this document. になる

                  String textData = await Clipboard.getData('text/plain')
                      .then((value) => value.text);
                  final regExp =
                      RegExp(r"https?://[\w!?/+\-_~;.,*&@#$%()'[\]]+");
                  final texts = textData.split(' ');
                  final urls = texts.where((text) => text.contains(regExp)).toList();
                  if (urls.length != 0) {
                    print('urls.contains(regExp)!!!');

                    controller.loadUrl(url: urls[0]);
                  }
                },
                onLoadStart:
                    (InAppWebViewController controller, String newUrl) {
                  print('onLoadStart');
                  url.value = newUrl;
                },
                onLoadStop:
                    (InAppWebViewController controller, String newUrl) async {
                  print('onLoadStop');
                  if (isLongTapToTranslate == true) {
                    controller.injectJavascriptFileFromAsset(
                        assetFilePath:
                            'javascript/longTapToTranslateHandler.js');
                  }
                  controller.injectJavascriptFileFromAsset(
                      assetFilePath: 'javascript/select_paragraph.js');

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
            webView: webView,
            url: url.value,
            partialTranslate: partialTranslate,
          )
        ])),
      ),
    );
  }
}
