import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class FirmsSubmitCubit extends Cubit{

  FirmsSubmitCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> FirmSubmit(String firm_name, String hotel) async{
    ALRepo.firmSubmit(firm_name, hotel);
  }
}