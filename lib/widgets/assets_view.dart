import 'package:flutter/material.dart';
import 'package:stashi/models/portfolio_asset.dart';
import 'package:stashi/utils.dart';
import 'package:path/path.dart' as p;

class AssetsView extends StatefulWidget {
  final List<PortfolioAsset> assets;

  @override
  AssetsViewState createState() => AssetsViewState();

  const AssetsView({Key? key, required this.assets}) : super(key: key);
}

class AssetsViewState extends State<AssetsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: buildAssetGrid(widget.assets),
      ),
    );
  }

  Widget buildAssetGrid(List<PortfolioAsset> assets) {
    var visibleAssets = assets.where((e) => !e.isHidden).toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: visibleAssets.length,
      itemBuilder: (context, index) {
        var asset = visibleAssets[index];
        return InkWell(
          onTap: () => openUrl(asset.permalink!),
          child: Container(
            alignment: Alignment.bottomRight,
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageForUrl(asset.imageUrl),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                asset.abbrTokenId,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  ImageProvider imageForUrl(String? url) {
    const defaultImage = AssetImage('assets/graphics/No-Image-Placeholder.png');

    if (url == null || '.svg' == p.extension(url)) {
      return defaultImage;
    }
    return NetworkImage(url);
  }
}
