import 'package:flutter/foundation.dart';
import 'package:opensea_dart/opensea_dart.dart';
import 'package:opensea_dart/pojo/assets_object.dart' as osa;
import 'package:opensea_dart/pojo/collection_object.dart' as osc;

// api connection
String? _apiKey; // null, no key for now.
final _openSea = OpenSea(_apiKey);

class OpenSeaDatastore {
  final _collections = <String, osc.Collection>{}; // slug, collection
  final _assets = <String, osa.Assets>{}; // id, asset

  osa.Assets? assetById(String id) {
    return _assets[id];
  }

  osc.Collection? collectionBySlug(String slug) {
    return _collections[slug];
  }

  Future<osc.Collection?> loadCollection(String slug) {
    return _openSea.getCollection(slug, slug: slug).then((value) {
      var collection = value.collection;
      if (collection != null) {
        _collections[slug] = collection;
      } else {
        debugPrint('No collection data for $slug.');
      }
      return collection;
    });
  }

  Future<List<String>> loadPortfolio(String address) {
    // load assets and related collections
    return Future.wait(
            [_loadPortfolioAssets(address), _loadPortfolioCollections(address)])
        .then((value) {
      return value[0];
    });
  }

  Future<List<String>> _loadPortfolioAssets(String address) {
    return _openSea.getAssets(owner: address, limit: '50').then((value) {
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
    });
  }

  Future<List<String>> _loadPortfolioCollections(String address) {
    return _openSea
        .getCollections(assetOwner: address, limit: '50')
        .then((value) {
      var collections = value.collections;
      var slugs = <String>[];
      if (collections != null && collections.isNotEmpty) {
        debugPrint('${collections.length} unique collections in portfolio.');
        for (var collection in collections) {
          var slug = collection.slug;
          if (slug != null) {
            if (!_collections.containsKey(slug)) {
              _collections[slug] = collection;
            }
            slugs.add(slug);
          }
        }
      }
      return slugs;
    });
  }
}
