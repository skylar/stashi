import 'package:flutter/foundation.dart';
import 'package:opensea_dart/opensea_dart.dart';
import 'package:opensea_dart/pojo/assets_object.dart' as assets;
import 'package:opensea_dart/pojo/collection_object.dart' as collection;

// api connection
String? _apiKey; // null, no key for now.
final _openSea = OpenSea(_apiKey);

class OpenSeaDatastore {
  final _collections = <String, collection.Collection>{};  // slug, collection
  final _assets = <String, assets.Assets>{};                      // id, asset

  assets.Assets? assetById(String id) {
    return _assets[id];
  }
  collection.Collection? collectionBySlug(String slug) {
    return _collections[slug];
  }

  Future<collection.Collection?> loadCollection(String slug) {
    return _openSea.getCollection(slug, slug: slug).then(
      (value) {
        var collection = value.collection;
        if (collection != null) {
          debugPrint('$slug has floor of ${collection.stats!.floorPrice}');
          _collections[slug] = collection;
        } else {
          debugPrint('No collection data for $slug.');
        }
        return collection;
      }
    );
  }

  Future<List<String>> loadPortfolio(String address) {
    // my collection
    return _openSea.getAssets(owner: address, limit: '50').then(
      (value) {
        var assets = value.assets;
        if (assets != null && assets.isNotEmpty) {
          debugPrint('${assets.length} assets in collection.');
          var ids = <String>[];
          for (var asset in assets) {
            var id = asset.id;
            if (id != null) {
              ids.add(id);
              _assets[id] = asset;
            }
          }
          return ids;
        } else {
          debugPrint('No data in collection.');
          return [];
        }
      }
    );
  }
}
