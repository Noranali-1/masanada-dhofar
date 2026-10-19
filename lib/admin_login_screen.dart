import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_controller.dart'; // ربط كود الحماية المرتكز على الفايربيس

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _adminEmail = TextEditingController();
  final _adminPassword = TextEditingController();
  final AuthController _authController = Get.find<AuthController>(); // استدعاء متحكم الحسابات

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f172a),
      body: Obx(() => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.amber, child: Icon(Icons.lock_person, color: Color(0xff0f172a), size: 32)),
                const SizedBox(height: 16),
                const Text('بوابة المشرفين الآمنة', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextField(
                  controller: _adminEmail,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'معرف المشرف (Admin Email)',
                    labelStyle: const TextStyle(color: Colors.white60),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white30), borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _adminPassword,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'رمز الحماية المروري',
                    labelStyle: const TextStyle(color: Colors.white60),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white30), borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                _authController.isLoading.value
                  ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber))
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        _authController.loginAdmin(
                          _adminEmail.text.trim(),
                          _adminPassword.text.trim()
                        );
                      },
                      child: const Text('تحقق وتأكيد الصلاحية', style: TextStyle(color: Color(0xff0f172a), fontWeight: FontWeight.bold)),
                    ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
