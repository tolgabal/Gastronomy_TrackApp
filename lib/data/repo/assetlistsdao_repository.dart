import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastrobluecheckapp/data/entity/buffedtimesasset.dart';

class AssetListDaoRepository {
  var collectionHotPreAssets =
      FirebaseFirestore.instance.collection("hotpreasset");
  var collectionColdPreAssets =
      FirebaseFirestore.instance.collection("coldpreasset");
  var collectionDisinAssets =
      FirebaseFirestore.instance.collection("disinfectionasset");
  var collectionFirms = FirebaseFirestore.instance.collection("firms");
  var collectionSoakingAssets =
      FirebaseFirestore.instance.collection("soakingasset");
  var collectionBanketAssets =
      FirebaseFirestore.instance.collection("banketasset");
  var collectionColdRoomAsset =
      FirebaseFirestore.instance.collection("coldroomasset");
  var collectionBuffedTimesAsset =
      FirebaseFirestore.instance.collection("buffedtimesasset");
  var collectionResoNumAsset =
      FirebaseFirestore.instance.collection("resonumasset");
  Future<void> submit(
      String asset_name, int reuse_isactive, String hotel) async {
    var newAsset = HashMap<String, dynamic>();
    newAsset["id"] = "";
    newAsset["asset_name"] = asset_name;
    newAsset["reuse_isactive"] = reuse_isactive;
    newAsset["hotel"] = hotel;
    collectionHotPreAssets.add(newAsset);
  }

  Future<void> update(String asset_id, String asset_name, int reuse_isactive,
      String hotel) async {
    var updAsset = HashMap<String, dynamic>();
    updAsset["asset_name"] = asset_name;
    updAsset["reuse_isactive"] = reuse_isactive;
    updAsset["hotel"] = hotel;
    collectionHotPreAssets.doc(asset_id).update(updAsset);
  }

  Future<void> delete(String id) async {
    collectionHotPreAssets.doc(id).delete();
  }

  Future<void> coldSubmit(
      String asset_name, int reuse_isactive, String hotel) async {
    var newAsset = HashMap<String, dynamic>();
    newAsset["id"] = "";
    newAsset["asset_name"] = asset_name;
    newAsset["reuse_isactive"] = reuse_isactive;
    newAsset["hotel"] = hotel;
    collectionColdPreAssets.add(newAsset);
  }

  Future<void> coldUpdate(String asset_id, String asset_name,
      int reuse_isactive, String hotel) async {
    var updAsset = HashMap<String, dynamic>();
    updAsset["asset_name"] = asset_name;
    updAsset["reuse_isactive"] = reuse_isactive;
    updAsset["hotel"] = hotel;
    collectionColdPreAssets.doc(asset_id).update(updAsset);
  }

  Future<void> coldDelete(String id) async {
    collectionHotPreAssets.doc(id).delete();
  }

  Future<void> disinSubmit(String asset_name, String hotel) async {
    var newAsset = HashMap<String, dynamic>();
    newAsset["id"] = "";
    newAsset["asset_name"] = asset_name;
    newAsset["hotel"] = hotel;
    collectionDisinAssets.add(newAsset);
  }

  Future<void> disinUpdate(
      String asset_id, String asset_name, String hotel) async {
    var updAsset = HashMap<String, dynamic>();
    updAsset["asset_name"] = asset_name;
    updAsset["hotel"] = hotel;
    collectionDisinAssets.doc(asset_id).update(updAsset);
  }

  Future<void> disinDelete(String id) async {
    collectionDisinAssets.doc(id).delete();
  }

