import 'package:flutter/material.dart';
import 'package:hourock_flutter/db/favorite.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<Favorite> _favs = [];

  List<Favorite> get favs => _favs;

  FavoriteNotifier() {
    syncDb();
  }

  void syncDb() async {
    FavoriteDb.read().then(
      (val) => _favs
        ..clear()
        ..addAll(val),
    );
    notifyListeners();
  }

  void toggle(Favorite fav) {
    if (isExist(fav.rockId)) {
      delete(fav.rockId);
    } else {
      add(fav);
    }
  }

  bool isExist(String id) {
    if (_favs.indexWhere((fav) => fav.rockId == id) < 0) {
      return false;
    }
    return true;
  }

  void add(Favorite fav) async {
    await FavoriteDb.create(fav);
    syncDb();
  }

  void delete(String id) async {
    await FavoriteDb.delete(id);
    syncDb();
  }
}

class Favorite {
  final String rockId;

  Map<String, dynamic> toMap() {
    return {
      'id': rockId,
    };
  }

  Favorite({
    required this.rockId,
  });
}