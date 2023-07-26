import 'package:flutter/material.dart';
import 'package:hourock_flutter/api/rockapi.dart';
import 'package:spotify/spotify.dart';

class RockNotifier extends ChangeNotifier {
  final Map<String, Rock?> _rockMap = {};

  Map<String, Rock?> get rocks => _rockMap;

  void addRock(Rock rock) {
    _rockMap[rock.id] = rock;
    notifyListeners();
  }

  void fetchRock(String id) async {
    _rockMap[id] = null;
    addRock(await fetchHouRock(id));
  }

  Rock? byId(String id) {
    if (!_rockMap.containsKey(id)) {
      fetchRock(id);
    }
    return _rockMap[id];
  }
}

class Rock {
  final String id;
  final String name;
  final List<String> genres;
  final String imageUrl;

  Rock({
    required this.id,
    required this.name,
    required this.genres,
    required this.imageUrl,
  });

  factory Rock.fromArtist(Artist artist) {
    List<String> genreToList(dynamic genres) {
      List<String> ret = [];
      for (int i = 0; i < genres.length; i++) {
        ret.add(genres[i]);
      }
      return ret;
    }

    return Rock(
      id: artist.id != null ? artist.id! : "id",
      name: artist.name != null ? artist.name! : "name",
      genres: genreToList(artist.genres),
      imageUrl: artist.images?.first.url != null ? artist.images!.first.url! : "url",
    );
  }
}