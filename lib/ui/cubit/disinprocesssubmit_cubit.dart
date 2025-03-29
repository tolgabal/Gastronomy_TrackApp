import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class DisinProcessAssetSubmitCubit extends Cubit{

  DisinProcessAssetSubmitCubit():super(0);
  var DPRepo = ProcessAssetDaoRepository();

  Future<void> disinProcessSubmit(String asset_name, int piece, int procTime, String procType, String section, String piece_type, String date,String user_name, String hotel) async{
    DPRepo.disinProcessSubmit(asset_name, piece, procTime, procType, section, piece_type,date,user_name, hotel);
  }

}