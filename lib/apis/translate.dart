import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/dfareporting/v3_4.dart';
import 'package:googleapis/translate/v3.dart';
import 'package:process_run/shell.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/translate/v3.dart' as translateV3;
import 'package:googleapis_auth/auth_io.dart' as auth;
import "package:http/http.dart" as http;

class GoogleTranslateApi {
  Future<Map<String, dynamic>> getApi(List<String> words) async {
    final projectId = env['PROJECT_ID'];
    final dio = new Dio();
    final url =
        'https://translation.googleapis.com/v3/projects/$projectId:translateText';
    try {
      final response = await dio.post(url,
          options: Options(
            headers: {
              "Authorization":
                  // "Bearer ${shell.run('''gcloud auth application-default print-access-token''')}"
                  "Bearer ${env['GCP_TRANSLATE_ACCESS_TOKEN']}",
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "sourceLanguageCode": "en",
            "targetLanguageCode": "ja",
            "contents": words,
          });
      return response.data;
    } catch (err) {
      print('エラーは $err');
    }
  }
}
