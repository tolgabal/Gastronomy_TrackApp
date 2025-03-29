import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/roledao_repository.dart';

import '../../data/entity/role.dart';
import '../../sqlite/db_helper.dart';

class RoleConfigListCubit extends Cubit <List<Role>>{
  RoleConfigListCubit():super(<Role>[]);
  var RRepo = RoleDaoRepository();

  var collectionRoles = FirebaseFirestore.instance.collection("role");

  Future<void> loadRoles(String hotel) async {
    collectionRoles.snapshots().listen((event) {
      var RoleList = <Role>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var asset = Role.fromJson(data, key);
        if(asset.hotel.toLowerCase() == hotel.toLowerCase()){
          RoleList.add(asset);
        }

      }
      RoleList.sort((a, b) => a.role_name.compareTo(b.role_name));
      emit(RoleList);
    });
  }

  Future<void> search(String word, String hotel) async {
    collectionRoles.snapshots().listen((event) {
      var RoleList = <Role>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var role = Role.fromJson(data, key);

        if(role.role_name.toLowerCase().contains(word.toLowerCase()) && role.hotel.toLowerCase() == hotel.toLowerCase()){
          RoleList.add(role);
        }
      }
      RoleList.sort((a, b) => a.role_name.compareTo(b.role_name));
      emit(RoleList);
    });
  }

  Future<void> delete(String id) async {
    await RRepo.delete(id);
  }

  Future<Role?> loadRoleById(String id) async {
    var RoleList = <Role>[];
    collectionRoles.snapshots().listen((event) {


      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var role = Role.fromJson(data, key);


        if(role.id == id){
          RoleList.add(role);
        }
      }

    });
    if (RoleList.isEmpty) {
      return null;
    }

    var raw = RoleList.first;
    return Role(
      raw.id,
      raw.role_name,
      raw.hotpre,
      raw.coldpre,
      raw.disinf,
      raw.soak,
      raw.candr,
      raw.receiving,
      raw.disinf_list,
      raw.candr_list,
      raw.hotpre_list,
      raw.coldpre_list,
      raw.receiving_firms,
      raw.personnel,
      raw.buffedtimes,
      raw.roleconfig,
      raw.reports,
      raw.devices,
      raw.updateuser,
      raw.hotel
    );
  }

  Future<Role?> loadRoleByIdForLogin(String id) async {
    // Belirtilen ID ile rolü almak için koleksiyondaki tüm belgeleri sorgula
    final snapshot = await collectionRoles.where('id', isEqualTo: id).get();

    // Rol bulunursa, rolü döndür
    if (snapshot.docs.isNotEmpty) {
      var document = snapshot.docs.first; // İlk belgeyi al
      var key = document.id; // Belge anahtarı
      var data = document.data(); // Belge verisi
      return Role.fromJson(data, key); // Rol nesnesine dönüştür ve döndür
    }

    return null; // Rol bulunamazsa null döndür
  }

}