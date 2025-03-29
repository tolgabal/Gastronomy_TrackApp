import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class SoakingAssetInfoCubit extends Cubit{

  SoakingAssetInfoCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> soakingUpdate(String asset_id, String asset_name, String hotel) async{
    await ALRepo.soakingUpdate(asset_id, asset_name, hotel);
  }
}