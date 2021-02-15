import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:googleapis/androidenterprise/v1.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState({@Default(0) int count}) = _AppState;
  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState(count: 0));

  void incrementCount() {
    state = state.copyWith(count: state.count + 1);
  }
}

final appStateProvider = StateNotifierProvider((ref) {
  return AppStateNotifier();
});
