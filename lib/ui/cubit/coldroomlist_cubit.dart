import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldroomasset.dart';

import '../../data/repo/assetlistsdao_repository.dart';

class ColdRoomListCubit extends Cubit<List<ColdRoomAsset>>{
  ColdRoomListCubit():super(<ColdRoomAsset>[]);

  var collectionColdRoomAsset = FirebaseFirestore.instance.collection("coldroomasset");
  var ALRepo =AssetListDaoRepository();

  Future<void> coldRoomLoadAsset(String hotel) async{
    collectionColdRoomAsset.snapshots().listen((event) {
      var ColdRoomAssetList = <ColdRoomAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ColdRoomAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          ColdRoomAssetList.add(asset);
        }
      }
      ColdRoomAssetList.sort((a, b) => a.cold_room_name.compareTo(b.cold_room_name));
      emit(ColdRoomAssetList);
    });
  }

  Future<void> coldRoomSearch(String word, String hotel) async{
    collectionColdRoomAsset.snapshots().listen((event) {
      var ColdRoomAssetList = <ColdRoomAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = ColdRoomAsset.fromJson(data, key);


        if(asset.cold_room_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          ColdRoomAssetList.add(asset);
        }
      }
      ColdRoomAssetList.sort((a, b) => a.cold_room_name.compareTo(b.cold_room_name));
      emit(ColdRoomAssetList);
    });
  }

  Future<void> coldRoomDelete(String id) async{
    await ALRepo.coldRoomDelete(id);
  }
}
