import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; 
import 'package:flutter_localizations/flutter_localizations.dart'; // حزمة التعريب الرسمية
import 'package:firebase_core/firebase_core.dart'; // تهيئة الفايربيس
import 'package:get/get.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'admin_login_screen.dart';
import 'admin_dashboard_screen.dart';
import 'auth_controller.dart';       // ملف حماية الحسابات
import 'database_controller.dart';   // ملف قاعدة البيانات والطلبات

void main() async {
  // تأمين تهيئة الخدمات الأساسية قبل تشغيل الواجهات
  WidgetsFlutterBinding.ensureInitialized();
  
  // ⚡ ربط وتهيئة قاعدة بيانات Firebase بشكل حقيقي وتلقائي باستخدام بيانات مشروعك المستخرجة
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDb8sRwNwn4vHdykDljuQPPQbcRLkwbla4", 
      authDomain: "://firebaseapp.com",       
      projectId: "emptest-3537e",                         
      storageBucket: "emptest-3537e.firebasestorage.app", 
      messagingSenderId: "120435369392",                 
      appId: "1:120435369392:android:59a840fee4e83c83ec6275", 
    ),
  ); 

  // حقن وتجهيز ملفات التحكم بالداتا حية في ذاكرة التطبيق الدائمة خلف الكواليس
  Get.put(AuthController());
  Get.put(DatabaseController());

  runApp(const MasanadaDhofarApp());
}

class MasanadaDhofarApp extends StatelessWidget {
  const MasanadaDhofarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'مساندة ظفار',
      debugShowCheckedModeBanner: false,
      
      // ضبط لغة نظام "مساندة ظفار" التلقائية إلى العربية (سلطنة عُمان) واجهة RTL كاملة
      locale: const Locale('ar', 'OM'),
      fallbackLocale: const Locale('ar', 'OM'),
      
      // استدعاء المترجمين والمترجمات الرسميين لحماية شاشات وبطاقات التطبيق من الاستثناءات والأخطاء
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'OM'),
      ],
      
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xfff8fafc),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const LandingScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/admin-login', page: () => const AdminLoginScreen()),
        GetPage(name: '/admin-dashboard', page: () => const AdminDashboardScreen()),
      ],
    );
  }
}
