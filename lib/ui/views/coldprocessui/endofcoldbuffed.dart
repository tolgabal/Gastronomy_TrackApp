import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldprocessasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocessinfo_cubit.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/section.dart';
import '../../../data/entity/user.dart';
import '../../cubit/sectionlist_cubit.dart';
import '../../middleware/temperature_bloc.dart';
import 'coldprocesslistui.dart';

class ColdProcEndBuffedUI extends StatefulWidget {
  final ColdProcessAsset asset;
  final User user;
  final Role userRole;

  const ColdProcEndBuffedUI({
    required this.asset,
    required this.user,
    required this.userRole,
    super.key,
  });

  @override
  State<ColdProcEndBuffedUI> createState() => _ColdProcEndBuffedUIState();
}

class _ColdProcEndBuffedUIState extends State<ColdProcEndBuffedUI> {
  var tfFirstBuffedStatus = TextEditingController();
  var tfSection = TextEditingController();
  var tfAssetStatus = TextEditingController();
  var tfFirstBuffedTemp = TextEditingController();
  var tfFirstBuffedDate = TextEditingController();

  String? selectedOption;
  String? selectedSectionid;
  DateTime? selectedDateTime;
  String? timeString;
  bool showTime = false;

  @override
  void initState() {
    super.initState();
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
    var asset = widget.asset;
    tfFirstBuffedTemp.text = asset.first_buffed_temp.toString();
    tfFirstBuffedDate.text = asset.first_buffed_time;
    tfFirstBuffedStatus.text = widget.asset.first_buffed_status;
  }

  void _onThermostatIconTapped() {

  }

  void _onTimeIconTapped() {
    setState(() {
      selectedDateTime = DateTime.now();
      tfFirstBuffedDate.text = selectedDateTime.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ColdProcessListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child:  Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Büfe Sonu"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if(widget.asset.first_buffed_status != "Soğuk Oda")
              // Option Seçimi
              DropdownButtonFormField<String>(
                hint: const Text("Seçim Yapın"),
                value: selectedOption,
                items: ['Ürün Bitti', 'İmha', 'Soğuk Oda', 'Section'].map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                    if (selectedOption == 'Soğuk Oda') {
                      tfAssetStatus.text = "Soğuk Oda";
                      tfFirstBuffedStatus.text = selectedOption!;

                    } else if (selectedOption == "Ürün Bitti" || selectedOption == "İmha") {
                      tfAssetStatus.text = selectedOption!;
                    }
                  });
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              if(widget.asset.first_buffed_status == "Soğuk Oda")
                DropdownButtonFormField<String>(
                  hint: const Text("Seçim Yapın"),
                  value: selectedOption,
                  items: ['Ürün Bitti', 'İmha',].map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                       if (selectedOption == "Ürün Bitti" || selectedOption == "İmha") {
                        tfAssetStatus.text = selectedOption!;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 20),

              if (selectedOption == 'Section' || selectedOption == 'Soğuk Oda') ...[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: tfFirstBuffedTemp,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Sıcaklık",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.thermostat),
                      onPressed: _onThermostatIconTapped,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tarih alma ve sıcaklık alanı
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDateTime = DateTime.now();
                          DateTime now = DateTime.now();
                          timeString = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}"; // Güncel tarihi ve saati al
                          showTime = true;
                          tfFirstBuffedDate.text = timeString!; // Tarih alanına güncel zamanı ata
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bigWidgetColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: showTime
                            ? Text(
                          timeString ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                            : const Icon(Icons.access_time, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: tfFirstBuffedTemp,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Merkez Sıcaklık",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfFirstBuffedTemp.text = state["temperature"]!;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bigWidgetColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.thermostat, color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfFirstBuffedTemp.text = state["infrared"]!;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bigWidgetColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.thermostat, color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              if (selectedOption == 'Section')
                BlocBuilder<SectionListCubit, List<Section>>(
                  builder: (context, sectionList) {
                    if (sectionList.isEmpty) {
                      return const Center(child: Text("Section bulunmamakta"));
                    }

                    return DropdownButtonFormField<String>(
                      hint: const Text("Section Seçiniz"),
                      value: selectedSectionid,
                      items: sectionList.map((section) {
                        return DropdownMenuItem<String>(
                          value: section.id,
                          child: Text(section.section_name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSectionid = value;
                          tfSection.text = sectionList
                              .firstWhere((section) => section.id == value)
                              .section_name;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  double parsedFirstBuffedTemp = double.tryParse(tfFirstBuffedTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

                  context.read<ColdProcessInfoCubit>().coldProcUpdate(
                      widget.asset.id,
                      widget.asset.asset_name,
                      widget.user.username,
                      widget.asset.sample,
                      widget.asset.asset_quantity,
                      widget.asset.cold_room_name,
                      widget.asset.cold_buffed_no,
                      widget.asset.asset_presentation_temp,
                      widget.asset.asset_presentation_time,
                      widget.asset.cold_pre_start_temp,
                      widget.asset.cold_pre_start_time,
                      widget.asset.cold_pre_end_time,
                      widget.asset.cold_pre_end_temp,
                      widget.asset.cold_room_temp_one,
                      widget.asset.cold_room_time_one,
                      widget.asset.cold_room_temp_two,
                      widget.asset.cold_room_time_two,
                      widget.asset.cold_buffed_temp_one,
                      widget.asset.cold_buffed_time_one,
                      widget.asset.cold_buffed_temp_two,
                      widget.asset.cold_buffed_time_two,
                      widget.asset.cold_buffed_temp_three,
                      widget.asset.cold_buffed_time_three,
                      tfFirstBuffedStatus.text,
                      parsedFirstBuffedTemp,
                      tfFirstBuffedDate.text,
                      widget.asset.cold_room_temp_three,
                      widget.asset.cold_room_time_three,
                      widget.asset.cold_buffed_temp_four,
                      widget.asset.cold_buffed_time_four,
                      widget.asset.cold_buffed_temp_five,
                      widget.asset.cold_buffed_time_five,
                      widget.asset.cold_buffed_temp_six,
                      widget.asset.cold_buffed_time_six,
                      tfAssetStatus.text,
                      widget.user.hotel,
                      widget.asset.section,
                      widget.asset.cold_room_temp_four,
                      widget.asset.cold_room_time_four);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ColdProcessListUI(user: widget.user, userRole: widget.userRole)),
                  );
                },
                child: const Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),);
  }
}