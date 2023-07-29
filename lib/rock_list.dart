
import 'package:flutter/material.dart';
import 'package:hourock_flutter/consts/rockapi.dart';
import 'package:hourock_flutter/models/favorite.dart';
import 'package:hourock_flutter/models/rock.dart';
import 'package:hourock_flutter/rock_detail.dart';
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
  bool isGridMode = false;

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

  void changeFavMode(bool currentFavMode) {
    setState(() {
      isFavoriteMode = !currentFavMode;
    });
  }

  void changeGridMode(bool currentGridMode) {
    setState(() {
      isGridMode = !currentGridMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) => Column(
        children: [
          TopHeadMenu(
            isFavoriteMode: isFavoriteMode,
            changeFavMode: changeFavMode,
            isGridMode: isGridMode,
            changeGridMode: changeGridMode,
          ),
          Expanded(
            child: Consumer<RockNotifier>(
              builder: (context, rocks, child) {
                if (itemCount(favs.favs.length, _currentPage) == 0) {
                  return const Text('no data');
                } else {
                  if (isGridMode) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                      itemBuilder: (context, index) {
                        if (index == itemCount(favs.favs.length, _currentPage)) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: OutlinedButton(
                              child: const Text('more'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              ),
                              onPressed: isLastPage(favs.favs.length, _currentPage)
                                ? null
                                : () => setState(() {
                                  _currentPage++;
                                },
                              ),
                            ),
                          );
                        } else {
                          return RockGridItem(
                            rock: rocks.byId(itemId(favs.favs, index)),
                          );
                        }
                      },
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      itemCount: itemCount(favs.favs.length, _currentPage) + 1,
                      itemBuilder: (context, index) {
                        if (index == itemCount(favs.favs.length, _currentPage)) {
                          return OutlinedButton(
                            child: const Text('more'),
                            onPressed: isLastPage(
                                favs.favs.length, _currentPage)
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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TopHeadMenu extends StatelessWidget {
  const TopHeadMenu({
    Key? key,
    required this.isFavoriteMode,
    required this.changeFavMode,
    required this.isGridMode,
    required this.changeGridMode,
  }) : super(key: key);
  final bool isFavoriteMode;
  final Function(bool) changeFavMode;
  final bool isGridMode;
  final Function(bool) changeGridMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      alignment: Alignment.topRight,
      child: IconButton(
        padding: const EdgeInsets.all(0),
        icon: const Icon(Icons.auto_awesome_outlined),
        onPressed: () async {
          await showModalBottomSheet<bool>(
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
                changeFavMode: changeFavMode,
                gridMode: isGridMode,
                changeGridMode: changeGridMode,
              );
            },
          );
        },
      ),
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({
    Key? key,
    required this.favMode,
    required this.changeFavMode,
    required this.gridMode,
    required this.changeGridMode,
  }): super(key: key);
  final bool favMode;
  final Function(bool) changeFavMode;
  final bool gridMode;
  final Function(bool) changeGridMode;

  String mainText() {
    return '表示設定';
  }

  String menuFavTitle(bool fav) {
    if (fav) {
      return '「すべて」表示に切り替え';
    } else {
      return '「お気に入り」表示に切り替え';
    }
  }

  String menuFavSubtitle(bool fav) {
    if (fav) {
      return '全てのポケモンが表示されます';
    } else {
      return 'お気に入りに登録したポケモンのみが表示されます';
    }
  }

  String menuGridTitle(bool grid) {
    if (grid) {
      return 'リスト表示に切り替え';
    } else {
      return 'グリッド表示に切り替え';
    }
  }

  String menuGridSubtitle(bool grid) {
    if (grid) {
      return 'ポケモンをグリッド表示します';
    } else {
      return 'ポケモンをリスト表示します';
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
                mainText(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(
                menuFavTitle(favMode),
              ),
              subtitle: Text(
                menuFavSubtitle(favMode),
              ),
              onTap: () {
                changeFavMode(favMode);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(
                menuGridTitle(gridMode),
              ),
              subtitle: Text(
                menuGridSubtitle(gridMode),
              ),
              onTap: () {
                changeGridMode(gridMode);
                Navigator.pop(context);
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

class RockGridItem extends StatelessWidget {
  const RockGridItem({Key? key, required this.rock}) : super(key: key);
  final Rock? rock;
  @override
  Widget build(BuildContext context) {
    if (rock != null) {
      return Column(
        children: [
          InkWell(
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => RockDetail(rock: rock!),
                ),
              ),
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(
                    rock!.imageUrl,
                  )
                )
              ),
            ),
          ),
          Text(
            rock!.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: Text('...'),
        ),
      );
    }
  }
}