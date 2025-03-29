import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';
import '../../data/entity/coldpresentationasset.dart';

class ColdPreAssetListCubit extends Cubit<List<ColdPresentationAsset>>{

  ColdPreAssetListCubit():super(<ColdPresentationAsset>[]);

  var collectionColdPreAssets = FirebaseFirestore.instance.collection("coldpreasset");

  var ALRepo =AssetListDaoRepository();

  Future<void> coldLoadAsset(String hotel) async{
    collectionColdPreAssets.snapshots().listen((event) {
      var ColdPreAssetList = <ColdPresentationAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ColdPresentationAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(ColdPreAssetList);
    });
  }

  Future<void> coldSearch(String word, String hotel) async{
    collectionColdPreAssets.snapshots().listen((event) {
      var ColdPreAssetList = <ColdPresentationAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ColdPresentationAsset.fromJson(data, key);


        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(ColdPreAssetList);
    });
  }

  Future<void> coldDelete(String id) async{
    await ALRepo.coldDelete(id);
  }
}