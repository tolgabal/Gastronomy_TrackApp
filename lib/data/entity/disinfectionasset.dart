class DisinfectionAsset{
  String id;
  String asset_name;
  String hotel;

  DisinfectionAsset({
    required this.id,
    required this.asset_name,
    required this.hotel
  });

  factory DisinfectionAsset.fromJson(Map<dynamic,dynamic> json, String key){
    return DisinfectionAsset(id: key, asset_name: json["asset_name"] as String, hotel: json["hotel"] as String);
  }
}