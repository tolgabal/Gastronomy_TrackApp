class BuffedTimesAsset {
  String id;
  String sabah_baslangic;
  String sabah_bitis;
  String ogle_baslangic;
  String ogle_bitis;
  String aksam_baslangic;
  String aksam_bitis;
  String hotel;

  BuffedTimesAsset(
      {required this.id,
      required this.sabah_baslangic,
      required this.sabah_bitis,
      required this.ogle_baslangic,
      required this.ogle_bitis,
      required this.aksam_baslangic,
      required this.aksam_bitis,
      required this.hotel});
  factory BuffedTimesAsset.fromJson(Map<dynamic, dynamic> json, String key) {
    return BuffedTimesAsset(
        id: key,
        sabah_baslangic: json["sabah_baslangic"] as String,
        sabah_bitis: json["sabah_bitis"] as String,
        ogle_baslangic: json["ogle_baslangic"] as String,
        ogle_bitis: json["ogle_bitis"] as String,
        aksam_baslangic: json["aksam_baslangic"] as String,
        aksam_bitis: json["aksam_bitis"] as String,
        hotel: json["hotel"] as String);
  }
}
