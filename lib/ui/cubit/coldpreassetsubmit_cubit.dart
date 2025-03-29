import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class ColdPreAssetSubmitCubit extends Cubit{

  ColdPreAssetSubmitCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> coldSubmit(String asset_name, int reuse_isactive, String hotel) async{
    ALRepo.coldSubmit(asset_name, reuse_isactive, hotel);
  }
}