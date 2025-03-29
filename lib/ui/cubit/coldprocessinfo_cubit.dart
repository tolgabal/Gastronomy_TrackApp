import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class ColdProcessInfoCubit extends Cubit {

  ColdProcessInfoCubit(): super(0);
  var CPRepo = ProcessAssetDaoRepository();

  Future<void> coldProcUpdate(String id,String asset_name,  String user_name,  int sample,  int asset_quantity,  String cold_room_name,  String cold_buffed_no,  double asset_presentation_temp,  String asset_presentation_time,  double cold_pre_start_temp,  String cold_pre_start_time,  String cold_pre_end_time,  double cold_pre_end_temp,  double cold_room_temp_one,  String cold_room_time_one,  double cold_room_temp_two,  String cold_room_time_two,  double cold_buffed_temp_one,  String cold_buffed_time_one,  double cold_buffed_temp_two,  String cold_buffed_time_two,  double cold_buffed_temp_three,  String cold_buffed_time_three,  String first_buffed_status,  double first_buffed_temp,String first_buffed_time,  double cold_room_temp_three,  String cold_room_time_three,  double cold_buffed_temp_four,  String cold_buffed_time_four,  double cold_buffed_temp_five,  String cold_buffed_time_five,
      double cold_buffed_temp_six, String cold_buffed_time_six, String asset_status,String hotel, String section, double cold_room_temp_four,  String cold_room_time_four) async{
    await CPRepo.coldProcessUpdate(id, asset_name, user_name, sample, asset_quantity, cold_room_name, cold_buffed_no, asset_presentation_temp, asset_presentation_time, cold_pre_start_temp, cold_pre_start_time, cold_pre_end_time, cold_pre_end_temp, cold_room_temp_one, cold_room_time_one, cold_room_temp_two, cold_room_time_two, cold_buffed_temp_one, cold_buffed_time_one, cold_buffed_temp_two, cold_buffed_time_two, cold_buffed_temp_three, cold_buffed_time_three, first_buffed_status, first_buffed_temp, first_buffed_time, cold_room_temp_three, cold_room_time_three, cold_buffed_temp_four, cold_buffed_time_four, cold_buffed_temp_five, cold_buffed_time_five, cold_buffed_temp_six, cold_buffed_time_six, asset_status,hotel,section, cold_room_temp_four,  cold_room_time_four);
  }
}