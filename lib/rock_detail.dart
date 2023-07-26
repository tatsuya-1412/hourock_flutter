import 'package:flutter/material.dart';
import 'package:hourock_flutter/models/rock.dart';

class RockDetail extends StatelessWidget {
  const RockDetail({Key? key, required this.rock}) : super(key: key);
  final Rock rock;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Spacer(),
            Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Image.network(
                      rock.imageUrl,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   child: Text(
                  //     rock.id,
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // )
                ]
            ),
            Text(
              rock.name,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rock.genres.map(
                    (genre) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Chip(
                    backgroundColor: Colors.yellow,
                    label: Text(
                      genre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
