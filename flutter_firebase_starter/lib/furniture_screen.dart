// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'furniture.dart';
import 'carts.dart';

class FurnitureScreen extends StatelessWidget {
  final DocumentSnapshot furniture;

  const FurnitureScreen({super.key, required this.furniture});

  @override
  Widget build(BuildContext context) {
    final name = furniture['name'];
    final price = furniture['price'];
    final description = furniture['description'];
    final image = furniture['image'];

    Future<void> createData() async {
      final furniture = Furniture(
        name: name,
        price: price,
        description: description,
        image: image,
      );
      try {
        await FirebaseFirestore.instance
            .collection('Carts')
            .add(furniture.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add data to carts successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartsScreen()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            image.isEmpty
                ? const Icon(Icons.chair, size: 200)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.price_check, color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: createData,
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
