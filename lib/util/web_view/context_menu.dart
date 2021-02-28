import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

final webViewContextMenu = (Function partialTranslate) => ContextMenu(
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
