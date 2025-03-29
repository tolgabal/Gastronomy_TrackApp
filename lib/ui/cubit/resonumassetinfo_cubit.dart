import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/assetlistsdao_repository.dart';

class ResoNumAssetInfoCubit extends Cubit{
  ResoNumAssetInfoCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> resoNumUpdate(String id, String reso_num_name,String hotel) async {
    await ALRepo.resoNumUpdate(id, reso_num_name, hotel);
  }

}