class HotProcessAsset {
  String id;
  int quantity;
  double first_temperature;
  double banket_temperature_one;
  double banket_temperature_two;
  double banket_temperature_three;
  double banket_temperature_four;
  String banket_date_one;
  String banket_date_two;
  String banket_date_three;
  String banket_date_four;
  String asset_name;
  String banket;
  String sample;
  String presentation;
  String user_name;
  String submit_date;
  int process_times;
  String asset_result;
  String hotel;
  double buffed_temp_one;
  double buffed_temp_two;
  double buffed_temp_three;
  double buffed_temp_four;
  double buffed_temp_five;
  double buffed_temp_six;
  String buffed_date_one;
  String buffed_date_two;
  String buffed_date_three;
  String buffed_date_four;
  String buffed_date_five;
  String buffed_date_six;
  double cooling_start_temp;
  double cooling_end_temp;
  String cooling_date;
  String section_name;
  String reso_num;
  String first_buffed_status;
  double cooling_reheat_temp;
  String cooling_reheat_date;
  String cooling_end_date;
  HotProcessAsset({
    required this.id,
    required this.asset_name,
    required this.quantity,
    required this.first_temperature,
    required this.sample,
    required this.banket,
    required this.presentation,
    required this.process_times,
    required this.user_name,
    required this.submit_date,
    required this.banket_temperature_one,
    required this.banket_temperature_two,
    required this.banket_temperature_three,
    required this.banket_temperature_four,
    required this.banket_date_one,
    required this.banket_date_two,
    required this.banket_date_three,
    required this.banket_date_four,
    required this.asset_result,
    required this.hotel,
    required this.buffed_temp_one,
    required this.buffed_temp_two,
    required this.buffed_temp_three,
    required this.buffed_temp_four,
    required this.buffed_temp_five,
    required this.buffed_temp_six,
    required this.buffed_date_one,
    required this.buffed_date_two,
    required this.buffed_date_three,
    required this.buffed_date_four,
    required this.buffed_date_five,
    required this.buffed_date_six,
    required this.cooling_start_temp,
    required this.cooling_end_temp,
    required this.cooling_date,
    required this.section_name,
    required this.reso_num,
    required this.first_buffed_status,
    required this.cooling_end_date,
    required this.cooling_reheat_temp,
    required this.cooling_reheat_date,
  });

  factory HotProcessAsset.fromJson(Map<dynamic, dynamic> json, String key) {
    return HotProcessAsset(
      id: key,
      asset_name: json["asset_name"] as String,
      user_name: json['user_name'] as String,
      quantity: json["quantity"] as int,
      first_temperature: json["first_temperature"] as double,
      banket_temperature_one: json['banket_temperature_one'] as double,
      banket_temperature_two: json['banket_temperature_two'] as double,
      banket_temperature_three: json['banket_temperature_three'] as double,
      banket_temperature_four: json['banket_temperature_four'] as double,
      banket_date_one: json['banket_date_one'] as String,
      banket_date_two: json['banket_date_two'] as String,
      banket_date_three: json['banket_date_three'] as String,
      banket_date_four: json['banket_date_four'] as String,
      sample: json['sample'] as String,
      presentation: json['presentation'] as String,
      submit_date: json['submit_date'] as String,
      process_times: json['process_times'] as int,
      asset_result: json['asset_result'] as String,
      hotel: json['hotel'] as String,
      buffed_temp_one: json['buffed_temp_one'] as double,
      buffed_temp_two: json['buffed_temp_two'] as double,
      buffed_temp_three: json['buffed_temp_three'] as double,
      buffed_temp_four: json['buffed_temp_four'] as double,
      buffed_temp_five: json['buffed_temp_five'] as double,
      buffed_temp_six: json['buffed_temp_six'] as double,
      buffed_date_one: json['buffed_date_one'] as String,
      buffed_date_two: json['buffed_date_two'] as String,
      buffed_date_three: json['buffed_date_three'] as String,
      buffed_date_four: json['buffed_date_four'] as String,
      buffed_date_five: json['buffed_date_five'] as String,
      buffed_date_six: json['buffed_date_six'] as String,
      cooling_start_temp: json['cooling_start_temp'] as double,
      cooling_end_temp: json['cooling_end_temp'] as double,
      cooling_date: json['cooling_date'] as String,
      section_name: json['section_name'] as String,
      reso_num: json['reso_num'] as String,
      first_buffed_status: json['first_buffed_status'] as String,
      banket: json['banket'] as String,
      cooling_end_date: json['cooling_end_date'] as String,
      cooling_reheat_temp: json['cooling_reheat_temp'] as double,
      cooling_reheat_date: json['cooling_reheat_date'] as String,
    );
  }
}
