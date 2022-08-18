import 'dart:convert';
import 'package:http/http.dart';

class Translate {
  Map<String, String> languageCodes = {"English": "en", "Spanish": "es", "French": "fr", "Japanese": "ja"};

  Future<String> translate(
      {required String text,
      required String languageFrom,
      required String languageTo,
      bool transliterate = false}) async {
    final response = await post(Uri.parse("https://flutternodejsbackend.azurewebsites.net/translate"),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'text': text,
          'languageFrom': languageCodes[languageFrom],
          'languageTo': languageCodes[languageTo],
          'transliterate': transliterate
        }));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to translate");
    }
  }
}
