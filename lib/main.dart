import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/custom_app_bar.dart';
import 'package:partial_translation/main_web_view.dart';
import 'package:partial_translation/util/load_url_from_clipboard.dart';
import 'package:partial_translation/footer_button_bar.dart';
import 'package:partial_translation/util/oprinal_gesture_detector.dart';
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
    final isScrollDown = useProvider(appStateProvider.state).isScrollDown;
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
        appBar: AppBar(
          // toolbarHeight: isScrollDown ? 0 : 60,
          title: CustomAppBar(
              controller: _controller,
              focusNode: _focusNode,
              isFocused: _isFocused.value),
        ),
        body: Builder(builder: (BuildContext context) {
          // iosでうまくunFocusさせるためのGestureDetector
          return Stack(children: [
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
                  // FooterButtonBar()
                  // Visibility(visible: !isScrollDown, maintainState: false, child: FooterButtonBar()),                  
                ]))),
                Align(alignment: Alignment.bottomCenter, child: Visibility(visible: !isScrollDown, maintainState: false, child: FooterButtonBar())),
            FutureBuilder(
              future: extractUrlsFromClipBoard(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
                        !snapshot.hasData ||
                        snapshot.data.length == 0) return Visibility(visible: false, maintainState: false, child: Text(''));
                final encodedUrls = Uri.encodeFull(snapshot.data[0]);
                return Visibility(
                    visible: _isFocused.value,
                    maintainState: false,
                    child: Container(
                        height: 80,
                        width: double.infinity,
                        child: ListView(children: [
                          SizedBox(
                              child: ListTile(
                            leading: Icon(Icons.content_paste),
                            title: Text('From URL on Clipboard'),
                            subtitle: Text(snapshot.data[0]),
                            tileColor: Colors.white,
                            onTap: () {
                              webView.loadUrl(url: encodedUrls);
                              _focusNode.unfocus();
                              _controller.text = '';
                            },
                          ))
                        ])));
              },
            ),
          ]);
        }));
  }
}
