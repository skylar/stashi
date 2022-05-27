import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:opensea_dart/pojo/collection_object.dart' as collection;
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/utils.dart';

class WatchlistScreen extends ConsumerWidget {
  final Account account;

  WatchlistScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var watchlistState = ref.watch(watchlistStateProvider);
    var watchlist = ref.watch(account.watchlistProvider);

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
              return buildStatsView(collection);
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

  final _decimalFormater = NumberFormat('0.###');
  Widget buildStatsView(collection.Collection c) {
    String name = c.name == null ? '(unnamed)' : c.name!;
    return ListTile(
      onTap: () => openUrl('https://opensea.io/collection/${c.slug!}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(c.imageUrl!),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 14),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CryptoFontIcons.ETH,
            size: 14,
          ),
          Text(
            _decimalFormater.format(c.stats?.floorPrice),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
