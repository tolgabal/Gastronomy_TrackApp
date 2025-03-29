import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/assetlistsdao_repository.dart';

class BuffedTimesAssetInfoCubit extends Cubit{
  BuffedTimesAssetInfoCubit():super(0);
  var BTRepo = AssetListDaoRepository();

  Future<void> buffedTimesUpdate(String asset_id, String sabah_baslangic, String sabah_bitis, String ogle_baslangic, String ogle_bitis, String aksam_baslangic, String aksam_bitis, String hotel)async{
    await BTRepo.buffedTimesUpdate(asset_id, sabah_baslangic,sabah_bitis,ogle_baslangic,ogle_bitis,aksam_baslangic,aksam_bitis, hotel);
  }
}