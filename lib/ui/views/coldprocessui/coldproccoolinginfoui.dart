import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocessinfo_cubit.dart';

import '../../../color.dart';
import '../../../data/entity/coldprocessasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/temperature_bloc.dart';
import 'coldprocesslistui.dart';

class ColdProcCoolingInfoUI extends StatefulWidget {
  final ColdProcessAsset asset;
  final User user;
  final Role userRole;
  const ColdProcCoolingInfoUI(
      {required this.asset,
      required this.user,
      required this.userRole,
      super.key});

  @override
  State<ColdProcCoolingInfoUI> createState() => _ColdProcCoolingInfoUIState();
}

class _ColdProcCoolingInfoUIState extends State<ColdProcCoolingInfoUI> {
  var tfAssetStatus = TextEditingController();
  var tfAssetColdPreStartTemp = TextEditingController();
  var tfAssetColdPreStartDate = TextEditingController();
  var tfAssetColdPreEndTemp = TextEditingController();
  var tfAssetColdPreEndDate = TextEditingController();
  bool isExpanded = false;
  bool isSecondMeasurementExpanded = false;
  DateTime? selectedDateTime;
  String? timeString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tfAssetColdPreStartTemp.text = widget.asset.cold_pre_start_temp.toString();
    tfAssetColdPreStartDate.text = widget.asset.cold_pre_start_time;
    tfAssetColdPreEndTemp.text = widget.asset.cold_pre_end_temp.toString();
    tfAssetColdPreEndDate.text = widget.asset.cold_pre_end_time;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ColdProcessListUI(user: widget.user, userRole: widget.userRole)),
      );
      return false;
    },
      child: Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Soğutma Ölçüm"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildFirstMeasurementWidget(),
                const SizedBox(height: 16),
                if(widget.asset.cold_pre_start_temp != -1000.0)
                _buildSecondMeasurementWidget(),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                _buildSubmitButtons(),
              ],
            ),
          ),
        ),
      ),
    ),);
  }

  Widget _buildFirstMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded; // Durumu değiştir
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
            isExpanded ? const EdgeInsets.all(32) : const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: smallWidgetColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Text("BlastChiller'e Giriş Ölçümü",
                style: TextStyle(
                  fontSize: isExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdPreStartTemp,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        tfAssetStatus.text = "Soğutma";
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetColdPreStartTemp.text =
                                state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        tfAssetStatus.text = "Soğutma";
                        context
                            .read<BluetoothCubit>()
                            .readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetColdPreStartTemp.text = state["infrared"]!;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdPreStartDate,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        selectedDateTime = DateTime.now();
                        DateTime now = DateTime.now();
                        timeString =
                            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
                        tfAssetColdPreStartDate.text =
                            selectedDateTime.toString();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              const Text(
                "Ürün soğutma işleminin maksimum 60 dakika olması gerekmektedir.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSecondMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSecondMeasurementExpanded =
              !isSecondMeasurementExpanded; // Durumu değiştir
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isSecondMeasurementExpanded
            ? const EdgeInsets.all(32)
            : const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: smallWidgetColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Text("BlastChiller'e Çıkış Ölçümü",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdPreEndTemp,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        tfAssetStatus.text = "Soğuk Oda";
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetColdPreEndTemp.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        tfAssetStatus.text = "Soğuk Oda";
                        context
                            .read<BluetoothCubit>()
                            .readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetColdPreEndTemp.text = state["infrared"]!;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdPreEndDate,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        selectedDateTime = DateTime.now();
                        DateTime now = DateTime.now();
                        timeString =
                            "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
                        tfAssetColdPreEndDate.text =
                            selectedDateTime.toString();
                      });
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            double parsedTempStart = double.tryParse(tfAssetColdPreStartTemp
                    .text
                    .replaceAll(RegExp(r'[^\d.-]'), '')) ??
                0;
            double parsedTempEnd = double.tryParse(tfAssetColdPreEndTemp.text
                    .replaceAll(RegExp(r'[^\d.-]'), '')) ??
                0;
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
                parsedTempStart,
                tfAssetColdPreStartDate.text,
                tfAssetColdPreEndDate.text,
                parsedTempEnd,
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
                widget.asset.first_buffed_status,
                widget.asset.first_buffed_temp,
                widget.asset.first_buffed_time,
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
                widget.user.section_id,
                widget.asset.cold_room_temp_four,
                widget.asset.cold_room_time_four);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ColdProcessListUI(
                      user: widget.user, userRole: widget.userRole)),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: Text("Güncelle"),
        ),
      ],
    );
  }
}
