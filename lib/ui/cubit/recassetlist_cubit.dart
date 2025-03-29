import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/receivingasset.dart';
import 'package:gastrobluecheckapp/data/repo/receivingassetdao_repository.dart';

class RecAssetlistCubit extends Cubit<List<ReceivingAsset>>{
  RecAssetlistCubit():super(<ReceivingAsset>[]);

  var RARepo = ReceivingAssetDaoRepository();

  var collectionRecAssets = FirebaseFirestore.instance.collection("receivingasset");

  Future<void> loadAssets(String hotel) async {
    collectionRecAssets.snapshots().listen((event) {
      var RecAssetList = <ReceivingAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ReceivingAsset.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          RecAssetList.add(asset);
        }

      }
      RecAssetList.sort((a, b) => b.rec_date.compareTo(a.rec_date));
      emit(RecAssetList);
    });
  }

  Future<void> search(String word, String hotel) async {
    collectionRecAssets.snapshots().listen((event) {
      var RecAssetList = <ReceivingAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ReceivingAsset.fromJson(data, key);


        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          RecAssetList.add(asset);
        }
      }
      RecAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(RecAssetList);
    });
  }

  Future<void> delete(String id) async {
    await RARepo.recAssetDelete(id);
  }
}