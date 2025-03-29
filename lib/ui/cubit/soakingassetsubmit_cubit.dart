import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class SoakingAssetSubmitCubit extends Cubit{

  SoakingAssetSubmitCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> soakingSubmit(String asset_name, String hotel) async{
    ALRepo.soakingSubmit(asset_name, hotel);
  }
}