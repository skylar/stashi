import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/utils.dart';
import 'package:stashi/widgets/collection_item_view.dart';

const _digitsFont = TextStyle(fontSize: 40.0);

class PortfolioScreen extends ConsumerWidget {
  final Account account;

  const PortfolioScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAssets = ref.watch(account.portfolioAssetsProvider).toList();
    final collections = ref
        .watch(account.portfolioCollectionsProvider)
        .where((c) => c.stats?.floorPrice != null && c.safeFloorPrice > 0.0)
        .toList();
    if (portfolioAssets.isEmpty) {
      return buildPlaceholder("Your collection is empty.");
    }

    var pvalue = portfolioAssets
        .map(
          (e) => e.floor,
        )
        .reduce((value, element) => value + element);
    collections.sort((a, b) => b.safeFloorPrice.compareTo(a.safeFloorPrice));

    return Center(
        child: Column(children: [
      buildPortfolioSummary(pvalue),
      Expanded(
        child: ListView.builder(
//              physics: const AlwaysScrollableScrollPhysics(),
            itemCount: (collections.length * 2) - 1,
            itemBuilder: (BuildContext context, int index) {
              if (index.isOdd) return const Divider();
              return CollectionItemView(col: collections[index ~/ 2]);
            }),
      )
    ]));
  }

  Widget buildPortfolioSummary(double pvalue) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0))),
        padding: const EdgeInsets.only(top: 15.0, bottom: 5),
        child: Column(children: [
          const Text('Total Value'),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              CryptoFontIcons.ETH,
              size: 30,
              color: Colors.grey,
            ),
            Text(
              decimalFormatter.format(pvalue),
              style: _digitsFont,
            )
          ])
        ]));
  }
}
