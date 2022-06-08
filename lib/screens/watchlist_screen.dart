import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/utils.dart';
import 'package:stashi/widgets/collection_item_view.dart';

class WatchlistScreen extends ConsumerWidget {
  final Account account;

  const WatchlistScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var watchlistState = ref.watch(watchlistStateProvider);
    var watchlist = ref.watch(account.watchlistProvider);

    watchlist.sort((a, b) => b.safeFloorPrice.compareTo(a.safeFloorPrice));

    if (watchlistState == DatasetState.none) {
      return buildPlaceholder("Add collections to watch.");
    } else if (watchlistState == DatasetState.notLoaded) {
      return buildPlaceholder("Loading data.");
    } else {
      return RefreshIndicator(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: (watchlist.length * 2) - 1,
            itemBuilder: (BuildContext context, int index) {
              if (index.isOdd) return const Divider();

              var collection = watchlist[index ~/ 2];
              return CollectionItemView(col: collection);
            }),
        onRefresh: () {
          return account.refreshData();
        },
      );
    }
  }

  Widget buildEmptyStatsView() {
    return const ListTile(
      title: Text(
        ' ------- ',
        style: TextStyle(fontSize: 14),
      ),
      trailing: Text(
        '--',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
