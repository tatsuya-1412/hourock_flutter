import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hourock_flutter/consts/rockapi.dart';
import 'package:hourock_flutter/models/rock.dart';
import 'package:hourock_flutter/rock_list_item.dart';
import 'package:hourock_flutter/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/theme_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final themeModeNotifier = ThemeModeNotifier(pref);
  final rockNotifier = RockNotifier();
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModeNotifier>(
          create: (context) => themeModeNotifier,
        ),
        ChangeNotifierProvider<RockNotifier>(
          create: (context) => rockNotifier,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => MaterialApp(
        title: 'Hourock Flutter',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mode.mode,
        home: const TopPage(),
      ),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({super.key});
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentbnb = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: currentbnb == 0 ? const RockList() : const Settings(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {
          setState(
                () => currentbnb = index,
          )
        },
        currentIndex: currentbnb,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          )
        ],
      ),
    );
  }
}

class RockList extends StatefulWidget {
  const RockList({super.key});
  @override
  _RockList createState() => _RockList();
}

class _RockList extends State<RockList> {
  static const int more = 10;
  int rockCount = more;
  @override
  Widget build(BuildContext context) {
    return Consumer<RockNotifier>(
      builder: (context, rocks, child) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          itemCount: rockCount + 1,
          itemBuilder: (context, index) {
            if (index == rockCount) {
              return OutlinedButton(
                child: const Text('more'),
                onPressed: () => {
                  setState(
                        () {
                      rockCount += more;
                      if (rockCount > rockMaxId) {
                        rockCount = rockMaxId;
                      }
                    },
                  )
                },
              );
            }
            return RockListItem(
              rock: rocks.byId(artistIds[index]),
            );
          }
      ),
    );
  }
}
