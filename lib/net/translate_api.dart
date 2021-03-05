import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleTranslateApi {
  Future getApi(List<String> texts) async {
    final projectId = env['PROJECT_ID'];
    final dio = new Dio();
    final url =
        'https://translation.googleapis.com/v3/projects/$projectId:translateText';

    final _credentialJson =
        await rootBundle.loadString("json/partial-translation-secret.json");
    final accountCredentials =
        new ServiceAccountCredentials.fromJson(_credentialJson);
    const _SCOPES = ['https://www.googleapis.com/auth/cloud-translation'];

    final client =
        await clientViaServiceAccount(accountCredentials, _SCOPES);

      try {
        final response = await dio.post(url,
            options: Options(
              headers: {
                "Authorization":
                    "Bearer ${client.credentials.accessToken.data}",
                'Content-Type': 'application/json',
              },
            ),
            data: {
              "sourceLanguageCode": "en",
              "targetLanguageCode": "ja",
              "contents": texts,
            });
        return response.data;
      } catch (err) {
        print('GoogleTranslateApi.getApi: 【error】 $err');
      }
  }
}
