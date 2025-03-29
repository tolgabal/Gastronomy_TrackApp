class ReceivingAsset {
  String id;
  String rec_date;
  String firm_id;
  String asset_name;
  String brand;
  String prod_date;
  String exp_date;
  String seri_num;
  String fat_num;
  int car_hygene;
  int label_cond;
  int asset_quant;
  String quant_type;
  int car_heat;
  int asset_heat;
  int agreement;
  String personnel;
  String note;
  String hotel;
  String username;

  ReceivingAsset(
      this.id,
      this.rec_date,
      this.firm_id,
      this.asset_name,
      this.brand,
      this.prod_date,
      this.exp_date,
      this.seri_num,
      this.fat_num,
      this.car_hygene,
      this.label_cond,
      this.asset_quant,
      this.quant_type,
      this.car_heat,
      this.asset_heat,
      this.agreement,
      this.personnel,
      this.note,
      this.hotel,
      this.username);

  factory ReceivingAsset.fromJson(Map<dynamic,dynamic> json, String key){
    return ReceivingAsset(key, json["rec_date"] as String, json["firm_id"] as String, json["asset_name"] as String, json["brand"] as String, json["prod_date"] as String, json["exp_date"] as String, json["seri_num"] as String, json["fat_num"] as String, json["car_hygene"] as int, json["label_cond"] as int, json["asset_quant"] as int, json["quant_type"] as String, json["car_heat"] as int, json["asset_heat"] as int, json["agreement"] as int, json["personnel"] as String, json["note"] as String, json["hotel"] as String, json["username"] as String);
  }
}