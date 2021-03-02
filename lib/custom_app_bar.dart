import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:partial_translation/util/search_on_google.dart';
import 'package:partial_translation/view_model/app_state.dart';

class CustomAppBar extends HookWidget {
  CustomAppBar(
      {Key key,
      @required this.controller,
      @required this.focusNode,
      @required this.isFocused})
      : super(key: key);

  TextEditingController controller;
  FocusNode focusNode;
  bool isFocused;

  @override
  Widget build(BuildContext context) {
    final webView = useProvider(appStateProvider.state).webView;
    final pageTitle = useProvider(appStateProvider.state).pageTitle;
    final currentUrl = useProvider(appStateProvider.state).currentUrl;
    final isHome = useProvider(appStateProvider).isHome;

    return Column(children: [
      Visibility(
        visible: isFocused,
        maintainState: true,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onSubmitted: (rawText) {
            searchOnGoogle(rawText, webView);
          },
          style: TextStyle(fontSize: 18),
          decoration: InputDecoration(
              hintText: isFocused ? null : "Search",
              prefixIcon: isFocused
                  ? Icon(
                      Icons.search,
                      color: Colors.white,
                    )
                  : null,
              suffixIcon: isFocused == true
                  ? FlatButton(
                      onPressed: () {
                        controller.text = '';
                        focusNode.unfocus();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                  : null),
        ),
      ),
      Visibility(
          visible: !isFocused,
          maintainState: true,
          child: ListTile(
            title: Text(pageTitle),
            onTap: () => focusNode.requestFocus()))
    ]);
  }
}
