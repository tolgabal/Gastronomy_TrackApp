class SoakingAsset{
  String id;
  String asset_name;
  String hotel;
  SoakingAsset({
    required this.id,
    required this.asset_name,
    required this.hotel
  });

  factory SoakingAsset.fromJson(Map<dynamic,dynamic> json, String key){
    return SoakingAsset(id: key, asset_name: json["asset_name"] as String, hotel: json["hotel"] as String);
  }

}