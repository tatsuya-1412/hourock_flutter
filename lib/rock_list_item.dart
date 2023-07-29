import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hourock_flutter/rock_detail.dart';
import 'package:hourock_flutter/models/rock.dart';

class RockListItem extends StatelessWidget {
  const RockListItem({Key? key, required this.rock}): super(key: key);
  final Rock? rock;
  @override
  Widget build(BuildContext context) {
    if (rock != null) {
      return ListTile(
        leading: Container(
          width: 80,
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(.5),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: CachedNetworkImageProvider(
                rock!.imageUrl,
              ),
            ),
          ),
        ),
        title: Text(
          rock!.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(rock!.genres.first),
        trailing: const Icon(Icons.navigate_next),
        onTap: () =>
        {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => RockDetail(rock: rock!)),
          ),
        },
      );
    } else {
      return const ListTile(title: Text('...'));
    }
  }
}