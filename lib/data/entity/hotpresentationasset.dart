import 'dart:ffi';

import 'package:flutter/foundation.dart';

class HotPresentationAsset{
  String id;
  String asset_name;
  int reuse_isactive;
  String hotel;

  HotPresentationAsset({required this.id, required this.asset_name, required this.reuse_isactive, required this.hotel});

  factory HotPresentationAsset.fromJson(Map<dynamic,dynamic> json, String key){
    return HotPresentationAsset(id: key, asset_name: json["asset_name"] as String, reuse_isactive: json["reuse_isactive"] as int, hotel: json["hotel"] as String);
  }
}