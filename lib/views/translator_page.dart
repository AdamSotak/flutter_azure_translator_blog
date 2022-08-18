import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_azure_translator/translate/translate.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({Key? key}) : super(key: key);

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  final TextEditingController translateTextEditingController = TextEditingController();
  String languageFrom = "English";
  String languageTo = "Spanish";
  String translation = "";
  bool detectLanguage = false;
  bool transliterate = false;

  List<String> languages = Translate().languageCodes.keys.toList();

  void setTranslateFromLanguage(String language) {
    setState(() {
      languageFrom = language;
    });
    Navigator.of(context).pop();
  }

  void setTranslateToLanguage(String language) {
    setState(() {
      languageTo = language;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    void chooseTranslateFromLanguage() {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            height: 250.0,
            child: Center(
              child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(languages[index]),
                      onTap: () {
                        setTranslateFromLanguage(languages[index]);
                      },
                    );
                  }),
            ),
          );
        },
      );
    }

    void chooseTranslateToLanguage() {
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            height: 250.0,
            child: Center(
              child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(languages[index]),
                      onTap: () {
                        setTranslateToLanguage(languages[index]);
                      },
                    );
                  }),
            ),
          );
        },
      );
    }

    void translate() {
      setState(() {
        translation = "Pending...";
      });
      Translate()
          .translate(
              text: translateTextEditingController.text,
              languageFrom: (detectLanguage) ? "" : languageFrom,
              languageTo: languageTo,
              transliterate: transliterate)
          .then(
        (value) {
          setState(() {
            translation = value;
          });
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Azure Translator"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Translate from:",
                  style: Theme.of(context).textTheme.headline1,
                ),
                ElevatedButton(
                    onPressed: (detectLanguage) ? null : chooseTranslateFromLanguage,
                    child: (detectLanguage) ? const Text("Language: Detect") : Text("Language: $languageFrom")),
                const Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Translate to:",
                  style: Theme.of(context).textTheme.headline1,
                ),
                ElevatedButton(onPressed: chooseTranslateToLanguage, child: Text("Language: $languageTo")),
                const Padding(padding: EdgeInsets.all(10.0)),
                TextField(
                  controller: translateTextEditingController,
                  decoration: const InputDecoration(hintText: "Text"),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                Row(
                  children: [
                    Checkbox(
                        value: transliterate,
                        onChanged: (value) {
                          setState(() {
                            transliterate = value!;
                          });
                        }),
                    const Text("Transliterate")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: detectLanguage,
                        onChanged: (value) {
                          setState(() {
                            detectLanguage = value!;
                          });
                        }),
                    const Text("Detect Source Language")
                  ],
                ),
                ElevatedButton(onPressed: translate, child: const Text("Translate")),
                const Padding(padding: EdgeInsets.all(10.0)),
                Text(
                  "Translation: ${(translation == "Pending..." || translation == "") ? translation : jsonDecode(translation)[0]["translations"][0]["text"]}",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text("Translation JSON: $translation")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
