import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class DisinfectionAssetSubmitCubit extends Cubit{

  DisinfectionAssetSubmitCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> disinSubmit(String asset_name, String hotel) async{
    ALRepo.disinSubmit(asset_name, hotel);
  }
}