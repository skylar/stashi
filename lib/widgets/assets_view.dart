import 'package:flutter/material.dart';
import 'package:opensea_dart/pojo/assets_object.dart';
import 'package:stashi/utils.dart';

class AssetsView extends StatefulWidget {
  final List<Assets> assets;

  @override
  _AssetsViewState createState() => _AssetsViewState();

  const AssetsView({Key? key, required this.assets}) : super(key: key);
}

class _AssetsViewState extends State<AssetsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: buildAssetGrid(widget.assets),
      ),
    );
  }

  Widget buildAssetGrid(List<Assets> assets) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        var asset = assets[index];
        return Container(
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(asset.imagePreviewUrl ?? 'image'),
            ),
          ),
          child: InkWell(
            onTap: () => openUrl(asset.permalink!),
          ),
        );
        // return InkWell(
        //   onTap: () => openUrl(asset.permalink!),
        //   child: Container(
        //     constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
        //     decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        //       image: DecorationImage(
        //         fit: BoxFit.cover,
        //         image: NetworkImage(asset.imagePreviewUrl ?? 'image'),
        //       ),
        //     ),
        //   )
        // );
      },
    );
  }
}
