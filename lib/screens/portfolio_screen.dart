import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/utils.dart';

const _digitsFont = TextStyle(fontSize: 40.0);

class PortfolioScreen extends ConsumerWidget {
  final Account account;

  const PortfolioScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var portfolioAssets = ref.watch(account.portfolioAssetsProvider);
    if (portfolioAssets.isEmpty) {
      return buildPlaceholder("Your collection is empty.");
    }

    var pvalue = portfolioAssets
        .map(
          (e) => e.floor,
        )
        .reduce((value, element) => value + element);

    return Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Center(
            child: Column(children: [
          const Text('Total Value'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CryptoFontIcons.ETH,
                size: 30,
                color: Colors.black87,
              ),
              Text(
                pvalue.toString(),
                style: _digitsFont,
              )
            ],
          )
        ])));
  }
}
