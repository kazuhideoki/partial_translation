import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/util/load_url_from_clipboard.dart';
import 'package:partial_translation/util/web_view/context_menu.dart';
import 'package:partial_translation/view_model/app_state.dart';

class MainWebView extends HookWidget {
  MainWebView({Key key, @required this.progress}) : super(key: key);

  double progress;

  @override
  Widget build(BuildContext context) {
    final partialTranslate = useProvider(appStateProvider).partialTranslate;
    final setWebView = useProvider(appStateProvider).setWebView;
    final setPageTitle = useProvider(appStateProvider).setPageTitle;
    final setCurrentUrl = useProvider(appStateProvider).setCurrentUrl;
    final isLongTapToTranslate =
        useProvider(appStateProvider.state).isLongTapToTranslate;
    final initialUrl = useProvider(appStateProvider.state).initialUrl;

    return InAppWebView(
      initialUrl: initialUrl,
      contextMenu: generateContextMenu(partialTranslate),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        debuggingEnabled: false,
      )),
      onWebViewCreated: (InAppWebViewController controller) async {
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
      onLoadStart: (InAppWebViewController controller, String newUrl) async {
        print('onLoadStart');
        print('setCurrentUrl $newUrl');
      },
      onLoadStop: (InAppWebViewController controller, String newUrl) async {
        print('onLoadStop');
        if (isLongTapToTranslate == true) {
          controller.injectJavascriptFileFromAsset(
              assetFilePath: 'javascript/longTapToTranslateHandler.js');
        }
        controller.injectJavascriptFileFromAsset(
            assetFilePath: 'javascript/select_paragraph.js');

        final title = await controller.getTitle();
        setPageTitle(title);
        setCurrentUrl(newUrl);
      },
      onProgressChanged: (InAppWebViewController controller, int newProgress) {
        progress = newProgress / 100;
      },
      onConsoleMessage:
          (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        print("console message: ${consoleMessage.message}");
      },
    );
  }
}
