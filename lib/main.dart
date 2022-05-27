import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/models/open_sea_datastore.dart';
import 'package:stashi/screens/favorites_screen.dart';
import 'package:stashi/screens/portfolio_screen.dart';
import 'package:stashi/screens/settings_screen.dart';
import 'package:stashi/screens/watchlist_screen.dart';

final tashProvider = Provider((_) => 'Tash');

void main() {
  runApp(const ProviderScope(
    child: StashiApp(),
  ));
}

class StashiApp extends StatelessWidget {
  const StashiApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stashi',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const StashiAppScreens(title: 'Stashi'),
    );
  }
}

class StashiAppScreens extends ConsumerStatefulWidget {
  const StashiAppScreens({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<StashiAppScreens> createState() => _StashiAppScreensState();
}

class _StashiAppScreensState extends ConsumerState<StashiAppScreens> {
  int _selectedIndex = 0;
  List<Widget> _menuWidgets = <Widget>[];
  late final Account _account;

  @override
  void initState() {
    super.initState();
    _account = Account(ref, OpenSeaDatastore());
    _account.loadAccountData();
  }

  @override
  Widget build(BuildContext context) {
    _menuWidgets = [
      WatchlistScreen(account: _account),
      PortfolioScreen(account: _account),
      FavoritesScreen(account: _account),
      SettingsScreen(account: _account),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _account.refreshData();
                },
                child: const Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: _menuWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.moving),
          label: 'Watchlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'My Things',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.pink[100],
      selectedItemColor: Colors.pink,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
