import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/section.dart';

import '../../data/repo/userdao_repository.dart';

class SectionListCubit extends Cubit<List<Section>>{
  SectionListCubit():super(<Section>[]);
  var URepo = UserDaoRepository();

  var collectionSections = FirebaseFirestore.instance.collection("section");

  Future<void> loadSections(String hotel) async {
    collectionSections.snapshots().listen((event) {
      var sectionList = <Section>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = Section.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          sectionList.add(asset);
        }
      }
      sectionList.sort((a, b) => a.section_name.compareTo(b.section_name));
      emit(sectionList);
    });
  }

  Future<void> sectionSearch(String word, String hotel) async {
    collectionSections.snapshots().listen((event) {
      var sectionList = <Section>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var section = Section.fromJson(data, key);


        if(section.section_name.toLowerCase().contains(word.toLowerCase()) && section.hotel.toLowerCase() == hotel.toLowerCase()){
          sectionList.add(section);
        }
      }
      sectionList.sort((a, b) => a.section_name.compareTo(b.section_name));
      emit(sectionList);
    });
  }

  Future<void> sectionDelete(String id) async {
    await URepo.sectionDelete(id);
  }
}