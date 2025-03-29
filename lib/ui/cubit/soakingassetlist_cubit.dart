import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/soakingasset.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class SoakingAssetListCubit extends Cubit<List<SoakingAsset>>{

  SoakingAssetListCubit():super(<SoakingAsset>[]);
  var ALRepo = AssetListDaoRepository();

  var collectionSoakingAssets = FirebaseFirestore.instance.collection("soakingasset");


  Future<void> soakingLoadAsset(String hotel) async{
    collectionSoakingAssets.snapshots().listen((event) {
      var SoakingAssetList = <SoakingAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = SoakingAsset.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          SoakingAssetList.add(asset);
        }

      }
      SoakingAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(SoakingAssetList);
    });
  }

  Future<void> soakingSearch(String word, String hotel) async{
    collectionSoakingAssets.snapshots().listen((event) {
      var SoakingAssetList = <SoakingAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = SoakingAsset.fromJson(data, key);

        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          SoakingAssetList.add(asset);
        }
      }
      SoakingAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(SoakingAssetList);
    });
  }

  Future<void> soakingDelete(String id) async{
    await ALRepo.soakingDelete(id);
  }
}