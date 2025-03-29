import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/buffedtimesasset.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class BuffedTimesAssetListCubit extends Cubit<List<BuffedTimesAsset>>{

  BuffedTimesAssetListCubit():super(<BuffedTimesAsset>[]);
  var collectionBuffedTimesAssets = FirebaseFirestore.instance.collection("buffedtimesasset");
  var BTRepo = AssetListDaoRepository();

  Future<void> bufedTimesLoadAssets(String hotel) async{
    collectionBuffedTimesAssets.snapshots().listen((event) {
      var BuffedTimesAssetList = <BuffedTimesAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = BuffedTimesAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          BuffedTimesAssetList.add(asset);
        }
      }
      BuffedTimesAssetList.sort((a, b) => a.sabah_baslangic.compareTo(b.sabah_baslangic));
      emit(BuffedTimesAssetList);
    });
  }

  Future<void> buffedTimesSearch(String word, String hotel) async{
    collectionBuffedTimesAssets.snapshots().listen((event) {
      var BuffedTimesAssetList = <BuffedTimesAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = BuffedTimesAsset.fromJson(data, key);

        if(asset.sabah_baslangic.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          BuffedTimesAssetList.add(asset);
        }
      }
      BuffedTimesAssetList.sort((a, b) => a.sabah_baslangic.compareTo(b.sabah_baslangic));
      emit(BuffedTimesAssetList);
    });
  }

  Future<void> buffedTimesDelete(String id) async{
    await BTRepo.buffedTimesDelete(id);
  }

  Future<BuffedTimesAsset> buffedTimeByHotel(String hotel) async{
    var BuffedTimesAssetList = <BuffedTimesAsset>[];
    collectionBuffedTimesAssets.snapshots().listen((event) {
      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = BuffedTimesAsset.fromJson(data, key);

        if( asset.hotel.toLowerCase() == hotel.toLowerCase()){
          BuffedTimesAssetList.add(asset);
        }
      }
    });
    if(BuffedTimesAssetList.isNotEmpty){
      BuffedTimesAsset bTA = new BuffedTimesAsset(id: "amcık", sabah_baslangic: "0", sabah_bitis: "0", ogle_baslangic: "0", ogle_bitis: "0", aksam_baslangic: "0", aksam_bitis: "0", hotel: hotel);
      return bTA;
    }
    return BuffedTimesAssetList.first;
  }
}