  Future<void> firmSubmit(String firm_name, String hotel) async {
    var newFirm = HashMap<String, dynamic>();
    newFirm["id"] = "";
    newFirm["firm_name"] = firm_name;
    newFirm["hotel"] = hotel;
    DocumentReference docRef = await collectionFirms.add(newFirm);
    // Document ID'yi al ve yeni role ekleyin
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> firmUpdate(
      String firm_id, String firm_name, String hotel) async {
    var updFirm = HashMap<String, dynamic>();
    updFirm["firm_name"] = firm_name;
    updFirm["hotel"] = hotel;
    collectionFirms.doc(firm_id).update(updFirm);
  }

  Future<void> firmDelete(String id) async {
    collectionFirms.doc(id).delete();
  }

  Future<void> soakingSubmit(String asset_name, String hotel) async {
    var newAsset = HashMap<String, dynamic>();
    newAsset["id"] = "";
    newAsset["asset_name"] = asset_name;
    newAsset["hotel"] = hotel;
    collectionSoakingAssets.add(newAsset);
  }

  Future<void> soakingUpdate(
      String asset_id, String asset_name, String hotel) async {
    var updAsset = HashMap<String, dynamic>();
    updAsset["asset_name"] = asset_name;
    updAsset["hotel"] = hotel;
    collectionSoakingAssets.doc(asset_id).update(updAsset);
  }

  Future<void> soakingDelete(String id) async {
    collectionSoakingAssets.doc(id).delete();
  }

  Future<void> banketSubmit(String banket_name, String hotel) async {
    var newAsset = HashMap<String, dynamic>();

    newAsset["id"] = "";
    newAsset["banket_name"] = banket_name;
    newAsset["hotel"] = hotel;

    collectionBanketAssets.add(newAsset);
  }

  Future<void> banketUpdate(
      String id, String banket_name, String hotel) async {
    var updAsset = HashMap<String, dynamic>();

    updAsset["banket_name"] = banket_name;
    updAsset["hotel"] = hotel;
    collectionBanketAssets.doc(id).update(updAsset);
  }

  Future<void> banketDelete(String id) async {
    collectionBanketAssets.doc(id).delete();
  }

  Future<void> coldRoomSubmit(String cold_room_name, String hotel) async {
    var newAsset = HashMap<String, dynamic>();

    newAsset["id"] = "";
    newAsset["cold_room_name"] = cold_room_name;
    newAsset["hotel"] = hotel;
    collectionColdRoomAsset.add(newAsset);
  }

  Future<void> coldRoomUpdate(
      String id, String cold_room_name, String hotel) async {
    var updAsset = HashMap<String, dynamic>();

    updAsset["cold_room_name"] = cold_room_name;
    updAsset["hotel"] = hotel;
    collectionColdRoomAsset.doc(id).update(updAsset);
  }

  Future<void> coldRoomDelete(String id) async {
    collectionColdRoomAsset.doc(id).delete();
  }

  Future<void> buffedTimesSubmit(String sabah_baslangic, String sabah_bitis, String oglen_baslangic, String oglen_bitis,
      String aksam_baslangic, String aksam_bitis, String hotel) async{
    var newAsset = HashMap<String,dynamic>();
     newAsset["id"] ="";
     newAsset["sabah_baslangic"] = sabah_baslangic;
     newAsset["sabah_bitis"] = sabah_bitis;
     newAsset["ogle_baslangic"] = oglen_baslangic;
     newAsset["ogle_bitis"] = oglen_bitis;
     newAsset["aksam_baslangic"] = aksam_baslangic;
     newAsset["aksam_bitis"] = aksam_bitis;
     newAsset['hotel'] = hotel;

     collectionBuffedTimesAsset.add(newAsset);

  }

  Future<void> buffedTimesUpdate( String id,String sabah_baslangic, String sabah_bitis, String ogle_baslangic, String ogle_bitis,
      String aksam_baslangic, String aksam_bitis,  String hotel) async{

    var updAsset = HashMap<String, dynamic>();
    updAsset['sabah_baslangic'] = sabah_baslangic;
    updAsset['sabah_bitis'] = sabah_bitis;
    updAsset['ogle_baslangic'] = ogle_baslangic;
    updAsset['ogle_bitis'] = ogle_bitis;
    updAsset['aksam_baslangic'] =aksam_baslangic;
    updAsset['aksam_bitis'] = aksam_bitis;
    updAsset['hotel'] = hotel;
    collectionBuffedTimesAsset.doc(id).update(updAsset);
  }

  Future<void> buffedTimesDelete( String id) async{
    collectionBuffedTimesAsset.doc(id).delete();
  }

  Future<void> resoNumSubmit(String reso_num_name, String hotel) async{

    var newAsset = HashMap<String,dynamic>();

    newAsset["id"] = "";
    newAsset["reso_num_name"] = reso_num_name;
    newAsset["hotel"] = hotel;
    collectionResoNumAsset.add(newAsset);
  }

  Future<void> resoNumUpdate(String id, String reso_num_name, String hotel) async{

    var updAsset = HashMap<String,dynamic>();
    updAsset["reso_num_name"] = reso_num_name;
    updAsset["hotel"] = hotel;

    collectionResoNumAsset.doc(id).update(updAsset);
  }
  Future<void> resoNumDelete(String id) async{
    collectionResoNumAsset.doc(id).delete();
  }
}
