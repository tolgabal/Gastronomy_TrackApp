import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class HotPreAssetSubmitCubit extends Cubit{
  HotPreAssetSubmitCubit():super(0);

  var ALRepo = AssetListDaoRepository();

  Future<void> submit(String asset_name, int reuse_isactive, String hotel) async {
    ALRepo.submit(asset_name, reuse_isactive, hotel);
  }
}