import 'package:flutter/material.dart';
import 'package:hourock_flutter/rock_detail.dart';


class RockListItem extends StatelessWidget {
  const RockListItem({Key? key, required this.index}): super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 80,
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(.5),
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            fit: BoxFit.fitWidth,
            image: NetworkImage(
              "https://i.scdn.co/image/ab6761610000e5eb709184ceb74ae0bc0b51d34e",
            ),
          ),
        ),
      ),
      title: const Text(
        'sumika',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: const Text('2013年'),
      trailing: const Icon(Icons.navigate_next),
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => const RockDetail()),
        ),
      },
    );
  }
}