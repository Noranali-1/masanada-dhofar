import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class DatabaseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // قائمة تفاعلية لعرض العمليات والطلبات حية في لوحة تحكم المشرف
  var operationsList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenToOperations(); // تشغيل الاستماع الفوري للبيانات بمجرد فتح التطبيق
  }

  // 🔄 دالة الاستماع الحي والمباشر لبيانات Firebase Firestore (Realtime Streams)
  void listenToOperations() {
    _firestore.collection('operations').snapshots().listen((snapshot) {
      operationsList.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // ➕ دالة يقوم المستخدم العادي من خلالها برفع طلب مساندة جديد
  Future<void> createSupportRequest(String title, String location) async {
    try {
      await _firestore.collection('operations').add({
        'title': title,
        'location': location,
        'status': 'معلق',
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.success,
        title: 'تم إرسال الطلب',
        text: 'تم تسجيل طلب المساندة الخاص بك بنجاح.',
        confirmBtnText: 'موافق',
      );
    } catch (e) {
      QuickAlert.show(
        context: Get.context!,
        type: QuickAlertType.error,
        title: 'خطأ',
        text: 'فشل إرسال الطلب: $e',
      );
    }
  }
}
