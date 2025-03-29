import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/resonumasset.dart';

import '../../data/repo/assetlistsdao_repository.dart';

class ResoNumAssetListCubit extends Cubit<List<ResoNumAsset>>{
  ResoNumAssetListCubit(): super(<ResoNumAsset>[]);
  var collectionResoNumAsset = FirebaseFirestore.instance.collection("resonumasset");

  var ALRepo = AssetListDaoRepository();

  Future<void> loadAssets(String hotel) async {
    collectionResoNumAsset.snapshots().listen((event) {
      var ResoNumAssetList = <ResoNumAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ResoNumAsset.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          ResoNumAssetList.add(asset);
        }
      }
      ResoNumAssetList.sort((a, b) => a.reso_num_name.compareTo(b.reso_num_name));
      emit(ResoNumAssetList);
    });
  }

  Future<void> search(String word, String hotel) async {
    collectionResoNumAsset.snapshots().listen((event) {
      var ResoNumAssetList = <ResoNumAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ResoNumAsset.fromJson(data, key);


        if(asset.reso_num_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          ResoNumAssetList.add(asset);
        }
      }
      ResoNumAssetList.sort((a, b) => a.reso_num_name.compareTo(b.reso_num_name));
      emit(ResoNumAssetList);
    });
  }

  Future<void> resoNumDelete(String id) async {
    await ALRepo.resoNumDelete(id);
  }
}
