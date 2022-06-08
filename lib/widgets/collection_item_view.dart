import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:opensea_dart/pojo/collection_object.dart' as collection;
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:stashi/utils.dart';

final decimalFormatter = NumberFormat('0.###');

class CollectionItemView extends ConsumerWidget {
  final collection.Collection col;

  const CollectionItemView({Key? key, required this.col}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String name = col.name == null ? '(unnamed)' : col.name!;

    return ListTile(
      onTap: () => openUrl('https://opensea.io/collection/${col.slug!}'),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(col.imageUrl!),
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
            decimalFormatter.format(col.stats?.floorPrice),
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
