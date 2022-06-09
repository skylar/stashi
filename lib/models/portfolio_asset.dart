import 'package:opensea_dart/pojo/assets_object.dart' as osa;
import 'package:opensea_dart/pojo/collection_object.dart' as osc;

class PortfolioAsset {
  PortfolioAsset(this._asset, this._collection);

  final osa.Assets _asset;
  final osc.Collection? _collection;
  static const maxTokenIdLength = 10;

  get id => _asset.id;
  String get tokenId => _asset.tokenId ?? '';
  String get abbrTokenId => tokenId.substring(_abbrTokenIdSubstrPos);
  get imageUrl => _asset.imagePreviewUrl;
  get permalink => _asset.permalink;
  get isHidden =>
      (_asset.collection?.hidden ?? false) ||
      (_collection?.stats?.totalVolume ?? 0.0) <= 0.0;
  double get floor => _collection?.safeFloorPrice ?? 0.0;
  get collection => _collection;

  get _abbrTokenIdSubstrPos => tokenId.length <= maxTokenIdLength
      ? 0
      : tokenId.length - maxTokenIdLength;
}
