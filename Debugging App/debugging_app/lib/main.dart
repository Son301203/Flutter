import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class MyObject{
  int value = 0;
  MyObject({
    required this.value,
  });

  void increase(){
    value ++;
  }

  void decrease(){
    value --;
  }

  int get values => this.value;

  set values(int newValue) => this.value = newValue;
}

class _MyAppState extends State<MyApp> {
  String? title;
  MyObject _myObject = MyObject(value : 0);
  Widget _buildText() {
    return Text(
      'Giá trị: ${_myObject.value}',
      style: const TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.person),
          title: Text(title ?? 'Debugging App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildText(),
              OutlinedButton(
                onPressed: () {
                  _myObject.increase();
                  setState(() {});
                },
                child: const Text('Increase value'),
              ),
              OutlinedButton(
                onPressed: () {
                  _myObject.decrease();
                  setState(() {});
                },
                child: const Text('Decrease value'),
              ),
              OutlinedButton(
                onPressed: () {
                  _myObject.value = 10;
                  setState(() {});
                },
                child: const Text('Set value equal to 10'),
              )
            ],
          ),
        ),
      ),
    );
  }
}