import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/util/load_url_from_clipboard.dart';
import 'package:partial_translation/net/translate_api.dart';
import 'package:partial_translation/model/pt_data.dart';
import 'package:partial_translation/footer_button_bar.dart';
import 'package:partial_translation/util/oprinal_gesture_detector.dart';
import 'package:partial_translation/util/search_on_google.dart';
import 'package:partial_translation/util/web_view/context_menu.dart';
import 'package:partial_translation/util/web_view/partial_translate.dart';
import 'package:partial_translation/view_model/app_state.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: '.env');
  runApp(ProviderScope(child: MaterialApp(home: MyApp())));
}

class MyApp extends HookWidget {
  // InAppWebViewController webView;
  @override
  Widget build(BuildContext context) {
    var webView = useProvider(appStateProvider.state).webView;
    print('mainのwebViewは ' + webView.toString());
    final setWebView = useProvider(appStateProvider).setWebView;
    final partialTranslate = useProvider(appStateProvider).partialTranslate;

    // final webView = webviewData;

    final _controller = useTextEditingController();
    final _focusNode = useFocusNode();
    print('フォーカスノードは' + _focusNode.hasFocus.toString());
    final _isFocused = useState(false);
    print('_isFocusedは' + _isFocused.value.toString());
    void _handleFocusChange() {
      if (_focusNode.hasFocus != _isFocused) {
        _isFocused.value = _focusNode.hasFocus;
      }
    }

    if (_focusNode.hasListeners == false) {
      _focusNode.addListener(_handleFocusChange);
    }

    final progress = useState(0.1 as double); // 0でうまく出来なかった
    // final currentUrl = useState('');
    final currentUrl = useProvider(appStateProvider.state).currentUrl;
    final setCurrentUrl = useProvider(appStateProvider).setCurrentUrl;
    final getCount = useProvider(appStateProvider).getCount;
    final setCount = useProvider(appStateProvider).setCount;
    final isLongTapToTranslate =
        useProvider(appStateProvider.state).isLongTapToTranslate;
    final isSelectParagraph =
        useProvider(appStateProvider.state).isSelectParagraph;

    const toolBarHeight = 150.0;

    // final contextMenu =
    //     generateContextMenu(() => partialTranslate(webView, getCount, setCount));

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            focusNode: _focusNode,
            onSubmitted: (rawText) {
              searchOnGoogle(rawText, webView);
            },
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                hintText: _isFocused.value ? null : "Search",
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: _isFocused.value == true
                    ? FlatButton(
                        onPressed: () => _controller.text = '',
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ))
                    : null),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          // iosでうまくunFocusさせるためのGestureDetector
          return Stack(children: [
            // android実機で選択ができなくなってしまったので、focusあたってないときはGestureDetectorをオフにして回避
            OptionalGestureDetector(
                focusNode: _focusNode,
                isFocused: _isFocused.value,
                child: Container(
                    child: Column(children: <Widget>[
                  Container(
                      child: progress.value < 1.0
                          ? LinearProgressIndicator(value: progress.value)
                          : Container()),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: InAppWebView(
                        initialUrl: "https://google.com",
                        contextMenu:
                            generateContextMenu(partialTranslate),
                        initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: false,
                        )),
                        onWebViewCreated:
                            (InAppWebViewController controller) async {
                          print('onWebViewCreated');
                          // webView = controller;
                          setWebView(controller);

                          // 右クリック有効可
                          controller.injectJavascriptFileFromAsset(
                              assetFilePath: 'javascript/enableContextMenu.js');

                          // ※ ここでローカルストレージの処理ができない？ SecurityError: The operation is insecure. Failed to read the 'localStorage' property from 'Window': Access is denied for this document. になる

                          final urls = await extractUrlsFromClipBoard();
                          if (urls.length != 0) {
                            showSnackBarJumpUrl(context, controller, urls);
                          }
                        },
                        onLoadStart:
                            (InAppWebViewController controller, String newUrl) {
                          print('onLoadStart');
                          setCurrentUrl(newUrl);
                        },
                        onLoadStop: (InAppWebViewController controller,
                            String newUrl) async {
                          print('onLoadStop');
                          if (isLongTapToTranslate == true) {
                            controller.injectJavascriptFileFromAsset(
                                assetFilePath:
                                    'javascript/longTapToTranslateHandler.js');
                          }
                          controller.injectJavascriptFileFromAsset(
                              assetFilePath: 'javascript/select_paragraph.js');

                          // currentUrl.value = newUrl;
                        },
                        onProgressChanged: (InAppWebViewController controller,
                            int newProgress) {
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
                    url: currentUrl,
                    partialTranslate: partialTranslate,
                  )
                ]))),
            SizedBox(
              height: 80.0,
              width: double.infinity,
              child: FutureBuilder(
                future: extractUrlsFromClipBoard(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // if (snapshot.connectionState != ConnectionState.done)
                  //   return LinearProgressIndicator(value: null);
                  // if (snapshot.hasData == false) return Text('Error occurred');
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data.length != 0 &&
                      _isFocused.value) {
                    final encodedUrls = Uri.encodeFull(snapshot.data[0]);
                    return ListView(children: [
                      SizedBox(
                          child: ListTile(
                        leading: Icon(Icons.content_paste),
                        title: Text('From URL on Clipboard'),
                        subtitle: Text(snapshot.data[0]),
                        tileColor: Colors.white,
                        onTap: () {
                          webView.loadUrl(url: encodedUrls);
                          _focusNode.unfocus();
                        },
                      ))
                    ]);
                  }
                  return ListView(
                    children: [ListTile(title: Text(''))],
                  );
                },
              ),
            ),
          ]);
        }));
  }
}
