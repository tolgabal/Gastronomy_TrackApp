import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/banketasset.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class BanketListCubit extends Cubit<List<BanketAsset>>{

  BanketListCubit():super(<BanketAsset>[]);
  var  collectionBanketAssets = FirebaseFirestore.instance.collection("banketasset");
  var ALRepo = AssetListDaoRepository();


  Future<void> banketLoadAsset(String hotel) async{
    collectionBanketAssets.snapshots().listen((event) {
      var BanketAssetList = <BanketAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = BanketAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          BanketAssetList.add(asset);
        }
      }
      BanketAssetList.sort((a, b) => a.banket_name.compareTo(b.banket_name));
      emit(BanketAssetList);
    });
  }

  Future<void> banketSearch(String word, String hotel) async{
    collectionBanketAssets.snapshots().listen((event) {
      var BanketAssetList = <BanketAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = BanketAsset.fromJson(data, key);


        if(asset.banket_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase()){
          BanketAssetList.add(asset);
        }
      }
      BanketAssetList.sort((a, b) => a.banket_name.compareTo(b.banket_name));
      emit(BanketAssetList);
    });
  }

  Future<void> banketDelete(String id) async{
    await ALRepo.banketDelete(id);
  }
}