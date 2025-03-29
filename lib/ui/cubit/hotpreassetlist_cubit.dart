import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/hotpresentationasset.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class HotPreAssetListCubit extends Cubit<List<HotPresentationAsset>>{

HotPreAssetListCubit():super(<HotPresentationAsset>[]);

var collectionHotPreAssets = FirebaseFirestore.instance.collection("hotpreasset");

var ALRepo = AssetListDaoRepository();

  Future<void> loadAssets(String hotel) async {
    collectionHotPreAssets.snapshots().listen((event) {
      var HotPreAssetList = <HotPresentationAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = HotPresentationAsset.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          HotPreAssetList.add(asset);
        }
      }
      HotPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(HotPreAssetList);
    });
  }

Future<void> search(String word, String hotel) async {
  collectionHotPreAssets.snapshots().listen((event) {
    var HotPreAssetList = <HotPresentationAsset>[];

    var documents = event.docs;

    for(var document in documents){
      var key = document.id;
      var data = document.data();
      var asset = HotPresentationAsset.fromJson(data, key);


      if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
        HotPreAssetList.add(asset);
      }
    }
    HotPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
    emit(HotPreAssetList);
  });
}

Future<void> searchDirectly(String word, String hotel) async {
  collectionHotPreAssets.snapshots().listen((event) {
    var HotPreAssetList = <HotPresentationAsset>[];

    var documents = event.docs;

    for(var document in documents){
      var key = document.id;
      var data = document.data();
      var asset = HotPresentationAsset.fromJson(data, key);


      if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
        HotPreAssetList.add(asset);
      }
    }
    HotPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
    emit(HotPreAssetList);
  });
}

Future<void> delete(String id) async {
  await ALRepo.delete(id);
}
}