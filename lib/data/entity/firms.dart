class Firms{
  String id;
  String firm_name;
  String hotel;
  Firms({
    required this.id,
    required this.firm_name,
    required this.hotel
  });

  factory Firms.fromJson(Map<dynamic,dynamic> json, String key){
    return Firms(id: key, firm_name: json["firm_name"] as String, hotel: json["hotel"] as String);
  }

}