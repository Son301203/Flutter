import 'package:application_map/delivery_app/delivery_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveryAppController>(
      init: DeliveryAppController(),
        builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Delivery Page"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Image.network(
                  'https://as2.ftcdn.net/v2/jpg/04/50/14/37/1000_F_450143745_Vjo9PH8euCzCL4eXmcH3HMYjncpi9NDg.jpg',
                  width: 200,
                  height: 200,
                ),
                const Text(
                  "Enter My Order ID:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8,),
                TextField(
                  controller: controller.orderIdController,
                  decoration: const InputDecoration(
                    hintText: "My OrderID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: !controller.showDeliveryInfo,
                  child: ElevatedButton(
                    onPressed: () async {
                      controller.getOrderById();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Submit")
                  ),  
                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: controller.showDeliveryInfo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Delivery Address: ${controller.deliveryAddress}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone Number: ${controller.phoneNumber}",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            icon: Icon(Icons.call),
                            onPressed: (){
                              launch('Tel: ${controller.phoneNumber}');
                            }, 
                          ),
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        'Amount to Collect: \$ ${controller.amountToCollect}',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse('https://www.google.com/maps?q=${controller.customerLatidute}, ${controller.customerLongidute}'));
                            }, 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
                            ),
                            icon: Icon(Icons.location_on),
                            label: Text("Show location"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.startDeliver();
                            },
                            child: const Text("Start Delivery"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
