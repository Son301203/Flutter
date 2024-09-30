import 'package:application_map/add_order/add_order_controller.dart';
import 'package:application_map/order_list/order_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddOrderPage extends StatelessWidget {
  const AddOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddOrderController>(
        init: AddOrderController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Orders Details"),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(const OrderListPage());
                    },
                    icon: const Icon(Icons.list)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.map_outlined)),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: controller.orderIdController,
                    decoration: const InputDecoration(
                      labelText: "Order ID",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      labelText: "Customer Name",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller.phoneController,
                    decoration: const InputDecoration(
                      labelText: "Customer Phone",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller.addressController,
                    decoration: const InputDecoration(
                      labelText: "Customer Address",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: controller.amountController,
                    decoration: const InputDecoration(
                      labelText: "Bill Account",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: GoogleMap(
                      initialCameraPosition:
                          const CameraPosition(target: LatLng(0, 0), zoom: 14),
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController mapController) {
                        controller.mapController = mapController;
                      },
                      onTap: (latLong){
                        controller.selectedLocation = latLong;
                        controller.update();
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('selectedLocation'),
                          position: controller.selectedLocation!,
                          infoWindow: InfoWindow(
                            title: 'Selected Location',
                            snippet: 'Lat: ${controller.selectedLocation!.latitude}, Lng: ${controller.selectedLocation!.longitude}',
                          ) 
                        ),
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.addOrder(context);
                    },
                    child: const Text('Order'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white),
                  )
                ],
              ),
            ),
          );
        }
      );
  }
}
