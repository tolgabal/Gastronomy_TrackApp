import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gastrobluecheckapp/data/entity/disinfectionprocessasset.dart';
import 'package:gastrobluecheckapp/data/entity/hotprocessasset.dart';
import 'package:gastrobluecheckapp/data/entity/thawingprocess.dart';
import 'package:gastrobluecheckapp/sqlite/db_helper.dart';

class ProcessAssetDaoRepository {
  var collectionDisinProcAssets =
      FirebaseFirestore.instance.collection("disinprocasset");
  var collectionHotProcAssets =
      FirebaseFirestore.instance.collection("hotprocasset");
  var collectionThawingProcAssets =
      FirebaseFirestore.instance.collection("thawingprocasset");
  var collectionColdProcAsset =
      FirebaseFirestore.instance.collection("coldprocess");

  Future<void> disinProcessSubmit(
    String assetName,
    int piece,
    int procTime,
    String procType,
    String section,
    String pieceType,
    String date,
    String userName,
    String hotel,
  ) async {
    var newDisAsset = Map<String, dynamic>();
    newDisAsset["id"] =
        ""; // ID burada boş bırakılabilir, Firestore eklerken otomatik oluşturulacak
    newDisAsset["asset_name"] = assetName;
    newDisAsset["piece"] = piece;
    newDisAsset["procTime"] = procTime;
    newDisAsset["procType"] = procType;
    newDisAsset["section"] = section;
    newDisAsset["piece_type"] = pieceType;
    newDisAsset["submit_date"] = date;
    newDisAsset["user_name"] = userName;
    newDisAsset["hotel"] = hotel;

    DocumentReference docRef = await collectionDisinProcAssets.add(newDisAsset);
    // Document ID'yi al ve yeni role ekleyin
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> disinProcessUpdate(
    String id,
    String assetName,
    int piece,
    int procTime,
    String procType,
    String section,
    String pieceType,
    String date,
    String hotel,
  ) async {
    var updDisAsset = Map<String, dynamic>();

    updDisAsset["id"] = id;
    updDisAsset["asset_name"] = assetName;
    updDisAsset["piece"] = piece;
    updDisAsset["procTime"] = procTime;
    updDisAsset["procType"] = procType;
    updDisAsset["section"] = section;
    updDisAsset["piece_type"] = pieceType;
    updDisAsset["submit_date"] = date;
    updDisAsset["hotel"] = hotel;

    await collectionDisinProcAssets.doc(id).update(updDisAsset);
  }

  Future<void> disinProcessDelete(String id) async {
    await collectionDisinProcAssets.doc(id).delete();
  }

  Future<void> hotProcessSubmit(
    String asset_name,
    String user_name,
    int quantity,
    double first_temperature,
    double banket_temperature_one,
    double banket_temperature_two,
    double banket_temperature_three,
    double banket_temperature_four,
    String banket_date_one,
    String banket_date_two,
    String banket_date_three,
    String banket_date_four,
    String sample,
    String presentation,
    String submit_date,
    int process_times,
    String hotel,
    double buffed_temp_one,
    double buffed_temp_two,
    double buffed_temp_three,
    double buffed_temp_four,
    double buffed_temp_five,
    double buffed_temp_six,
    String buffed_date_one,
    String buffed_date_two,
    String buffed_date_three,
    String buffed_date_four,
    String buffed_date_five,
    String buffed_date_six,
    double cooling_start_temp,
    double cooling_end_temp,
    String cooling_date,
    String section_name,
    String reso_num,
    String first_buffed_status,
    String banket,
    String asset_result,
    double cooling_reheat_temp,
    String cooling_reheat_date,
    String cooling_end_date,
  ) async {
    var newHotProcAsset = {
      "id": "",
      "asset_name": asset_name,
      "quantity": quantity,
      "first_temperature": first_temperature,
      "banket_temperature_one": banket_temperature_one,
      "banket_temperature_two": banket_temperature_two,
      "banket_temperature_three": banket_temperature_three,
      "banket_temperature_four": banket_temperature_four,
      "banket_date_one": banket_date_one,
      "banket_date_two": banket_date_two,
      "banket_date_three": banket_date_three,
      "banket_date_four": banket_date_four,
      "sample": sample,
      "presentation": presentation,
      "submit_date": submit_date,
      "process_times": process_times,
      "buffed_temp_one": buffed_temp_one,
      "buffed_temp_two": buffed_temp_two,
      "buffed_temp_three": buffed_temp_three,
      "buffed_temp_four": buffed_temp_four,
      "buffed_temp_five": buffed_temp_five,
      "buffed_temp_six": buffed_temp_six,
      "buffed_date_one": buffed_date_one,
      "buffed_date_two": buffed_date_two,
      "buffed_date_three": buffed_date_three,
      "buffed_date_four": buffed_date_four,
      "buffed_date_five": buffed_date_five,
      "buffed_date_six": buffed_date_six,
      "cooling_start_temp": cooling_start_temp,
      "cooling_end_temp": cooling_end_temp,
      "cooling_date": cooling_date,
      "section_name": section_name,
      "reso_num": reso_num,
      "first_buffed_status": first_buffed_status,
      "banket": banket,
      "asset_result": asset_result,
      "user_name": user_name,
      "hotel": hotel,
      "cooling_reheat_temp": cooling_reheat_temp,
      "cooling_reheat_date": cooling_reheat_date,
      "cooling_end_date": cooling_end_date,
    };

    DocumentReference docRef =
        await collectionHotProcAssets.add(newHotProcAsset);
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> hotProcessUpdate(
    String id,
    String asset_name,
    String user_name,
    int quantity,
    double first_temperature,
    double banket_temperature_one,
    double banket_temperature_two,
    double banket_temperature_three,
    double banket_temperature_four,
    String banket_date_one,
    String banket_date_two,
    String banket_date_three,
    String banket_date_four,
    String sample,
    String presentation,
    String submit_date,
    int process_times,
    String hotel,
    double buffed_temp_one,
    double buffed_temp_two,
    double buffed_temp_three,
    double buffed_temp_four,
    double buffed_temp_five,
    double buffed_temp_six,
    String buffed_date_one,
    String buffed_date_two,
    String buffed_date_three,
    String buffed_date_four,
    String buffed_date_five,
    String buffed_date_six,
    double cooling_start_temp,
    double cooling_end_temp,
    String cooling_date,
    String section_name,
    String reso_num,
    String first_buffed_status,
    String banket,
    String asset_result,
    double cooling_reheat_temp,
    String cooling_reheat_date,
    String cooling_end_date,
  ) async {
    var updHotProcAsset = {
      "id": id,
      "asset_name": asset_name,
      "quantity": quantity,
      "first_temperature": first_temperature,
      "banket_temperature_one": banket_temperature_one,
      "banket_temperature_two": banket_temperature_two,
      "banket_temperature_three": banket_temperature_three,
      "banket_temperature_four": banket_temperature_four,
      "banket_date_one": banket_date_one,
      "banket_date_two": banket_date_two,
      "banket_date_three": banket_date_three,
      "banket_date_four": banket_date_four,
      "sample": sample,
      "presentation": presentation,
      "submit_date": submit_date,
      "process_times": process_times,
      "buffed_temp_one": buffed_temp_one,
      "buffed_temp_two": buffed_temp_two,
      "buffed_temp_three": buffed_temp_three,
      "buffed_temp_four": buffed_temp_four,
      "buffed_temp_five": buffed_temp_five,
      "buffed_temp_six": buffed_temp_six,
      "buffed_date_one": buffed_date_one,
      "buffed_date_two": buffed_date_two,
      "buffed_date_three": buffed_date_three,
      "buffed_date_four": buffed_date_four,
      "buffed_date_five": buffed_date_five,
      "buffed_date_six": buffed_date_six,
      "cooling_start_temp": cooling_start_temp,
      "cooling_end_temp": cooling_end_temp,
      "cooling_date": cooling_date,
      "section_name": section_name,
      "reso_num": reso_num,
      "first_buffed_status": first_buffed_status,
      "banket": banket,
      "asset_result": asset_result,
      "user_name": user_name,
      "hotel": hotel,
      "cooling_end_date": cooling_end_date,
      "cooling_reheat_temp": cooling_reheat_temp,
      "cooling_reheat_date": cooling_reheat_date
    };

    await collectionHotProcAssets.doc(id).update(updHotProcAsset);
  }

  Future<void> hotProcessDelete(String id) async {
    await collectionHotProcAssets.doc(id).delete();
  }

  Future<void> thawingProcSubmit(
  String section_name,
  double asset_env_temp,
  String user_name,
  String asset_result,
  String asset_name,
  String asset_party_no,
  String asset_exp_no,
  int asset_quantity,
  double asset_temp_one,
  String asset_time_one,
  double asset_thawing_temp_one,
  String asset_thawing_time_one,
  double asset_thawing_temp_two,
  String asset_thawing_time_two,
  double asset_thawing_temp_three,
  String asset_thawing_time_three,
  double asset_process_temp,
  String asset_process_time,
  String asset_sending_place,
  int asset_sending_quantity,
  String asset_sending_process_type,
  double asset_sending_place_temp,
  int kalan,
  String hotel,
      ) async {
    var newThawProc = Map<String, dynamic>();
    newThawProc["id"] = "";
    newThawProc["section_name"] = section_name;
    newThawProc["asset_env_temp"] = asset_env_temp;
    newThawProc["user_name"] = user_name;
    newThawProc['asset_result'] = asset_result;
    newThawProc['asset_name'] = asset_name;
    newThawProc['asset_party_no'] =asset_party_no;
    newThawProc['asset_exp_no'] =asset_exp_no;
    newThawProc['asset_quantity']=asset_quantity;
    newThawProc['asset_temp_one']=asset_temp_one;
    newThawProc['asset_time_one']=asset_time_one;
    newThawProc['asset_thawing_temp_one']=asset_thawing_temp_one;
    newThawProc['asset_thawing_time_one']=asset_thawing_time_one;
    newThawProc['asset_thawing_temp_two']=asset_thawing_temp_two;
    newThawProc['asset_thawing_time_two']=asset_thawing_time_two;
    newThawProc['asset_thawing_temp_three']=asset_thawing_temp_three;
    newThawProc['asset_thawing_time_three']=asset_thawing_time_three;
    newThawProc['asset_process_time']=asset_process_time;
    newThawProc['asset_process_temp']=asset_process_temp;
    newThawProc['asset_sending_place']=asset_sending_place;
    newThawProc['asset_sending_quantity']=asset_sending_quantity;
    newThawProc['asset_sending_process_type']=asset_sending_process_type;
    newThawProc['asset_sending_place_temp']=asset_sending_place_temp;
    newThawProc['kalan']=kalan;
    newThawProc['hotel']=hotel;

        DocumentReference docRef =
        await collectionThawingProcAssets.add(newThawProc);
    // Document ID'yi al ve yeni role ekleyin
    await docRef.update({
      "id": docRef.id, // Document ID'yi id alanına atayın
    });
  }

  Future<void> thawingProcUpdate(
      String id,
      String section_name,
      double asset_env_temp,
      String user_name,
      String asset_result,
      String asset_name,
      String asset_party_no,
      String asset_exp_no,
      int asset_quantity,
      double asset_temp_one,
      String asset_time_one,
      double asset_thawing_temp_one,
      String asset_thawing_time_one,
      double asset_thawing_temp_two,
      String asset_thawing_time_two,
      double asset_thawing_temp_three,
      String asset_thawing_time_three,
      double asset_process_temp,
      String asset_process_time,
      String asset_sending_place,
      int asset_sending_quantity,
      String asset_sending_process_type,
      double asset_sending_place_temp,
      int kalan,
      String hotel,) async {
    var newThawProc = Map<String, dynamic>();

    newThawProc["section_name"] = section_name;
    newThawProc["asset_env_temp"] = asset_env_temp;
    newThawProc["user_name"] = user_name;
    newThawProc['asset_result'] = asset_result;
    newThawProc['asset_name'] = asset_name;
    newThawProc['asset_party_no'] =asset_party_no;
    newThawProc['asset_exp_no'] =asset_exp_no;
    newThawProc['asset_quantity']=asset_quantity;
    newThawProc['asset_temp_one']=asset_temp_one;
    newThawProc['asset_time_one']=asset_time_one;
    newThawProc['asset_thawing_temp_one']=asset_thawing_temp_one;
    newThawProc['asset_thawing_time_one']=asset_thawing_time_one;
    newThawProc['asset_thawing_temp_two']=asset_thawing_temp_two;
    newThawProc['asset_thawing_time_two']=asset_thawing_time_two;
    newThawProc['asset_thawing_temp_three']=asset_thawing_temp_three;
    newThawProc['asset_thawing_time_three']=asset_thawing_time_three;
    newThawProc['asset_process_time']=asset_process_time;
    newThawProc['asset_process_temp']=asset_process_temp;
    newThawProc['asset_sending_place']=asset_sending_place;
    newThawProc['asset_sending_quantity']=asset_sending_quantity;
    newThawProc['asset_sending_process_type']=asset_sending_process_type;
    newThawProc['asset_sending_place_temp']=asset_sending_place_temp;
    newThawProc['kalan']=kalan;
    newThawProc['hotel']=hotel;
    collectionThawingProcAssets.doc(id).update(newThawProc);
  }

  Future<void> thawingProcDelete(String id) async {
    collectionThawingProcAssets.doc(id).delete();
  }

  Future<void> coldProcessSubmit(
      String asset_name,
      String user_name,
      int sample,
      int asset_quantity,
      String cold_room_name,
      String cold_buffed_no,
      double asset_presentation_temp,
      String asset_presentation_time,
      double cold_pre_start_temp,
      String cold_pre_start_time,
      String cold_pre_end_time,
      double cold_pre_end_temp,
      double cold_room_temp_one,
      String cold_room_time_one,
      double cold_room_temp_two,
      String cold_room_time_two,
      double cold_buffed_temp_one,
      String cold_buffed_time_one,
      double cold_buffed_temp_two,
      String cold_buffed_time_two,
      double cold_buffed_temp_three,
      String cold_buffed_time_three,
      String first_buffed_status,
      double first_buffed_temp,
      String first_buffed_time,
      double cold_room_temp_three,
      String cold_room_time_three,
      double cold_buffed_temp_four,
      String cold_buffed_time_four,
      double cold_buffed_temp_five,
      String cold_buffed_time_five,
      double cold_buffed_temp_six,
      String cold_buffed_time_six,
      String asset_status,
      String hotel,
      String section,
      double cold_room_temp_four,
      String cold_room_time_four,
   ) async {
    var newColdProc = Map<String, dynamic>();

    newColdProc["id"] = "";
    newColdProc["asset_name"] = asset_name;
    newColdProc["user_name"] = user_name;
    newColdProc["sample"] = sample;
    newColdProc["asset_quantity"] = asset_quantity;
    newColdProc["cold_room_name"] = cold_room_name;
    newColdProc["cold_buffed_no"] = cold_buffed_no;
    newColdProc["asset_presentation_temp"] = asset_presentation_temp;
    newColdProc["asset_presentation_time"] = asset_presentation_time;
    newColdProc["cold_pre_start_temp"] = cold_pre_start_temp;
    newColdProc["cold_pre_start_time"] = cold_pre_start_time;
    newColdProc["cold_pre_end_time"] = cold_pre_end_time;
    newColdProc["cold_pre_end_temp"] = cold_pre_end_temp; // Doğru atama
    newColdProc["cold_room_temp_one"] = cold_room_temp_one;
    newColdProc["cold_room_time_one"] = cold_room_time_one;
    newColdProc["cold_room_temp_two"] = cold_room_temp_two;
    newColdProc["cold_room_time_two"] = cold_room_time_two;
    newColdProc["cold_buffed_temp_one"] = cold_buffed_temp_one;
    newColdProc["cold_buffed_time_one"] = cold_buffed_time_one;
    newColdProc["cold_buffed_temp_two"] =
        cold_buffed_temp_two; // Tekrarlanan satır kaldırıldı
    newColdProc["cold_buffed_time_two"] = cold_buffed_time_two;
    newColdProc["cold_buffed_temp_three"] = cold_buffed_temp_three;
    newColdProc["cold_buffed_time_three"] = cold_buffed_time_three;
    newColdProc["first_buffed_status"] = first_buffed_status;
    newColdProc["first_buffed_temp"] = first_buffed_temp;
    newColdProc["first_buffed_time"] = first_buffed_time;
    newColdProc["cold_room_temp_three"] = cold_room_temp_three;
    newColdProc["cold_room_time_three"] = cold_room_time_three;
    newColdProc["cold_buffed_temp_four"] = cold_buffed_temp_four;
    newColdProc["cold_buffed_time_four"] = cold_buffed_time_four;
    newColdProc["cold_buffed_temp_five"] = cold_buffed_temp_five;
    newColdProc["cold_buffed_time_five"] = cold_buffed_time_five;
    newColdProc["cold_buffed_temp_six"] = cold_buffed_temp_six;
    newColdProc["cold_buffed_time_six"] = cold_buffed_time_six;
    newColdProc["asset_status"] = asset_status;
    newColdProc["hotel"] = hotel;
    newColdProc["section"] = section;
    newColdProc["cold_room_temp_four"] = cold_room_temp_four;
   newColdProc["cold_room_time_four"] = cold_room_time_four;

    try {
      DocumentReference docRef = await collectionColdProcAsset.add(newColdProc);
      await docRef.update({
        "id": docRef.id, // Document ID'yi id alanına atayın
      });
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  Future<void> coldProcessUpdate(
      String id,
      String asset_name,
      String user_name,
      int sample,
      int asset_quantity,
      String cold_room_name,
      String cold_buffed_no,
      double asset_presentation_temp,
      String asset_presentation_time,
      double cold_pre_start_temp,
      String cold_pre_start_time,
      String cold_pre_end_time,
      double cold_pre_end_temp,
      double cold_room_temp_one,
      String cold_room_time_one,
      double cold_room_temp_two,
      String cold_room_time_two,
      double cold_buffed_temp_one,
      String cold_buffed_time_one,
      double cold_buffed_temp_two,
      String cold_buffed_time_two,
      double cold_buffed_temp_three,
      String cold_buffed_time_three,
      String first_buffed_status,
      double first_buffed_temp,
      String first_buffed_time,
      double cold_room_temp_three,
      String cold_room_time_three,
      double cold_buffed_temp_four,
      String cold_buffed_time_four,
      double cold_buffed_temp_five,
      String cold_buffed_time_five,
      double cold_buffed_temp_six,
      String cold_buffed_time_six,
      String asset_status,
      String hotel,
      String section,
      double cold_room_temp_four,
      String cold_room_time_four,
   ) async {
    var newColdProc = Map<String, dynamic>();

    newColdProc["asset_name"] = asset_name;
    newColdProc["user_name"] = user_name;
    newColdProc["sample"] = sample;
    newColdProc["asset_quantity"] = asset_quantity;
    newColdProc["cold_room_name"] = cold_room_name;
    newColdProc["cold_buffed_no"] = cold_buffed_no;
    newColdProc["asset_presentation_temp"] = asset_presentation_temp;
    newColdProc["asset_presentation_time"] = asset_presentation_time;
    newColdProc["cold_pre_start_temp"] = cold_pre_start_temp;
    newColdProc["cold_pre_start_time"] = cold_pre_start_time;
    newColdProc["cold_pre_end_time"] = cold_pre_end_time;
    newColdProc["cold_pre_end_temp"] = cold_pre_start_temp;
    newColdProc["cold_room_temp_one"] = cold_room_temp_one;
    newColdProc["cold_room_time_one"] = cold_room_time_one;
    newColdProc["cold_room_temp_two"] = cold_room_temp_two;
    newColdProc["cold_room_time_two"] = cold_room_time_two;
    newColdProc["cold_buffed_temp_one"] = cold_buffed_temp_one;
    newColdProc["cold_buffed_time_one"] = cold_buffed_time_one;
    newColdProc["cold_buffed_temp_two"] = cold_buffed_temp_two;
    newColdProc["cold_buffed_time_two"] = cold_buffed_time_two;
    newColdProc["cold_buffed_temp_three"] = cold_buffed_temp_three;
    newColdProc["cold_buffed_time_three"] = cold_buffed_time_three;
    newColdProc["first_buffed_status"] = first_buffed_status;
    newColdProc["first_buffed_temp"] = first_buffed_temp;
    newColdProc["first_buffed_time"] = first_buffed_time;
    newColdProc["cold_room_temp_three"] = cold_room_temp_three;
    newColdProc["cold_room_time_three"] = cold_room_time_three;
    newColdProc["cold_buffed_temp_four"] = cold_buffed_temp_four;
    newColdProc["cold_buffed_time_four"] = cold_buffed_time_four;
    newColdProc["cold_buffed_temp_five"] = cold_buffed_temp_five;
    newColdProc["cold_buffed_time_five"] = cold_buffed_time_five;
    newColdProc["cold_buffed_temp_six"] = cold_buffed_temp_six;
    newColdProc["cold_buffed_time_six"] = cold_buffed_time_six;
    newColdProc["asset_status"] = asset_status;
    newColdProc["hotel"] = hotel;
    newColdProc["section"] = section;
    newColdProc["cold_room_temp_four"] = cold_room_temp_four;
     newColdProc["cold_room_time_four"] = cold_room_time_four;
    collectionColdProcAsset.doc(id).update(newColdProc);
  }

  Future<void> coldProcessDelete(String id) async {
    collectionColdProcAsset.doc(id).delete();
  }
}
