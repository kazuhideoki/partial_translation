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
    final isHome = useProvider(appStateProvider).isHome;
    print('isHomeは $isHome');

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (rawText) {
        searchOnGoogle(rawText, webView);
      },
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
          hintText: isFocused ? null : "Search",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: isFocused == true
              ? FlatButton(
                  onPressed: () => controller.text = '',
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ))
              : null),
    );
  }
}
