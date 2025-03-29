import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class BanketSubmitCubit extends Cubit{

  BanketSubmitCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> banketSubmit(String banket_name, String hotel) async{
    ALRepo.banketSubmit(banket_name, hotel);
  }
}