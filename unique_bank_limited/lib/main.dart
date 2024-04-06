import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unique_bank_limited/screen/login_page.dart';
import 'package:unique_bank_limited/screen/splash_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyAUm0GZwxD5FOYiPA1qR-_gwsSf8ibXFEQ", appId: "1:982066130547:web:9dc6ba342de51767fe8406", messagingSenderId: "982066130547", projectId: "bankingmanagementsystem-1bdcf"));
  }

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(
        child: LoginPage(),
      )
    );
  }
}
