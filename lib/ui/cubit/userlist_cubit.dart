import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/repo/userdao_repository.dart';

import '../../data/entity/user.dart';

class UserListCubit extends Cubit <List<User>>{
  UserListCubit():super(<User>[]);
  var URepo = UserDaoRepository();

  var collectionUsers = FirebaseFirestore.instance.collection("user");

  Future<void> loadUsers(String hotel) async {
    collectionUsers.snapshots().listen((event) {
      var userList = <User>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var user = User.fromJson(data, key);
        if(user.hotel.toLowerCase() == hotel.toLowerCase()){
          userList.add(user);
        }
      }
      userList.sort((a, b) => a.username.compareTo(b.username));
      emit(userList);
    });
  }

  Future<void> loadUsersForLogin() async {
    // Kullanıcı verilerini Firebase'den al
    final snapshot = await collectionUsers.get(); // Anlık dinleme yerine bir kerelik al
    var userList = <User>[]; // Boş bir kullanıcı listesi oluştur

    // Alınan belgeleri döngüye al
    for (var document in snapshot.docs) {
      var key = document.id; // Belge anahtarı
      var data = document.data(); // Belge verisi
      var user = User.fromJson(data, key); // Kullanıcı nesnesine dönüştür
      userList.add(user); // Kullanıcıyı listeye ekle
    }

    emit(userList); // Kullanıcı listesini duruma gönder
  }

  Future<void> search(String word, String hotel) async {
    collectionUsers.snapshots().listen((event) {
      var userList = <User>[];

      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var user = User.fromJson(data, key);


        if(user.username.toLowerCase().contains(word.toLowerCase()) && user.hotel.toLowerCase() == hotel.toLowerCase()){
          userList.add(user);
        }
      }
      userList.sort((a, b) => a.username.compareTo(b.username));
      emit(userList);
    });
  }

  Future<void> delete(String id) async {
    await URepo.delete(id);
  }
}