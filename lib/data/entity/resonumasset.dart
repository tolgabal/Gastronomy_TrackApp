class ResoNumAsset{
  String id;
  String reso_num_name;
  String hotel;
  ResoNumAsset({
    required this.id,
    required this.reso_num_name,
    required this.hotel
  });
  factory ResoNumAsset.fromJson(Map<dynamic,dynamic> json ,String key){
    return ResoNumAsset(id: key, reso_num_name: json["reso_num_name"] as String, hotel: json["hotel"] as String);
  }
}