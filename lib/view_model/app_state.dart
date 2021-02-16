import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/net/connect_local_storage.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({
    @Default(0) int count,
    @Default(false) bool longTapToTranslate,
  }) = _AppState;
  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState(count: 0));

  void incrementCount() {
    state = state.copyWith(count: state.count + 1);
  }

  Future<int> getCount(InAppWebViewController webView) async {
    try {
      var count = await ConnectLocalStorage(webView).getCount();
      if (count == null) {
        count = 0;
        await setCount(webView, 0);
        return count;
      }
      state = state.copyWith(count: count);
      return count;
    } catch (err) {
      print('AppStateNotifier.getCount: 【ERRROR】 $err');
    }
  }

  Future<void> setCount(InAppWebViewController webView, int count) async {
    try {
      await ConnectLocalStorage(webView).setCount(count);
      state = state.copyWith(count: count);
    } catch (err) {
      print('AppStateNotifier.setCount: 【ERRROR】 $err');
    }
  }

  // JSからtranslateByLongTapを呼ぶことで「選択→離す」を感知し、翻訳させる
  void switchLongTapToTranslate(
      InAppWebViewController webView, Function translate) {
    print('switchLongTapToTranslate');
    if (state.longTapToTranslate == false) {
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
    state = state.copyWith(longTapToTranslate: !state.longTapToTranslate);
  }
}

final appStateProvider = StateNotifierProvider((ref) {
  return AppStateNotifier();
});
