import 'package:deardiaryv2/features/auth/presentation/providers/auth_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/status/auth_status.dart';
import 'package:deardiaryv2/features/diary/presentation/screens/home.dart';
import 'package:deardiaryv2/features/auth/presentation/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    var authpro = context.read<AuthProvider>();
    authpro.checkAuthStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (_, authpro, _){
          switch (authpro.status) {
            case AuthStatus.unknown:
              return Center(child: CircularProgressIndicator());
            case AuthStatus.authenticated:
              return HomeScreen();
            case AuthStatus.unauthenticated: 
              return LoginScreen(); 
          }
        },
      ),
    );
  }
}
