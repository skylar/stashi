import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kWalletAddressPref = 'walletAddressEthereum';

enum SettingsState {
  unitialized,
  loading,
  ready,
}

final settingsStateProvider = StateProvider<SettingsState>(
  (ref) => SettingsState.unitialized,
);

class UserSettings {
  final WidgetRef _ref;
  var _walletAddress = '0x0'; // 0x3DF81F0e09C04BBFc66a8b0DE4FC14675db4aCCe
  final _watchlist = <String>[
    'goblintownwtf',
    'otherdeed',
    'proof-moonbirds',
    'moonbirds-oddities',
    'okay-bears',
    'mutant-ape-yacht-club',
    'azuki',
    'meebits',
    'boredapeyachtclub',
  ]; // slugs
  final _favs = <String>[];
  SharedPreferences? _sharedPreferences;

  String get walletAddress => _walletAddress;
  List<String> get watchlist => _watchlist;
  List<String> get favs => _favs;

  set walletAddress(String addr) {
    _walletAddress = addr;
    _sharedPreferences!.setString(_kWalletAddressPref, addr);
  }

  UserSettings(this._ref);

  Future<void> initialize() {
    return SharedPreferences.getInstance().then((SharedPreferences sp) {
      _sharedPreferences = sp;
      _walletAddress =
          _sharedPreferences?.getString(_kWalletAddressPref) ?? _walletAddress;
      debugPrint('user settings ready.');
      _ref.read(settingsStateProvider.notifier).state = SettingsState.ready;
    });
  }
}
