import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/sqlite/db_helper.dart';

import '../entity/section.dart';

class UserDaoRepository {
  var collectionSections = FirebaseFirestore.instance.collection("section");
  var collectionUsers = FirebaseFirestore.instance.collection("user");
  Future<void> submit(String role_id, String section_id, String username, String password, String name, String hotel) async {
    var newUser = Map<String,dynamic>();
    newUser["role_id"] = role_id;
    newUser["section_id"] = section_id;
    newUser["username"] = username;
    newUser["password"] = password;
    newUser["name"] = name;
    newUser["hotel"] = hotel;
    DocumentReference docRef = await collectionUsers.add(newUser);
    // Document ID'yi al ve yeni role ekleyin
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> update(String id, String role_id, String section_id, String username, String password, String name, String hotel) async {
    var updUser = Map<String, dynamic>();
    updUser["role_id"] = role_id;
    updUser["section_id"] = section_id;
    updUser["username"] = username;
    updUser["password"] = password;
    updUser["name"] = name;
    updUser["hotel"] = hotel;
    collectionUsers.doc(id).update(updUser);
  }

  Future<void> delete(String id) async {
    collectionUsers.doc(id).delete();
  }

  Future<List<User>> loadUsers() async {
    var userList = <User>[];
    collectionUsers.snapshots().listen((event) {
      var documents = event.docs;

      for(var document in documents){
        var key = document.id;
        var data = document.data();
        var user = User.fromJson(data, key);
        userList.add(user);
      }

    });
    if(userList.isNotEmpty){
      return userList;
    }
    else{
      var nullList = <User>[];
      nullList.add(User("id", "role_id", "section_id", "username", "password", "name", "hotel"));
      return nullList;
    }
  }

  Future<void> sectionSubmit(String section_name, String hotel) async{
    var newSection = HashMap<String,dynamic>();
    newSection["id"] = "";
    newSection["section_name"] = section_name;
    newSection["hotel"] = hotel;
    DocumentReference docRef = await collectionSections.add(newSection);
    // Document ID'yi al ve yeni role ekleyin
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> sectionUpdate(String id, String section_name, String hotel) async {
    var updSection = HashMap<String,dynamic>();
    updSection["section_name"] = section_name;
    updSection["hotel"] = hotel;
    collectionSections.doc(id).update(updSection);
  }

  Future<void> sectionDelete(String id) async {
    collectionSections.doc(id).delete();
  }
}