import 'package:flutter/material.dart';

class OptionalGestureDetector extends StatelessWidget {
  const OptionalGestureDetector(
      {Key key,
      @required this.focusNode,
      @required this.isFocused,
      @required this.child})
      : super(key: key);

  final FocusNode focusNode;
  final bool isFocused;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: isFocused ? () => focusNode.unfocus() : null,
        onTapCancel: isFocused ? () => focusNode.unfocus() : null,
        child: child);
  }
}
