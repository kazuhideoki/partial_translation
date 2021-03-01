import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/model/pt_data.dart';
import 'package:partial_translation/net/connect_local_storage.dart';
import 'package:partial_translation/net/translate_api.dart';
import 'package:partial_translation/util/web_view/partial_translate.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    InAppWebViewController webView,
    ContextMenu contextMenu,
    @Default(0) int count,
    @Default('') String currentUrl,
    @Default(false) bool isLongTapToTranslate,
    @Default(false) bool isSelectParagraph,
  }) = _AppState;
  // factory AppState.fromJson(Map<String, dynamic> json) =>
  //     _$AppStateFromJson(json);
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void setWebView(InAppWebViewController webView) {
    state = state.copyWith(webView: webView);
    print(state.toString());
  }

  void setContextMenu(ContextMenu contextMenu) {
    state = state.copyWith(contextMenu: contextMenu);
    print(state.toString());
  }


  void incrementCount() {
    state = state.copyWith(count: state.count + 1);
  }

  Future<int> getCount() async {
    final webView = state.webView;
    try {
      var count = await ConnectLocalStorage(webView).getCount();
      if (count == null) {
        count = 0;
        await setCount(0);
        return count;
      }
      state = state.copyWith(count: count);
      return count;
    } catch (err) {
      print('AppStateNotifier.getCount: 【ERRROR】 $err');
    }
  }

  Future<void> setCount(int count) async {
    final webView = state.webView;
    try {
      await ConnectLocalStorage(webView).setCount(count);
      state = state.copyWith(count: count);
    } catch (err) {
      print('AppStateNotifier.setCount: 【ERRROR】 $err');
    }
  }

  void partialTranslate() async {
    final webView = state.webView;

    print('partialTranslateのwebViewは $webView');


      await webView.injectJavascriptFileFromAsset(
          assetFilePath: 'javascript/modifyDomBeforeTranslate.js');

      final targetText = await webView.getSelectedText();

      final translatedData = await GoogleTranslateApi().getApi([targetText]);
      if (translatedData == null) return null;

      final translatedText =
          translatedData['translations'][0]['translatedText'] as String;

      var count = await getCount();

      final ptData = PtData(count, targetText, translatedText);

      final value = jsonEncode(ptData);
      print(value);
      await webView.webStorage.localStorage
          .setItem(key: 'ptData$count', value: value);

      await webView.injectJavascriptFileFromAsset(
          assetFilePath: 'javascript/replaceText.js');

      count++;
      setCount(count);
  }
  void setCurrentUrl(String url) {
    state = state.copyWith(currentUrl: url);
  }

  // JSからtranslateByLongTapを呼ぶことで「選択→離す」を感知し、翻訳させる
  void switchLongTapToTranslate(
      InAppWebViewController webView, Function translate) {
    print('switchLongTapToTranslate');
    if (state.isLongTapToTranslate == false) {
      webView.addJavaScriptHandler(
          handlerName: 'translateByLongTap',
          callback: (arg) {
            print('argは $arg');
            translate();
          });
      webView.injectJavascriptFileFromAsset(
          assetFilePath: 'javascript/longTapToTranslateHandler.js');
    } else {
      webView.evaluateJavascript(source: '''
        console.log('evaluateJavascript: detectTouchEnd');
        document.removeEventListener("touchend", detectTouchEnd);
      ''');
      webView.removeJavaScriptHandler(handlerName: 'translateByLongTap');
    }
    state = state.copyWith(isLongTapToTranslate: !state.isLongTapToTranslate);
  }

  Future<void> switchSelectParagraph(InAppWebViewController webView) async {
    print('switchLongTapToTranslate');
    if (state.isSelectParagraph == false) {
      // webView.injectJavascriptFileFromAsset(
      //     assetFilePath: 'javascript/select_paragraph.js');
      await ConnectLocalStorage(webView).setIsSelectParagraph(true);
    } else {
      // webView.evaluateJavascript(source: '''
      //   console.log('evaluateJavascript: selectParagraph');
      //   document.removeEventListener("touchstart", selectParagraph, true);
      // ''');
      await ConnectLocalStorage(webView).setIsSelectParagraph(false);
    }
    state = state.copyWith(isSelectParagraph: !state.isSelectParagraph);
  }
}

final appStateProvider = StateNotifierProvider((ref) {
  return AppStateNotifier();
});
