import 'package:flutter/material.dart';

class RockDetail extends StatelessWidget {
  const RockDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Image.network(
                        "https://i.scdn.co/image/ab6761610000e5eb709184ceb74ae0bc0b51d34e",
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'ソニー・ミュージック',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ]
              ),
              const Text(
                'sumika',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const Chip(
                label: Text('2013年5月17日'),
                backgroundColor: Colors.yellow,
              )
            ],
          )
      ),
    );
  }
}
