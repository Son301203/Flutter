import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Card()));

class Card extends StatefulWidget {
  const Card({super.key});

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  int level = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: AppBar(
          title: const Text(
            'ID Card',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[850],
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              level += 1; 
            });
          },
          backgroundColor: Colors.grey,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/438263446_833212528839302_8005124833199790827_n.jpg'),
                  radius: 40.0,
                ),
              ),
              const Divider(
                height: 60.0,
                color: Colors.white,
              ),
              const Text(
                'Name',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                'Trinh Son',
                style: TextStyle(
                    color: Colors.amberAccent,
                    letterSpacing: 2.0,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Age',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                '20',
                style: TextStyle(
                    color: Colors.amberAccent,
                    letterSpacing: 2.0,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Level',
                style: TextStyle(
                  color: Colors.white70,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                '$level',
                style: const TextStyle(
                    color: Colors.amberAccent,
                    letterSpacing: 2.0,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.white70,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'trinhson301203@gmail.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18.0,
                      letterSpacing: 1.0
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

