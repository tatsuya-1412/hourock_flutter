
import 'package:flutter/material.dart';
import 'package:hourock_flutter/consts/rockapi.dart';
import 'package:hourock_flutter/models/favorite.dart';
import 'package:hourock_flutter/models/rock.dart';
import 'package:hourock_flutter/rock_list_item.dart';
import 'package:provider/provider.dart';

class RockList extends StatefulWidget {
  const RockList({super.key});
  @override
  _RockList createState() => _RockList();
}

class _RockList extends State<RockList> {
  static const int pageSize = 10;
  int _currentPage = 1;
  bool isFavoriteMode = false;

  int itemCount(int favsCount, int page) {
    int ret = page * pageSize;
    if (isFavoriteMode && ret > favsCount) {
      ret = favsCount;
    }
    if (ret > rockMaxId) {
      ret = rockMaxId;
    }
    return ret;
  }

  String itemId(List<Favorite> favs, int index) {
    String ret = artistIds[index];
    if (isFavoriteMode && index < favs.length) {
      ret = favs[index].rockId;
    }
    return ret;
  }

  bool isLastPage(int favsCount, int page) {
    if (isFavoriteMode) {
      if (page * pageSize < favsCount) {
        return false;
      }
    } else {
      if (page * pageSize < rockMaxId) {
        return false;
      }
    }
    return true;
  }

  void changeMode(bool currentFavMode) {
    setState(() {
      isFavoriteMode = !currentFavMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) => Column(
        children: [
          Container(
            height: 24,
            alignment: Alignment.topRight,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.auto_awesome_outlined),
              onPressed: () async {
                var ret = await showModalBottomSheet<bool>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                  ),
                  builder: (BuildContext context) {
                    return ViewModeBottomSheet(
                      favMode: isFavoriteMode,
                    );
                  },
                );
                if (ret != null && ret) {
                  changeMode(isFavoriteMode);
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<RockNotifier>(
              builder: (context, rocks, child) {
                if (itemCount(favs.favs.length, _currentPage) == 0) {
                  return const Text('no data');
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                    itemBuilder: (context, index) {
                      if (index == itemCount(favs.favs.length, _currentPage)) {
                        return OutlinedButton(
                          child: const Text('more'),
                          onPressed: isLastPage(favs.favs.length, _currentPage)
                              ? null
                              : () =>
                          {
                            setState(() => _currentPage++),
                          },
                        );
                      } else {
                        return RockListItem(
                          rock: rocks.byId(itemId(favs.favs, index)),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({Key? key, required this.favMode}): super(key: key);
  final bool favMode;

  String mainText(bool fav) {
    if (fav) {
      return 'お気に入りのアーティストが表示されています';
    } else {
      return 'すべてのアーティストが表示されています';
    }
  }

  String menuTitle(bool fav) {
    if (fav) {
      return '「すべて」表示に切り替え';
    } else {
      return '「お気に入り」表示に切り替え';
    }
  }

  String menuSubtitle(bool fav) {
    if (fav) {
      return 'すべてのアーティストが表示されます';
    } else {
      return 'お気に入りに登録したアーティストのみが表示されます';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.background,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                mainText(favMode),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(
                menuTitle(favMode),
              ),
              subtitle: Text(
                menuSubtitle(favMode),
              ),
              onTap: () {
                Navigator.pop(context, true);
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text('キャンセル'),
              onPressed: () => Navigator.pop(context, false),
            )
          ],
        ),
      ),
    );
  }
}