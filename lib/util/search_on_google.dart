import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void searchOnGoogle(String rawText, InAppWebViewController controller) {
  var encodedText = Uri.encodeComponent(rawText);
               var texts = encodedText.split(' ');
              var text = texts.join('+');

              controller.loadUrl(
                // wwwに？
                  url: 'https://www.google.com/search?q=${text}');
}