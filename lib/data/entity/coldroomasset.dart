class ColdRoomAsset{
  String id;
  String cold_room_name;
  String hotel;

  ColdRoomAsset({
    required this.id,
    required this.cold_room_name,
    required this.hotel
  });
  factory ColdRoomAsset.fromJson(Map<dynamic,dynamic> json ,String key){
    return ColdRoomAsset(id: key, cold_room_name: json["cold_room_name"] as String, hotel: json["hotel"] as String);
  }
}