import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  // 🔐 دالة تسجيل دخول المستخدمين والمشرفين
  Future<void> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.success,
        title: 'أهلاً بك',
        text: 'تم تسجيل الدخول بنجاح إلى منصة مساندة.',
        confirmBtnText: 'دخول',
        onConfirmBtnTap: () {
          Get.back();
          Get.offAllNamed('/'); 
        },
      );
    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'فشل الدخول',
        text: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
        confirmBtnText: 'حاول مجدداً',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 📝 دالة تسجيل حساب عضو جديد ومنحه صلاحية المشرف تلقائياً!
  Future<void> registerNewUser(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;
    try {
      isLoading.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // 🔥 تعديل ذكي: يتم حفظ الصلاحية كـ admin تلقائياً هنا دون الحاجة للموقع
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'role': 'admin', // أصبحت admin مباشرة لتسهيل تجربتك الحين
        'joinedAt': FieldValue.serverTimestamp(),
      });

      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.success,
        title: 'تم التسجيل بنجاح',
        text: 'تم إنشاء حساب المشرف الخاص بك بنجاح في النظام.',
        confirmBtnText: 'ابدأ الاستخدام',
        onConfirmBtnTap: () {
          Get.back();
          Get.offAllNamed('/'); 
        },
      );
    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'خطأ في التسجيل',
        text: e.toString().contains('email-already-in-use') 
            ? 'هذا البريد الإلكتروني مسجل بالفعل بالنظام.' 
            : e.toString(),
        confirmBtnText: 'موافق',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 👑 بوابة الإدارة والتحقق الآمن
  Future<void> loginAdmin(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;
    try {
      isLoading.value = true;
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(credential.user!.uid).get();
      
      if (userDoc.exists && userDoc['role'] == 'admin') {
        Get.offAllNamed('/admin-dashboard'); 
      } else {
        await _auth.signOut(); 
        throw 'عذراً، أنت لا تملك صلاحيات المشرفين لدخول لوحة التحكم.';
      }
    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'حماية النظام',
        text: e.toString(),
        confirmBtnText: 'موافق',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 🚪 تسجيل الخروج
  void signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/');
  }
}
