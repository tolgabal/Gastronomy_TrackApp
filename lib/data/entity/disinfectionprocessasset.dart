import 'package:flutter/material.dart';

class DisinfectionProcessAsset {
  String id;
  int piece;
  String piece_type;
  String asset_name;
  int procTime;
  String procType;
  String section;
  String submit_date;
  String user_name;
  String hotel;
  DisinfectionProcessAsset({
    required this.id,
    required this.piece_type,
    required this.asset_name,
    required this.piece,
    required this.procTime,
    required this.procType,
    required this.section,
    required this.submit_date,
    required this.user_name,
    required this.hotel
    });
  factory DisinfectionProcessAsset.fromJson(Map<dynamic,dynamic> json, String key){
    return DisinfectionProcessAsset(id: key, piece_type: json["piece_type"] as String, asset_name: json["asset_name"] as String, piece: json["piece"] as int, procTime: json["procTime"] as int, procType: json["procType"] as String, section: json["section"] as String, submit_date: json["submit_date"] as String, user_name: json["user_name"] as String, hotel: json["hotel"] as String);
  }
}