import 'package:opensea_dart/pojo/assets_object.dart' as osa;
import 'package:opensea_dart/pojo/collection_object.dart' as osc;

class PortfolioAsset {
  PortfolioAsset(this._asset, this._collection);

  final osa.Assets _asset;
  final osc.Collection? _collection;

  get id => _asset.id;
  get imageUrl => _asset.imagePreviewUrl;
  get permalink => _asset.permalink;
  get isHidden =>
      (_asset.collection?.hidden ?? false) ||
      (_collection?.stats?.totalSales ?? 0) <= 0;
  double get floor => _collection?.stats?.floorPrice ?? 0.0;
}
