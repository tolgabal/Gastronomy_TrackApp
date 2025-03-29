import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class DisinProcessInfoCubit extends Cubit{

  DisinProcessInfoCubit():super(0);
  var DPRepo =ProcessAssetDaoRepository();

  Future<void> disinProcessUpdate(String id, String asset_name, int piece, int procTime, String procType, String section,String piece_type, String date, String hotel) async{
    await DPRepo.disinProcessUpdate(id, asset_name, piece, procTime, procType, section,piece_type,date, hotel);
  }

}