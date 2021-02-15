import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/model/app_state_model.dart';
import 'package:state_notifier/state_notifier.dart';

final appStateProvider = StateNotifierProvider((ref) {
  return AppStateViewModel();
});

class AppStateViewModel extends StateNotifier<AppStateModel> {
  AppStateViewModel() : super(AppStateModel(count: 0));

  void incrementCount() {
    state.count++;
  }
}
