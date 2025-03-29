import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class FirmsInfoCubit extends Cubit{
  FirmsInfoCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> FirmUpdate(String firm_id,String firm_name, String hotel) async{
    await ALRepo.firmUpdate(firm_id, firm_name, hotel);
  }
}