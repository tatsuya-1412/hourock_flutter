
import 'package:hourock_flutter/consts/rockapi.dart';
import 'package:hourock_flutter/models/rock.dart';
import 'package:spotify/spotify.dart';

Future<Rock> fetchHouRock(String id) async {
  final credentials = SpotifyApiCredentials(clientId, clientSecret);
  final spotify = SpotifyApi(credentials);
  final artist = await spotify.artists.get(id);
  if (artist != null) {
    return Rock.fromArtist(artist);
  } else {
    throw Exception('Failed to Load Rock');
  }
}