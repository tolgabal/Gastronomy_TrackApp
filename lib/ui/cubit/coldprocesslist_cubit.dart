import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldprocessasset.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class ColdProcessListCubit extends Cubit<List<ColdProcessAsset>>{

  ColdProcessListCubit(): super(<ColdProcessAsset>[]);

  var collectionColdProcAssets = FirebaseFirestore.instance.collection("coldprocess");
  var CPRepo = ProcessAssetDaoRepository();

  Future<void> coldProcLoad(String hotel, String section) async{
    collectionColdProcAssets.snapshots().listen((event) {
      var ColdPreAssetList = <ColdProcessAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ColdProcessAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase() && asset.section == section){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => b.asset_presentation_time.compareTo(a.asset_presentation_time));
      emit(ColdPreAssetList);
    });
  }

  Future<void> coldProcSearch(String word, String hotel, String section) async{
    collectionColdProcAssets.snapshots().listen((event) {
      var ColdPreAssetList = <ColdProcessAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ColdProcessAsset.fromJson(data, key);


        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase() && asset.section == section){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(ColdPreAssetList);
    });
  }

  Future<void> coldProcDelete(String id) async{
    await CPRepo.coldProcessDelete(id);
  }
}