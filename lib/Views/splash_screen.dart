import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../ViewModel/auth_view_model.dart';
import '../Views/login_screen.dart';
import '../Views/posts_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  void _checkTokenAndNavigate() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final hasToken = await authViewModel.hasValidToken();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => hasToken ? const PostListScreen() : LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1864D3), Color(0xFF0C4AA6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: SvgPicture.asset(
                'assets/images/nextdata-logo-blanc.svg',
                width: 221.76,
                height: 112.15,
              ),
            ),
            const SizedBox(height: 41),
            const Padding(
              padding: EdgeInsets.only(bottom: 60.0),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
