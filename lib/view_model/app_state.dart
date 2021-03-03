import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/net/connect_local_storage.dart';
import 'package:partial_translation/view_model/method/partial_translate_method.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    InAppWebViewController webView,
    @Default(0) int count,
    @Default('') String pageTitle,
    @Default('') String currentUrl,
    @Default("https://www.google.com/") String initialUrl,
    @Default('') String searchKeyword,
    // isFocusedだけappStateに移すとうまく動作しない
    // @Default(false) bool isFocused,
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
    partialTranslateMethod(webView, getCount, setCount);
  }

  void setPageTitle(String value) {
    state = state.copyWith(pageTitle: value);
  }

  void setCurrentUrl(String url) {
    state = state.copyWith(currentUrl: url);
  }

  get isHome => state.currentUrl == state.initialUrl;

  void setSearchKeyword(String value) {
    state = state.copyWith(currentUrl: value);
  }

  // JSからtranslateByLongTapを呼ぶことで「選択→離す」を感知し、翻訳させる
  void switchLongTapToTranslate(
      InAppWebViewController webView, Function translate) {
    print('switchLongTapToTranslate');
    if (state.isLongTapToTranslate == false) {
      webView.addJavaScriptHandler(
          handlerName: 'translateByLongTap',
          callback: (arg) {
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

  Future<bool> loadIsSelectParagraph(InAppWebViewController webView) async {
    final localStorage = ConnectLocalStorage(webView);
    final value = await localStorage.getIsSelectParagraph();
    if (value == null) {
      // 値がない場合は初期化
      await localStorage.setIsSelectParagraph(false);
      setIsSelectParagraph(false);
    } else {
      setIsSelectParagraph(value);
    }
  }

  Future<void> setIsSelectParagraph(bool value) {
    state = state.copyWith(isSelectParagraph: value);
  }

  Future<void> switchSelectParagraph() async {
    print('switchSelectParagraph');
    final switched = state.isSelectParagraph ? false : true;
    await ConnectLocalStorage(state.webView).setIsSelectParagraph(switched);
    state = state.copyWith(isSelectParagraph: switched);
  }
}

final appStateProvider = StateNotifierProvider((ref) {
  return AppStateNotifier();
});
