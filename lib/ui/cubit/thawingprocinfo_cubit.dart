import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class ThawingProcInfoCubit extends Cubit {
  ThawingProcInfoCubit() : super(0);
  var TPRepo = ProcessAssetDaoRepository();

  Future<void> thawingProcUpdate(
      String id,
      String section_name,
      double asset_env_temp,
      String user_name,
      String asset_result,
      String asset_name,
      String asset_party_no,
      String asset_exp_no,
      int asset_quantity,
      double asset_temp_one,
      String asset_time_one,
      double asset_thawing_temp_one,
      String asset_thawing_time_one,
      double asset_thawing_temp_two,
      String asset_thawing_time_two,
      double asset_thawing_temp_three,
      String asset_thawing_time_three,
      double asset_process_temp,
      String asset_process_time,
      String asset_sending_place,
      int asset_sending_quantity,
      String asset_sending_process_type,
      double asset_sending_place_temp,
      int kalan,
      String hotel,) async {
    await TPRepo.thawingProcUpdate(
       id,
       section_name,
       asset_env_temp,
       user_name,
       asset_result,
       asset_name,
       asset_party_no,
       asset_exp_no,
       asset_quantity,
       asset_temp_one,
       asset_time_one,
       asset_thawing_temp_one,
       asset_thawing_time_one,
       asset_thawing_temp_two,
       asset_thawing_time_two,
       asset_thawing_temp_three,
       asset_thawing_time_three,
       asset_process_temp,
       asset_process_time,
       asset_sending_place,
       asset_sending_quantity,
       asset_sending_process_type,
       asset_sending_place_temp,
       kalan,
       hotel,);
  }
}
