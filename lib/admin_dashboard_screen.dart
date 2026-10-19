import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'database_controller.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استدعاء متحكم قاعدة البيانات للاستماع الحي
    final DatabaseController _dbController = Get.find<DatabaseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم مساندة ظفار الإدارية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xff1e293b),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          )
        ],
      ),
      body: Obx(() {
        // حساب الإحصائيات ديناميكياً من السيرفر السحابي مباشرة
        int totalRequests = _dbController.operationsList.length;
        int pendingRequests = _dbController.operationsList.where((op) => op['status'] == 'معلق').length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كروت الإحصائيات الذكية المستوحاة من dashboard.html
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStatCard('إجمالي البلاغات والطلبات', '$totalRequests', Colors.teal, Icons.assessment),
                  _buildStatCard('طلبات معلقة تحتاج حل', '$pendingRequests', Colors.amber, Icons.hourglass_empty),
                  _buildStatCard('الحالات المنجزة المكتملة', '${totalRequests - pendingRequests}', Colors.blue, Icons.assignment_turned_in),
                  _buildStatCard('كفاءة المعالجة السحابية', totalRequests == 0 ? '100%' : '${((totalRequests - pendingRequests) / totalRequests * 100).toStringAsFixed(0)}%', Colors.blueGrey, Icons.speed),
                ],
              ),
              const SizedBox(height: 24),
              
              const Text('جدول متابعة طلبات وحل مشاكل الدعم الفني الحية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              
              // عرض الداتا الحقيقية المستوردة من السيرفر
              _dbController.operationsList.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('لا توجد طلبات دعم فني مسجلة حالياً في قاعدة البيانات السحابية.', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _dbController.operationsList.length,
                        itemBuilder: (context, index) {
                          var operation = _dbController.operationsList[index];
                          String title = operation['title'] ?? 'بدون عنوان';
                          String location = operation['location'] ?? 'غير محدد';
                          String status = operation['status'] ?? 'معلق';
                          
                          Color statusColor = status == 'مكتمل' ? Colors.green : Colors.orange;

                          return ListTile(
                            title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            subtitle: Text('الموقع: $location', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                              child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
