import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/disinfectionprocessasset.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class DisinProcessListCubit extends Cubit<List<DisinfectionProcessAsset>>{

  DisinProcessListCubit():super(<DisinfectionProcessAsset>[]);

  var collectionDisinProcAssets = FirebaseFirestore.instance.collection("disinprocasset");
  var DPRepo = ProcessAssetDaoRepository();

  Future<void> disinLoadAsset(String hotel, String section) async{
    collectionDisinProcAssets.snapshots().listen((event) {
      var disinProcList = <DisinfectionProcessAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = DisinfectionProcessAsset.fromJson(data, key);

        if(asset.hotel.toLowerCase() == hotel.toLowerCase() && asset.section == section){
        disinProcList.add(asset);
        }
      }
      disinProcList.sort((a, b) => b.submit_date.compareTo(a.submit_date));
      emit(disinProcList);
    });
  }

  Future<void> disinProcessSearch(String word, String hotel, String section) async{
    collectionDisinProcAssets.snapshots().listen((event) {
      var ColdPreAssetList = <DisinfectionProcessAsset>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = DisinfectionProcessAsset.fromJson(data, key);


        if(asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.hotel.toLowerCase() == hotel.toLowerCase() && asset.section == section){
          ColdPreAssetList.add(asset);
        }
      }
      ColdPreAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(ColdPreAssetList);
    });
  }

  Future<void> disinProcessDelete(String id) async{
    await DPRepo.disinProcessDelete(id);
  }
}