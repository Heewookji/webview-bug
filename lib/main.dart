import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_bug/edit_page.dart';
import 'package:webview_bug/read_case_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: ReadCasePage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case ReadCasePage.routeName:
            return ReadCasePage.generateRoute(settings);
          case EditPage.routeName:
            return EditPage.generateRoute(settings);
        }
      },
    );
  }
}
