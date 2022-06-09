import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future _navigateToHome;
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    _navigateToHome = Future.delayed(
      const Duration(seconds: 2),
      () => _navigator.pushNamedAndRemoveUntil(
        MyHomePage.routeName,
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _navigateToHome,
        builder: (context, snapshot) {
          return MaterialApp(
            initialRoute: SplashPage.routeName,
            navigatorKey: _navigatorKey,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case SplashPage.routeName:
                  return MaterialPageRoute(
                    builder: (_) => const SplashPage(),
                    settings: settings,
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const MyHomePage(),
                    settings: settings,
                  );
              }
            },
          );
        });
  }
}

class SplashPage extends StatelessWidget {
  static const String routeName = '/splash';
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.redAccent,
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String routeName = '/home';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          WebView(initialUrl: 'https://flutter.dev/'),
          WebView(initialUrl: 'https://flutter.dev/'),
          WebView(initialUrl: 'https://flutter.dev/'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          pageController.jumpToPage(index);
        },
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '1',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: '2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '3',
          ),
        ],
      ),
    );
  }
}
