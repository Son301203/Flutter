import 'package:application_map/live_tracking_page/live_tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index){
          return ListTile(
            title: Text("Order ID: 1"),
            subtitle: Text("Customer: Son"),
            onTap: () {
              Get.to(const LiveTrackingPage());
            },
          );
        }
      ),
    ) ;
  }
}