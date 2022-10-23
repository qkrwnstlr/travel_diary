import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './sign_in_page.dart';
import './map_page.dart';
import './google_directions.dart';
import './swiper_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
        initialRoute: '/swiperPage',
      routes: {
        '/signInPage': (context) => SignInPage(),
        '/mapPage': (context) => MapPage(),
        '/directions': (context) => Direction(),
        '/swiperPage': (context) => SwiperTest(),
      },
    );
  }
}