import 'package:application_map/add_order/add_order.dart';
import 'package:application_map/delivery_app/delivery_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
              ), 
              onPressed: () {
                Get.to(const AddOrderPage());
              }, 
              child: const Text('Client App')
            ),
            const SizedBox(height: 20,),  
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
              ), 
              onPressed: () {
                Get.to(const DeliveryPage());
              }, 
              child: const Text('Rental Car App')
            )
          ],
        ),
      ),
    );
  }
}