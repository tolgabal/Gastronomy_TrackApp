import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/firms.dart';
import 'package:gastrobluecheckapp/data/repo/assetlistsdao_repository.dart';

class FirmsListCubit extends Cubit<List<Firms>> {
  FirmsListCubit() : super(<Firms>[]);
  var ALRepo = AssetListDaoRepository();

  var collectionFirms = FirebaseFirestore.instance.collection("firms");

  Future<void> loadFirms(String hotel) async {
    collectionFirms.snapshots().listen((event) {
      var FirmList = <Firms>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = Firms.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          FirmList.add(asset);
        }
      }
      FirmList.sort((a, b) => a.firm_name.compareTo(b.firm_name));
      emit(FirmList);
    });
  }

  Future<void> firmSearch(String word, String hotel) async {
    collectionFirms.snapshots().listen((event) {
      var FirmList = <Firms>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var firm = Firms.fromJson(data, key);

        if(firm.firm_name.toLowerCase().contains(word.toLowerCase()) && firm.hotel.toLowerCase() == hotel.toLowerCase()){
          FirmList.add(firm);
        }
      }
      FirmList.sort((a, b) => a.firm_name.compareTo(b.firm_name));
      emit(FirmList);
    });
  }

  Future<void> firmDelete(String id) async {
    await ALRepo.firmDelete(id);
  }
}
