import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/util/load_url_from_clipboard.dart';
import 'package:partial_translation/view_model/app_state.dart';


class CopiedUrlSuggestedList extends HookWidget {
  CopiedUrlSuggestedList({Key key, @required this.controller, @required this.focusNode, @required this.isFocused}) : super(key: key);

  bool isFocused;
  TextEditingController controller;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final webView = useProvider(appStateProvider.state).webView;

    return Container(
      child: FutureBuilder(
              future: extractUrlsFromClipBoard(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
                    !snapshot.hasData ||
                    snapshot.data.length == 0)
                  return Visibility(
                      visible: false, maintainState: false, child: Text(''));
                final encodedUrls = Uri.encodeFull(snapshot.data[0]);
                return Visibility(
                    visible: isFocused,
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
                              focusNode.unfocus();
                              controller?.text = '';
                            },
                          ))
                        ])));
              },
            ),
    );
  }
}