import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/custom_app_bar.dart';
import 'package:partial_translation/main_web_view.dart';
import 'package:partial_translation/footer_button_bar.dart';
import 'package:partial_translation/util/oprinal_gesture_detector.dart';
import 'package:partial_translation/util/web_view/lifecycle_manager.dart';
import 'package:partial_translation/view_model/app_state.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load(fileName: '.env');
  runApp(ProviderScope(
      child: MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  )));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final webView = useProvider(appStateProvider.state).webView;
    final isHideAppBar = useProvider(appStateProvider.state).isHideAppBar;
    final _controller = useTextEditingController();
    final _focusNode = useFocusNode();
    final _isFocused = useState(false);
    void _handleFocusChange() {
      if (_focusNode.hasFocus != _isFocused) {
        _isFocused.value = _focusNode.hasFocus;
      }
    }

    if (_focusNode.hasListeners == false) {
      _focusNode.addListener(_handleFocusChange);
    }

    final progress = useState(0.0 as double);

    return Scaffold(
        body: SafeArea(child: Builder(builder: (BuildContext context) {
      final _lifecycleCallback =
          LifecycleCallback(context: context, controller: webView);
      // iosでうまくunFocusさせるためのGestureDetector
      return LifecycleManager(
          callback: _lifecycleCallback,
          child: Stack(children: [
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
                      child: MainWebView(
                        progress: progress.value,
                      ),
                    ),
                  ),
                ]))),
            Visibility(
                visible: !isHideAppBar,
                maintainState: false,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: CustomAppBar(
                          controller: _controller,
                          focusNode: _focusNode,
                          isFocused: _isFocused.value),
                    ),
                  ],
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                    visible: !isHideAppBar,
                    maintainState: false,
                    child: FooterButtonBar())),
          ]));
    })));
  }
}
