class ThawingProcess {
  String id;
  String section_name;
  double asset_env_temp;
  String user_name;
  String asset_result;
  String asset_name;
  String asset_party_no;
  String asset_exp_no;
  int asset_quantity;
  double asset_temp_one;
  String asset_time_one;
  double asset_thawing_temp_one;
  String asset_thawing_time_one;
  double asset_thawing_temp_two;
  String asset_thawing_time_two;
  double asset_thawing_temp_three;
  String asset_thawing_time_three;
  double asset_process_temp;
  String asset_process_time;
  String asset_sending_place;
  int asset_sending_quantity;
  String asset_sending_process_type;
  double asset_sending_place_temp;
  int kalan;
  String hotel;

  ThawingProcess(
    this.id,
    this.section_name,
    this.asset_env_temp,
    this.user_name,
    this.asset_result,
    this.asset_name,
    this.asset_party_no,
    this.asset_exp_no,
    this.asset_quantity,
    this.asset_temp_one,
    this.asset_time_one,
    this.asset_thawing_temp_one,
    this.asset_thawing_time_one,
    this.asset_thawing_temp_two,
    this.asset_thawing_time_two,
    this.asset_thawing_temp_three,
    this.asset_thawing_time_three,
    this.asset_process_temp,
    this.asset_process_time,
    this.asset_sending_place,
    this.asset_sending_quantity,
    this.asset_sending_process_type,
    this.asset_sending_place_temp,
    this.kalan,
    this.hotel,
  );

  factory ThawingProcess.fromJson(Map<dynamic, dynamic> json, String key) {
    return ThawingProcess(
      key,
      json["section_name"] as String,
      json["asset_env_temp"] as double,
      json["user_name"] as String,
      json["asset_result"] as String,
      json["asset_name"] as String,
      json["asset_party_no"] as String,
      json["asset_exp_no"] as String,
      json["asset_quantity"] as int,
      json["asset_temp_one"] as double,
      json["asset_time_one"] as String,
      json["asset_thawing_temp_one"] as double,
      json["asset_thawing_time_one"] as String,
      json["asset_thawing_temp_two"] as double,
      json["asset_thawing_time_two"] as String,
      json["asset_thawing_temp_three"] as double,
      json["asset_thawing_time_three"] as String,
      json["asset_process_temp"] as double,
      json["asset_process_time"] as String,
      json["asset_sending_place"] as String,
      json["asset_sending_quantity"] as int,
      json["asset_sending_process_type"] as String,
      json["asset_sending_place_temp"] as double,
      json["kalan"] as int,
      json["hotel"] as String,
    );
  }
}
