import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/hotprocessasset.dart';
import 'package:gastrobluecheckapp/data/repo/processassetdao_repository.dart';

class HotProcessListCubit extends Cubit<List<HotProcessAsset>> {

  HotProcessListCubit() : super(<HotProcessAsset>[]);

  var collectionHotProcAssets = FirebaseFirestore.instance.collection("hotprocasset");
  var HPRepo = ProcessAssetDaoRepository();

  // Belirli bir otel için verileri dinleyin ve listeleyin
  Future<void> hotProcessAssetLoad(String hotel, String section) async {
    collectionHotProcAssets
        .where("hotel", isEqualTo: hotel)  // Otel filtreleme doğrudan sorguda yapıldı
        .snapshots()
        .listen((event) {
      var hotProcessAssetList = <HotProcessAsset>[];

      for (var document in event.docs) {
        var key = document.id;
        var data = document.data();
        var asset = HotProcessAsset.fromJson(data, key);

        if(asset.section_name == section){
          hotProcessAssetList.add(asset);
        }
      }
      hotProcessAssetList.sort((a, b) => b.submit_date.compareTo(a.submit_date));
      emit(hotProcessAssetList);
    });
  }

  // Belirli bir kelime ve otel adı için arama
  Future<void> hotProcessSearch(String word, String hotel, String section) async {
    collectionHotProcAssets
        .where("hotel", isEqualTo: hotel)  // Otel filtreleme doğrudan sorguda yapıldı
        .snapshots()
        .listen((event) {
      var hotProcessAssetList = <HotProcessAsset>[];

      for (var document in event.docs) {
        var key = document.id;
        var data = document.data();
        var asset = HotProcessAsset.fromJson(data, key);

        if (asset.asset_name.toLowerCase().contains(word.toLowerCase()) && asset.section_name == section) {
          hotProcessAssetList.add(asset);
        }
      }
      hotProcessAssetList.sort((a, b) => a.asset_name.compareTo(b.asset_name));
      emit(hotProcessAssetList);
    });
  }

  // Asset silme işlemi
  Future<void> hotProcessAssetDelete(String id) async {
    await HPRepo.hotProcessDelete(id);
  }
}
