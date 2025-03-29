import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class BanketInfoCubit extends Cubit{

  BanketInfoCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> banketUpdate( String banket_id, String banket_name, String hotel) async{
    await ALRepo.banketUpdate(banket_id, banket_name, hotel);
  }
}