import 'package:flutter/material.dart';
import 'package:stashi/models/account.dart';

import '../utils.dart';

class FavoritesScreen extends StatelessWidget {
  final Account account;

  const FavoritesScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildPlaceholder("Favorites");
  }
}
