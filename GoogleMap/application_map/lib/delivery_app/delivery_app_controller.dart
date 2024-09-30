import 'package:application_map/model/my_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class DeliveryAppController extends GetxController {
  TextEditingController orderIdController = TextEditingController();

  final Location location = Location();

  String deliveryAddress = '';
  String phoneNumber = '';
  String amountToCollect = '0';
  double customerLatidute = 37.7749;
  double customerLongidute = -122.4194;
  bool showDeliveryInfo = false;
  bool isDeliveryStart = false;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference orderCollection;
  late final CollectionReference orderTrackingCollection;

  @override
  void onInit(){
    super.onInit();
    orderCollection = firestore.collection('order');
    orderTrackingCollection = firestore.collection('orderTracking');
    getLoactionPermission();
  }

  getOrderById() async{
    try{
      String orderId = orderIdController.text;
      QuerySnapshot querySnapshot = await orderCollection.where('id', isEqualTo: orderId).get();

      if(querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        MyOrder? order = MyOrder.fromJson(data);
        if(order != null) {
          deliveryAddress = order.address ?? '';
          phoneNumber = order.phone ?? '';
          amountToCollect = order.amount.toString();
          customerLatidute = order.latitude ?? 0;
          customerLongidute = order.longitude ?? 0;
          showDeliveryInfo = true;
        }
        update();
      }else{
        Get.snackbar('Error', 'Order not found');
        return null;
      }
    }catch(e){
      Get.snackbar('Error', e.toString());
      return;
    }
  }

  Future<void> getLoactionPermission() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if(!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if(!serviceEnabled) {
          return;
        }
      }
      PermissionStatus permissionGranted = await location.hasPermission();
      if(permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if(permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    }catch(e){
      print("Error getting location: $e");
    }
  }

  void startDeliver() {
    location.onLocationChanged.listen((LocationData currentLocation){
      print('Location changed: ${currentLocation.latitude} , ${currentLocation.longitude}');
      saveOrUpdateMyOrderLocation(
        orderIdController.text, currentLocation.latitude ?? 0, currentLocation.longitude ?? 0);
    });
    location.enableBackgroundMode(enable: true);
  }

  Future<void> saveOrUpdateMyOrderLocation(String orderId, double latitude, double longitude) async {
    try {
      final DocumentReference docRef = orderTrackingCollection.doc(orderId);

      await firestore.runTransaction((transaction) async{
        final DocumentSnapshot snapshot = await transaction.get(docRef);

        if(snapshot.exists){
          transaction.update(docRef, {
            'latitude': latitude,
            'longitude': longitude
          });
        } else{
          transaction.set(docRef, {
            'orderID': orderId,
            'latitude': latitude,
            'longitude': longitude
          });
        }
      });
    }catch (e) {
      print("Error saving or updating order location $e");
    }
  }

}