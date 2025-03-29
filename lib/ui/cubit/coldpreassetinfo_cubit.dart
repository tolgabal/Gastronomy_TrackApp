import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class ColdPreAssetInfoCubit extends Cubit{
  ColdPreAssetInfoCubit():super(0);

  var ALRepo = AssetListDaoRepository();

  Future<void> coldUpdate(String asset_id,String asset_name,int reuse_isactive, String hotel)async{
    await ALRepo.coldUpdate(asset_id, asset_name, reuse_isactive, hotel);
  }
}