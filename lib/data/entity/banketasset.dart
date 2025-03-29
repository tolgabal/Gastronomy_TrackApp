class BanketAsset{
  String id;
  String banket_name;
  String hotel;

  BanketAsset({
    required this.id,
    required this.banket_name,
    required this.hotel
  });
  factory BanketAsset.fromJson(Map<dynamic,dynamic> json ,String key){
    return BanketAsset(id: key, banket_name: json["banket_name"] as String, hotel: json["hotel"] as String);
  }
}