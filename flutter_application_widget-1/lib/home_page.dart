import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    //final: Runtime
    // const: Compiled
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        backgroundColor: Color.fromARGB(255, 224, 143, 143),
        actions: const [
          Icon(Icons.notifications),
          Icon(Icons.settings),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Body',
              style: TextStyle(
                fontSize: 24
              ),
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:() {
                    value --;
                    setState(() {});
                  },
                  icon: const Icon(Icons.remove)
                ),
                Text(
                  '$value',
                   style: TextStyle(
                    fontSize: 24
                  ),
                ),
                IconButton(
                  onPressed:() {
                    value ++;
                    setState(() {});
                  }, 
                  icon: const Icon(Icons.add)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}