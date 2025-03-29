import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class BuffedTimesAssetSubmitCubit extends Cubit{

  BuffedTimesAssetSubmitCubit():super(0);
  var BTRepo = AssetListDaoRepository();

  Future<void> buffedTimesSubmit(String sabah_baslangic, String sabah_bitis, String ogle_baslangic, String ogle_bitis, String aksam_baslangic, String aksam_bitis,String hotel) async{
    BTRepo.buffedTimesSubmit(sabah_baslangic,sabah_bitis,ogle_baslangic,ogle_bitis,aksam_baslangic,aksam_bitis, hotel);
  }

}