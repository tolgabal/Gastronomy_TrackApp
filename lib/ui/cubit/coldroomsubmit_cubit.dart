import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class ColdRoomSubmitCubit extends Cubit{

  ColdRoomSubmitCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> coldRoomSubmit(String cold_room_name,String hotel) async{
    ALRepo.coldRoomSubmit(cold_room_name, hotel);
  }
}