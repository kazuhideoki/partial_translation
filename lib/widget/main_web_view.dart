import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/util/web_view/context_menu.dart';
import 'package:partial_translation/view_model/app_state.dart';

class MainWebView extends HookWidget {
  MainWebView({Key key, @required this.progress}) : super(key: key);

  double progress;

  @override
  Widget build(BuildContext context) {
    final partialTranslate = useProvider(appStateProvider).partialTranslate;
    final setWebView = useProvider(appStateProvider).setWebView;
    final loadIsSelectParagraph =
        useProvider(appStateProvider).loadIsSelectParagraph;
    final setPageTitle = useProvider(appStateProvider).setPageTitle;
    final setCurrentUrl = useProvider(appStateProvider).setCurrentUrl;
    final isLongTapToTranslate =
        useProvider(appStateProvider.state).isLongTapToTranslate;
    final initialUrl = useProvider(appStateProvider.state).initialUrl;
    final setIsHideAppBar = useProvider(appStateProvider).setIsHideAppBar;

    return InAppWebView(
      initialUrl: initialUrl,
      contextMenu: generateContextMenu(partialTranslate),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        debuggingEnabled: false,
      )),
      onWebViewCreated: (InAppWebViewController controller) async {
        print('onWebViewCreated');
        // ※ ここでローカルストレージの処理ができない？ SecurityError: The operation is insecure. Failed to read the 'localStorage' property from 'Window': Access is denied for this document. になる
        // (対策 実行を遅らせることで安定して処理できるうようになった)
        Future.delayed(const Duration(milliseconds: 10), () async {
          setWebView(controller);
          await loadIsSelectParagraph(controller);

          // 右クリック有効可
          await controller.injectJavascriptFileFromAsset(
              assetFilePath: 'javascript/enableContextMenu.js');
        });

      },
      onLoadStart: (InAppWebViewController controller, String newUrl) async {
        print('onLoadStart');
      },
      onLoadStop: (InAppWebViewController controller, String newUrl) async {
        print('onLoadStop');
        if (isLongTapToTranslate == true) {
          await controller.injectJavascriptFileFromAsset(
              assetFilePath: 'javascript/longTapToTranslateHandler.js');
        }
        await controller.injectJavascriptFileFromAsset(
            assetFilePath: 'javascript/select_paragraph.js');

        final title = await controller.getTitle();
        setPageTitle(title);
        setCurrentUrl(newUrl);
      },
      onProgressChanged: (InAppWebViewController controller, int newProgress) {
        progress = newProgress / 100;
      },
      onScrollChanged: (InAppWebViewController controller, int x, int y) async {
        final firstPosition = await controller.getScrollY();
        Future.delayed(Duration(milliseconds: 100), () async {
          final secondPosition = await controller.getScrollY();

          if (secondPosition > firstPosition) {
            setIsHideAppBar(true);
          } else if (secondPosition < firstPosition) {
            setIsHideAppBar(false);
          }
        });
      },
      onConsoleMessage:
          (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        print("console message: ${consoleMessage.message}");
      },
    );
  }
}
