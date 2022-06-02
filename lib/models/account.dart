import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:opensea_dart/pojo/collection_object.dart' as collection;
import 'package:stashi/models/portfolio_asset.dart';

import 'package:stashi/models/user_settings.dart';
import 'package:stashi/models/open_sea_datastore.dart';

enum DatasetState {
  none,
  notLoaded,
  loaded,
}

final watchlistStateProvider = StateProvider<DatasetState>(
  (ref) => DatasetState.notLoaded,
);
final portfolioDatasetStateProvider = StateProvider<DatasetState>(
  (ref) => DatasetState.notLoaded,
);
final portfolioStateProvider = StateProvider<DatasetState>((ref) {
  var settings = ref.watch(settingsStateProvider);
  var portfolio = ref.watch(portfolioDatasetStateProvider);
  if (settings == SettingsState.ready) {
    return portfolio;
  } else {
    return DatasetState.notLoaded;
  }
});

class Account {
  Account(this._ref, this._ds) : _settings = UserSettings(_ref) {
    portfolioAssetsProvider = Provider<Iterable<PortfolioAsset>>((ref) {
      final ids = ref.watch(portfolioIdsProvider);

      return ids.map((id) {
        var asset = _ds.assetById(id);
        var collection = _ds.collectionBySlug(asset?.collection?.slug ?? '');
        // debugPrint(
        //     'Collection ${collection?.name}: ${collection?.stats?.floorPrice} ${collection?.stats?.totalSales}');
        return PortfolioAsset(asset!, collection);
      });
    });
  }

  final WidgetRef _ref;
  final UserSettings _settings;
  final OpenSeaDatastore _ds;

  UserSettings get settings => _settings;
  OpenSeaDatastore get datastore => _ds;

  final portfolioIdsProvider = StateProvider<List<String>>((ref) => []);
  late Provider<Iterable<PortfolioAsset>> portfolioAssetsProvider;
  final watchlistProvider =
      StateProvider<List<collection.Collection>>((ref) => []);

  void updateAddress(String addr) {
    settings.walletAddress = addr;
    refreshData();
  }

  Future<void> loadPortfolioData() {
    return _ds.loadPortfolio(_settings.walletAddress).then((ids) {
      _ref.read(portfolioIdsProvider.notifier).state = ids;
      _ref.read(portfolioStateProvider.notifier).state = DatasetState.loaded;
    });
  }

  Future<void> loadAccountData() async {
    return _settings.initialize().then((_) {
      refreshData();
    });
  }

  Future<List<void>> refreshData() {
    debugPrint('refreshData…');
    return Future.wait([_loadPortfolio(), _loadWatchlistCollections()]);
  }

  Future<void> _loadPortfolio() {
    return _ds.loadPortfolio(_settings.walletAddress).then((ids) {
      _ref.read(portfolioIdsProvider.notifier).state = ids;
      _ref.read(portfolioStateProvider.notifier).state = DatasetState.loaded;
    });
  }

  Future<void> _loadWatchlistCollections() {
    return Future.wait(
            _settings.watchlist.map((slug) => _ds.loadCollection(slug)))
        .then((collections) {
      _ref.read(watchlistProvider.notifier).state =
          collections.whereType<collection.Collection>().toList();
      _ref.read(watchlistStateProvider.notifier).state = DatasetState.loaded;
    });
  }
}
