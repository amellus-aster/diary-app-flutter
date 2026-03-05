import 'package:deardiaryv2/features/auth/presentation/providers/auth_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool obscureText = true;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Lottie.asset(
              './../../../../assets/lottie/Welcome.json',
              width: size.height * 0.3,
              height: size.height * 0.3,
              fit: BoxFit.contain,
              repeat: false,
            ),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: size.height * 0.02),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextField(
              obscureText: obscureText,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 50),
            Consumer<LoginProvider>(
              builder: (_, formpro, __) {
                return SizedBox(
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      await formpro.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                      context.read<AuthProvider>().checkAuthStatus();
                    },
                    child: formpro.status == LoginStatus.loading
                        ? Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "LOGIN",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                );
              },
            ),
            Consumer<LoginProvider>(
              builder: (_, formpro, __) {
                return formpro.status == LoginStatus.error
                    ? Text(formpro.errorMessage ?? "")
                    : Text("");
              },
            ),
            SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.5),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(
                    " Sign up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
