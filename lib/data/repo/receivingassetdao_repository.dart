import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastrobluecheckapp/data/entity/receivingasset.dart';
import 'package:gastrobluecheckapp/sqlite/db_helper.dart';

class ReceivingAssetDaoRepository {
  var collectionRecAssets = FirebaseFirestore.instance.collection("receivingasset");
  Future<void> recAssetSubmit(String rec_date, String firm_id, String asset_name, String brand, String prod_date, String exp_date, String seri_num, String fat_num, int car_hygene, int label_cond, int asset_quant, String quant_type, int car_heat, int asset_heat, int agreement, String personnel, String note, String hotel, String username) async{
    var newRecAsset = HashMap<String,dynamic>();
    newRecAsset["id"]    = "";
    newRecAsset["rec_date"]    = rec_date;
    newRecAsset["firm_id"]  = firm_id;
    newRecAsset["asset_name"]    = asset_name;
    newRecAsset["brand"]       = brand;
    newRecAsset["prod_date"]   = prod_date;
    newRecAsset["exp_date"]    = exp_date;
    newRecAsset["seri_num"]      = seri_num;
    newRecAsset["fat_num"]      = fat_num;
    newRecAsset["car_hygene"]    = car_hygene;
    newRecAsset["label_cond"]        = label_cond;
    newRecAsset["asset_quant"]    = asset_quant;
    newRecAsset["quant_type"]  = quant_type;
    newRecAsset["car_heat"] = car_heat;
    newRecAsset["asset_heat"]       = asset_heat;
    newRecAsset["agreement"]   = agreement;
    newRecAsset["personnel"]   = personnel;
    newRecAsset["note"]        = note;
    newRecAsset["hotel"] = hotel;
    newRecAsset["username"] = username;
    DocumentReference docRef = await collectionRecAssets.add(newRecAsset);
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> recAssetUpdate(String id, String rec_date, String firm_id, String asset_name, String brand, String prod_date, String exp_date, String seri_num, String fat_num, int car_hygene, int label_cond, int asset_quant, String quant_type, int car_heat, int asset_heat, int agreement, String personnel, String note, String hotel, String username) async {
    var updRecAsset = HashMap<String,dynamic>();
    updRecAsset["rec_date"]    = rec_date;
    updRecAsset["firm_id"]  = firm_id;
    updRecAsset["asset_name"]    = asset_name;
    updRecAsset["brand"]       = brand;
    updRecAsset["prod_date"]   = prod_date;
    updRecAsset["exp_date"]    = exp_date;
    updRecAsset["seri_num"]      = seri_num;
    updRecAsset["fat_num"]      = fat_num;
    updRecAsset["car_hygene"]    = car_hygene;
    updRecAsset["label_cond"]        = label_cond;
    updRecAsset["asset_quant"]    = asset_quant;
    updRecAsset["quant_type"]  = quant_type;
    updRecAsset["car_heat"] = car_heat;
    updRecAsset["asset_heat"]       = asset_heat;
    updRecAsset["agreement"]   = agreement;
    updRecAsset["personnel"]   = personnel;
    updRecAsset["note"]        = note;
    updRecAsset["hotel"] = hotel;
    updRecAsset["username"] = username;
    collectionRecAssets.doc(id).update(updRecAsset);
  }

  Future<void> recAssetDelete(String id) async {
    collectionRecAssets.doc(id).delete();
  }
}