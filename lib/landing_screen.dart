import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // فحص حالة الدخول الحية من Firebase
import 'database_controller.dart';
import 'auth_controller.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final DatabaseController _dbController = Get.find<DatabaseController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // 🔄 الاستماع إلى حالة تسجيل الدخول الحية من Firebase Auth
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // إذا كان هناك مستخدم مسجل دخوله حالياً، أظهر له صفحة تقديم طلبات الدعم الفني فوراً
        if (snapshot.hasData && snapshot.data != null) {
          return _buildSupportPage();
        }
        
        // إذا لم يكن هناك مستخدم مسجل (زائر جديد)، أظهر له الصفحة الترحيبية الافتراضية الجذابة
        return _buildWelcomePage();
      },
    );
  }

  // 1️⃣ 🌟 واجهة الصفحة الرئيسية الترحيبية الافتراضية الجذابة (Landing Page)
  Widget _buildWelcomePage() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'مساندة ظفار',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'نظام إدارة العمليات والخدمات الذكي بمحافظة ظفار',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.business_center, size: 65, color: Colors.teal),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'أهلاً بك في منصة مساندة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    child: Text(
                      'منصة رقمية متكاملة لإدارة وتقديم خدمات الدعم الفني والعمليات بكفاءة وسرعة عالية.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Get.toNamed('/login'),
                    child: const Text('تسجيل الدخول للمستخدمين والأعضاء', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: Colors.teal),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Get.toNamed('/register'),
                    child: const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 16, color: Colors.teal, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 32),
                  TextButton(
                    onPressed: () => Get.toNamed('/admin-login'),
                    child: const Text('بوابة دخول الإدارة والمشرفين', style: TextStyle(color: Colors.black45, fontSize: 13, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2️⃣ 🔧 واجهة نموذج تقديم وحلول بلاغات الدعم الفني (تظهر فقط بعد تسجيل الدخول)
  Widget _buildSupportPage() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text('مساندة ظفار', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('بوابة تقديم طلبات وبلاغات الدعم الفني والخدمات', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تقديم طلب دعم فني أو بلاغ جديد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),
                    const Text('سيظهر طلبك مباشرة في لوحة تحكم الإدارة للمتابعة حياً', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'عنوان المشكلة الفنية',
                        hintText: 'مثال: عطل في الخادم الرئيسي، صيانة أجهزة',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.build_circle_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _locationController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        labelText: 'موقع العمل أو الولاية',
                        hintText: 'مثال: صلالة، طاقة، مرباط، ثمريت',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_titleController.text.isNotEmpty && _locationController.text.isNotEmpty) {
                          _dbController.createSupportRequest(
                            _titleController.text.trim(), 
                            _locationController.text.trim()
                          );
                          _titleController.clear();
                          _locationController.clear();
                        } else {
                          Get.snackbar(
                            'تنبيه', 
                            'الرجاء تعبئة كافة حقول الدعم الفني أولاً.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.amber.withOpacity(0.8),
                            colorText: Colors.black87,
                          );
                        }
                      },
                      child: const Text('إرسال الطلب فوراً للنظام', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
),
],
),
),
),
Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1)))),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
TextButton.icon(
icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
label: const Text('بوابة الإدارة المشددة', style: TextStyle(color: Colors.black87, fontSize: 13)),
onPressed: () => Get.toNamed('/admin-login'),
),
TextButton.icon(
icon: const Icon(Icons.logout, color: Colors.redAccent),
label: const Text('تسجيل خروج الحساب', style: TextStyle(color: Colors.redAccent, fontSize: 13)),
onPressed: () => _authController.signOut(),
),
],
),
),
],
),
),
);
}
} 