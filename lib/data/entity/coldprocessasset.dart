class ColdProcessAsset {
  String id;
  String asset_name;
  String user_name;
  int sample;
  int asset_quantity;
  String cold_room_name;
  String cold_buffed_no;
  double asset_presentation_temp;
  String asset_presentation_time;
  double cold_pre_start_temp;
  String cold_pre_start_time;
  String cold_pre_end_time;
  double cold_pre_end_temp;
  double cold_room_temp_one;
  String cold_room_time_one;
  double cold_room_temp_two;
  String cold_room_time_two;
  double cold_buffed_temp_one;
  String cold_buffed_time_one;
  double cold_buffed_temp_two;
  String cold_buffed_time_two;
  double cold_buffed_temp_three;
  String cold_buffed_time_three;
  String first_buffed_status;
  double first_buffed_temp;
  String first_buffed_time;
  double cold_room_temp_three;
  String cold_room_time_three;
  double cold_buffed_temp_four;
  String cold_buffed_time_four;
  double cold_buffed_temp_five;
  String cold_buffed_time_five;
  double cold_buffed_temp_six;
  String cold_buffed_time_six;
  String asset_status;
  String hotel;
  String section;
  double cold_room_temp_four;
  String cold_room_time_four;


  ColdProcessAsset(
      {required this.id,
      required this.asset_name,
      required this.user_name,
      required this.sample,
      required this.asset_quantity,
      required this.cold_room_name,
      required this.cold_buffed_no,
      required this.asset_presentation_temp,
      required this.asset_presentation_time,
      required this.cold_pre_start_temp,
      required this.cold_pre_start_time,
      required this.cold_pre_end_time,
      required this.cold_pre_end_temp,
      required this.cold_room_temp_one,
      required this.cold_room_time_one,
      required this.cold_room_temp_two,
      required this.cold_room_time_two,
      required this.cold_buffed_temp_one,
      required this.cold_buffed_time_one,
      required this.cold_buffed_temp_two,
      required this.cold_buffed_time_two,
      required this.cold_buffed_temp_three,
      required this.cold_buffed_time_three,
      required this.first_buffed_status,
      required this.first_buffed_temp,
      required this.first_buffed_time,
      required this.cold_room_temp_three,
      required this.cold_room_time_three,
      required this.cold_buffed_temp_four,
      required this.cold_buffed_time_four,
      required this.cold_buffed_temp_five,
      required this.cold_buffed_time_five,
      required this.cold_buffed_temp_six,
      required this.cold_buffed_time_six,
      required this.asset_status,
      required this.hotel,
      required this.section,
      required this.cold_room_temp_four,

      required this.cold_room_time_four,
 });
  factory ColdProcessAsset.fromJson(Map<dynamic, dynamic> json, String key) {
    return ColdProcessAsset(
        id: key,
        asset_name: json["asset_name"] as String,
        user_name: json["user_name"] as String,
        sample: json["sample"] as int,
        asset_quantity: json["asset_quantity"] as int,
        cold_room_name: json["cold_room_name"] as String,
        cold_buffed_no: json["cold_buffed_no"] as String,
        asset_presentation_temp: json["asset_presentation_temp"] as double,
        asset_presentation_time: json["asset_presentation_time"] as String,
        cold_pre_start_temp: json["cold_pre_start_temp"] as double,
        cold_pre_start_time: json["cold_pre_start_time"] as String, // Hatalı array yerine JSON anahtarı
        cold_pre_end_time: json["cold_pre_end_time"] as String, // Hatalı array yerine JSON anahtarı
        cold_pre_end_temp: json["cold_pre_end_temp"] as double, // Hatalı array yerine JSON anahtarı
        cold_room_temp_one: json["cold_room_temp_one"] as double,
        cold_room_time_one: json["cold_room_time_one"] as String,
        cold_room_temp_two: json["cold_room_temp_two"] as double,
        cold_room_time_two: json["cold_room_time_two"] as String,
        cold_buffed_temp_one: json["cold_buffed_temp_one"] as double,
        cold_buffed_time_one: json["cold_buffed_time_one"] as String,
        cold_buffed_temp_two: json["cold_buffed_temp_two"] as double,
        cold_buffed_time_two: json["cold_buffed_time_two"] as String,
        cold_buffed_temp_three: json["cold_buffed_temp_three"] as double,
        cold_buffed_time_three: json["cold_buffed_time_three"] as String,
        first_buffed_status: json["first_buffed_status"] as String,
        first_buffed_temp: json["first_buffed_temp"] as double,
        first_buffed_time: json["first_buffed_time"] as String, // Hatalı array yerine JSON anahtarı
        cold_room_temp_three: json["cold_room_temp_three"] as double,
        cold_room_time_three: json["cold_room_time_three"] as String,
        cold_buffed_temp_four: json["cold_buffed_temp_four"] as double,
        cold_buffed_time_four: json["cold_buffed_time_four"] as String,
        cold_buffed_temp_five: json["cold_buffed_temp_five"] as double,
        cold_buffed_time_five: json["cold_buffed_time_five"] as String,
        cold_buffed_temp_six: json["cold_buffed_temp_six"] as double,
        cold_buffed_time_six: json["cold_buffed_time_six"] as String,
        asset_status: json["asset_status"] as String,
        hotel: json["hotel"] as String,
        section: json["section"] as String,
        cold_room_temp_four: json['cold_room_temp_four'] as double,
          cold_room_time_four: json['cold_room_time_four'] as String,
      );
  }
}
