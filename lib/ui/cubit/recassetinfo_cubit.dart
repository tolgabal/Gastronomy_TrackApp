import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/receivingassetdao_repository.dart';

class RecAssetInfoCubit extends Cubit{
  RecAssetInfoCubit():super(0);

  var RARepo = ReceivingAssetDaoRepository();

  Future<void> update(String id, String rec_date, String firm_id, String asset_name, String brand, String prod_date, String exp_date, String seri_num, String fat_num, int car_hygene, int label_cond, int asset_quant, String quant_type, int car_heat, int asset_heat, int agreement, String personnel, String note, String hotel, String username) async {
    await RARepo.recAssetUpdate(id, rec_date, firm_id, asset_name, brand, prod_date, exp_date, seri_num, fat_num, car_hygene, label_cond, asset_quant, quant_type, car_heat, asset_heat, agreement, personnel, note, hotel, username);
  }
}