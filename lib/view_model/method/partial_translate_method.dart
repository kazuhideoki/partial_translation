import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:partial_translation/model/pt_data.dart';
import 'package:partial_translation/net/translate_api.dart';

void partialTranslateMethod(InAppWebViewController webView, getCount, setCount) async {
  print('partialTranslateのwebViewは $webView');

    await webView.injectJavascriptFileFromAsset(
        assetFilePath: 'javascript/modifyDomBeforeTranslate.js');

    final targetText = await webView.getSelectedText();

    final translatedData = await GoogleTranslateApi().getApi([targetText]);
    if (translatedData == null) return null;

    final translatedText =
        translatedData['translations'][0]['translatedText'] as String;

    var count = await getCount();

    final ptData = PtData(count, targetText, translatedText);

    final value = jsonEncode(ptData);
    await webView.webStorage.localStorage
        .setItem(key: 'ptData$count', value: value);

    await webView.injectJavascriptFileFromAsset(
        assetFilePath: 'javascript/replaceText.js');

    count++;
    setCount(count);
}