import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class DisinfectionInfoCubit extends Cubit{

  DisinfectionInfoCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> disinUpdate(String id,String asset_name, String hotel)async{
    await ALRepo.disinUpdate(id, asset_name, hotel);
  }
}