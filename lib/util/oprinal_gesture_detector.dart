import 'package:flutter/material.dart';

class OptinalGestureDetector extends StatelessWidget {
  const OptinalGestureDetector({Key key, @required this.focusNode, @required this.isFocused, @required this.child})
      : super(key: key);

  final focusNode;
  final isFocused;
  final child;

  @override
  Widget build(BuildContext context) {
    if (isFocused == true) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            focusNode.unfocus();
          },
          onTapCancel: () {
            focusNode.unfocus();
          },
          child: child);
    }
    return Container(
      child: child,
    );
  }
}
