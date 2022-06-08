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
    return _loadPortfolioAssets(address).then((assets) {
      return Future.wait(assets.map((a) => loadCollection(a.collection!.slug!)))
          .then((collection) {
        debugPrint("loaded ${collection.length} collections for portfolio.");
        return assets.map((asset) => asset.id!).toList();
      });
    });
  }

  Future<List<osa.Assets>> _loadPortfolioAssets(String address) {
    return _openSea.getAssets(owner: address, limit: '50').then((value) {
      var assets = value.assets;
      if (assets != null && assets.isNotEmpty) {
        debugPrint('${assets.length} assets in collection.');
        var ids = <String>[];
        for (var asset in assets) {
          var id = asset.id;
          if (id != null) {
            // debugPrint(
            //     'Collection for $id: ${asset.collection?.name}, ${asset.collection?.hidden}');
            ids.add(id);
            _assets[id] = asset;
          }
        }
        return assets;
      } else {
        debugPrint('No data in collection.');
        return [];
      }
    });
  }

  // Future<void> _loadPortfolioCollections(String address) {
  //   return _openSea
  //       .getCollections(assetOwner: address, limit: '50')
  //       .then((value) {
  //     var collections = value.collections;
  //     if (collections != null && collections.isNotEmpty) {
  //       debugPrint('${collections.length} unique collections in portfolio.');
  //       for (var collection in collections) {
  //         var slug = collection.slug;
  //         if (slug != null) {
  //           _collections[slug] = collection;
  //         }
  //       }
  //     }
  //   });
  // }
}
