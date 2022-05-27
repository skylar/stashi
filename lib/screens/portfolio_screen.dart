import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/utils.dart';
import 'package:stashi/widgets/assets_view.dart';
import 'package:opensea_dart/pojo/assets_object.dart';

class PortfolioScreen extends ConsumerWidget {
  final Account account;

  const PortfolioScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var portfolioIds = ref.watch(account.portfolioIdsProvider);
    if (portfolioIds.isEmpty) {
      return buildPlaceholder("Your collection is empty.");
    }

    return AssetsView(
        assets: List<Assets>.from(
            portfolioIds.map((id) => account.datastore.assetById(id))));
  }
}
