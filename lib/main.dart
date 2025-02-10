import 'package:bawabba/ui/screens/police_login_screen.dart';
import 'package:bawabba/ui/widgets/side_menu2.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bawabba/core/services/auth_provider.dart';
import 'dart:convert';
import 'package:bawabba/ui/screens/home_page.dart';
import 'package:bawabba/ui/screens/army_login_page.dart';

import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Set the minimum window size here
  //windowManager.setMinimumSize(const Size(1500, 720));
  //windowManager.setMaximumSize(const Size(1600, 820));
  // Fullscreen on startup
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setFullScreen(true);
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(), // Create the AuthProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        locale: const Locale('ar'), // Set default locale to Arabic
        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Bawabba',
        theme: ThemeData(
          fontFamily: 'Times New Roman',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.token == null
                //? const LoginScreenPolice()
                ? const LoginScreenArmy()
                : const MyHomePage(); // Show login or home based on token
          },
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: <Widget>[
          SideMenu2(),
          MainContent(),
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
