import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class ColdRoomInfoCubit extends Cubit{

  ColdRoomInfoCubit():super(0);
  var ALRepo = AssetListDaoRepository();

  Future<void> coldRoomUpdate(String cold_room_id, String cold_room_name,String hotel) async{
    await ALRepo.coldRoomUpdate(cold_room_id, cold_room_name, hotel);
  }
}