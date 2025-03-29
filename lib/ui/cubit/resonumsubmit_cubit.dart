import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/assetlistsdao_repository.dart';

class ResoNumAssetSubmitCubit extends Cubit{

  ResoNumAssetSubmitCubit(): super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> resoNumSubmit(String asset_name, String hotel) async{
    ALRepo.resoNumSubmit(asset_name, hotel);
  }

}