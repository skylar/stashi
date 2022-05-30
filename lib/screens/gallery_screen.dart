import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/models/account.dart';
import 'package:stashi/utils.dart';
import 'package:stashi/widgets/assets_view.dart';

class GalleryScreen extends ConsumerWidget {
  final Account account;

  const GalleryScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var portfolioAssets = ref.watch(account.portfolioAssetsProvider);
    if (portfolioAssets.isEmpty) {
      return buildPlaceholder("Your collection is empty.");
    }

    return AssetsView(assets: portfolioAssets.toList());
  }
}
