import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/disinfectionasset.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class DisinfectionAssetListCubit extends Cubit<List<DisinfectionAsset>>{

  DisinfectionAssetListCubit():super(<DisinfectionAsset>[]);

  var collectionDisinAssets = FirebaseFirestore.instance.collection("disinfectionasset");

  var ALRepo = AssetListDaoRepository();

  Future<void> disinLoadAssets(String hotel) async{
    collectionDisinAssets.snapshots().listen((event) {
      var DisinAssetList = <DisinfectionAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = DisinfectionAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          DisinAssetList.add(asset);
        }
      }
      DisinAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(DisinAssetList);
    });
  }

  Future<void> disinSearch(String word, String hotel) async{
    collectionDisinAssets.snapshots().listen((event) {
      var DisinAssetList = <DisinfectionAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = DisinfectionAsset.fromJson(data, key);

        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          DisinAssetList.add(asset);
        }
      }
      DisinAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(DisinAssetList);
    });
  }

  Future<void> disinDelete(String id) async{
    await ALRepo.disinDelete(id);
  }
}