import 'package:deardiaryv2/features/auth/presentation/providers/auth_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/providers/register_provider.dart';
import 'package:deardiaryv2/features/auth/presentation/status/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 100),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
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
                "Confirm Password",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
            Consumer<RegisterProvider>(
              builder: (_, formpro, __) {
                return SizedBox(
                  width: size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      await formpro.register(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                      );
                       await context.read<AuthProvider>().checkAuthStatus();
                       if(context.read<AuthProvider>().status == AuthStatus.authenticated){
                        Navigator.pop(context); 
                       }
                    },
                    child: formpro.status == RegisterStatus.loading
                        ? Transform.scale(
                            scale: 0.5,
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "Create Account",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                );
              },
            ),
            Consumer<RegisterProvider>(
              builder: (_, formpro, __) {
                return formpro.status == RegisterStatus.error
                    ? Text(formpro.errorMessage ?? "")
                    : Text("");
              },
            ),
          ],
        ),
      ),
    );
  }
}
