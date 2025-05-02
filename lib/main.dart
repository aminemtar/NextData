import 'package:android_flutter_test/ViewModel/auth_view_model.dart';
import 'package:android_flutter_test/ViewModel/post_view_model.dart';
import 'package:android_flutter_test/Views/login_screen.dart';
import 'package:android_flutter_test/Views/posts_list_screen.dart';
import 'package:android_flutter_test/Views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColorLight: Colors.grey),
      home: SplashScreen(),
      routes: {
        '/home': (context) => PostListScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
