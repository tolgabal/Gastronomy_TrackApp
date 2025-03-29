import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/thawingprocess.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class ThawingProcListCubit extends Cubit<List<ThawingProcess>>{
  ThawingProcListCubit() : super(<ThawingProcess>[]);

  var collectionThawingProcAssets = FirebaseFirestore.instance.collection("thawingprocasset");
  var TPRepo = ProcessAssetDaoRepository();

  Future<void> thawingLoad(String hotel, String section) async{
    collectionThawingProcAssets.snapshots().listen((event) {
      var ColdPreAssetList = <ThawingProcess>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ThawingProcess.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase() && asset.section_name == section){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => b.asset_time_one.compareTo(a.asset_time_one));
      emit(ColdPreAssetList);
    });
  }

  Future<void> thawingProcessSearch(String word, String hotel, String section) async{
    collectionThawingProcAssets.snapshots().listen((event) {
      var ColdPreAssetList = <ThawingProcess>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ThawingProcess.fromJson(data, key);


        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase() && asset.section_name == section){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(ColdPreAssetList);
    });
  }
  Future<void> thawingProcDelete(String id) async{
    await TPRepo.thawingProcDelete(id);
  }
}