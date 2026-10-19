import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart'; // ربط ملف الحماية والبيانات الحية

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>(); // استدعاء متحكم الحسابات

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: Obx(() => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('تسجيل الدخول', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Text('الرجاء إدخال بيانات الأعضاء للمتابعة', style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 24),
            _authController.isLoading.value 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _authController.loginUser(
                      _emailController.text.trim(), 
                      _passwordController.text.trim()
                    );
                  },
                  child: const Text('دخول منصة الأعضاء', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
          ],
        ),
      )),
    );
  }
}
