import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

// 一度変えてみたが動作が不安定だったため戻した
class WebViewContextMenu {
  WebViewContextMenu({@required this.partialTranslate});

  Function partialTranslate;

  get menu => ContextMenu(
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
        print("onContextMenuActionItemClicked");
        var id = (Platform.isAndroid)
            ? contextMenuItemClicked.androidId
            : contextMenuItemClicked.iosId;
        print("onContextMenuActionItemClicked: " +
            id.toString() +
            " " +
            contextMenuItemClicked.title);
      });
}
