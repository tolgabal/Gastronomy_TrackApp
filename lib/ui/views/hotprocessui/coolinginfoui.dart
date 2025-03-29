import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocessinfo_cubit.dart';

import '../../../color.dart';
import '../../../data/entity/hotprocessasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/temperature_bloc.dart';
import 'hotprocesslistui.dart';

class CoolingInfoUI extends StatefulWidget {
  final HotProcessAsset asset;
  final User user;
  final Role userRole;

  const CoolingInfoUI({
    required this.asset,
    required this.user,
    required this.userRole,
    super.key,
  });

  @override
  State<CoolingInfoUI> createState() => _CoolingInfoUIState();
}

class _CoolingInfoUIState extends State<CoolingInfoUI> {
  var tfAssetCoolingStartTemp = TextEditingController();
  var tfAssetCoolingEndTemp = TextEditingController();
  var tfAssetCoolingDate = TextEditingController();
  var tfPresentation = TextEditingController();
  var tfAssetCoolingEndDate = TextEditingController();
  var tfAssetCoolingReheatTemp = TextEditingController();
  var tfAssetCoolingReheatDate = TextEditingController();

  bool isExpanded = false;
  bool isSecondMeasurementExpanded = false;
  bool isThirdMeasurementExpanded = false;

  String? timeString;
  DateTime? selectedDateTime;
  int callingPlace = 0;
  String? selectedOption;
  String submitText = "Kaydet";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tfAssetCoolingStartTemp.text = widget.asset.cooling_start_temp.toString();
    tfAssetCoolingEndTemp.text = widget.asset.cooling_end_temp.toString();
    tfAssetCoolingReheatTemp.text = widget.asset.cooling_reheat_temp.toString();
    tfAssetCoolingReheatDate.text = widget.asset.cooling_reheat_date;
    tfAssetCoolingEndDate.text = widget.asset.cooling_end_date;
    tfPresentation.text = "Cooling and Reheat";
    tfAssetCoolingDate.text = widget.asset.cooling_date;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HotProcessListUI(
                  user: widget.user, userRole: widget.userRole)),
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
                  if (widget.asset.cooling_start_temp != 333.0)
                    _buildSecondMeasurementWidget(),
                  const SizedBox(height: 16),
                  if (widget.asset.cooling_end_temp != 333.0 &&
                      widget.asset.cooling_start_temp != 333.0)
                    DropdownButtonFormField<String>(
                      hint: const Text("Seçim Yapın"),
                      value: selectedOption,
                      items: [
                        'Büfe',
                        'Banket',
                      ].map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                          if (selectedOption == 'Büfe') {
                            setState(() {
                              tfPresentation.text = "Buffed";
                              submitText = "Büfe'ye Aktar";
                            });
                          } else if (selectedOption == 'Banket') {
                            setState(() {
                              tfPresentation.text = "Banket";
                              submitText = "Banket'e Aktar";
                            });
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  SizedBox(height: 16),
                  if (widget.asset.cooling_end_temp != 333.0 &&
                      widget.asset.cooling_start_temp != 333.0)
                    _buildThirdMeasurementWidget(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  _buildSubmitButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
            Text("Blast Chiller Giriş Ölçümü",
                style: TextStyle(
                  fontSize: isExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetCoolingStartTemp,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        tfPresentation.text = "Cooling and Reheat";
                        callingPlace = 1;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetCoolingStartTemp.text =
                                state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        tfPresentation.text = "Cooling and Reheat";
                        callingPlace = 1;
                        context
                            .read<BluetoothCubit>()
                            .readInfraredTemperatureData();
                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetCoolingStartTemp.text = state["infrared"]!;
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
                      controller: tfAssetCoolingDate,
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
                        tfAssetCoolingDate.text = selectedDateTime.toString();
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
            Text("Blast Chiller Çıkış Ölçümü",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetCoolingEndTemp,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        tfPresentation.text = "Cooling and Reheat";
                        callingPlace = 2;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetCoolingEndTemp.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        tfPresentation.text = "Cooling and Reheat";
                        callingPlace = 2;
                        context
                            .read<BluetoothCubit>()
                            .readInfraredTemperatureData();
                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetCoolingEndTemp.text = state["infrared"]!;
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
                      controller: tfAssetCoolingEndDate,
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
                        tfAssetCoolingEndDate.text =
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

  Widget _buildThirdMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isThirdMeasurementExpanded =
              !isThirdMeasurementExpanded; // Durumu değiştir
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isThirdMeasurementExpanded
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
            Text("Tekrar Isıtma Ölçümü",
                style: TextStyle(
                  fontSize: isThirdMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isThirdMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetCoolingReheatTemp,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.thermostat,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        callingPlace = 3;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetCoolingReheatTemp.text =
                                state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.thermostat,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        callingPlace = 3;
                        context
                            .read<BluetoothCubit>()
                            .readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetCoolingReheatTemp.text = state["infrared"]!;
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
                      controller: tfAssetCoolingReheatDate,
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
                        tfAssetCoolingReheatDate.text =
                            selectedDateTime.toString();
                      });
                    },
                  ),

                ],
              ),
              const SizedBox(height: 15,),
              const Text(
                "Tekrar Isıtmada ürün merkez sıcaklığının minimum 85 derece olması gerekmektedir",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
            double parsedTempStart = double.tryParse(tfAssetCoolingStartTemp
                    .text
                    .replaceAll(RegExp(r'[^\d.]'), '')) ??
                0;
            double parsedTempEnd = double.tryParse(tfAssetCoolingEndTemp.text
                    .replaceAll(RegExp(r'[^\d.]'), '')) ??
                0;
            double parsedTempCoolingReheat = double.tryParse(
                    tfAssetCoolingReheatTemp.text
                        .replaceAll(RegExp(r'[^\d.]'), '')) ??
                0;

            context.read<HotProcessInfoCubit>().hotProcessUpdate(
                widget.asset.id,
                widget.asset.asset_name,
                widget.asset.user_name,
                widget.asset.quantity,
                widget.asset.first_temperature,
                widget.asset.banket_temperature_one,
                widget.asset.banket_temperature_two,
                widget.asset.banket_temperature_three,
                widget.asset.banket_temperature_four,
                widget.asset.banket_date_one,
                widget.asset.banket_date_two,
                widget.asset.banket_date_three,
                widget.asset.banket_date_four,
                widget.asset.sample,
                tfPresentation.text,
                widget.asset.submit_date,
                widget.asset.process_times,
                widget.asset.hotel,
                widget.asset.buffed_temp_one,
                widget.asset.buffed_temp_two,
                widget.asset.buffed_temp_three,
                widget.asset.buffed_temp_four,
                widget.asset.buffed_temp_five,
                widget.asset.buffed_temp_six,
                widget.asset.buffed_date_one,
                widget.asset.buffed_date_two,
                widget.asset.buffed_date_three,
                widget.asset.buffed_date_four,
                widget.asset.buffed_date_five,
                widget.asset.buffed_date_six,
                parsedTempStart,
                parsedTempEnd,
                tfAssetCoolingDate.text,
                widget.asset.section_name,
                widget.asset.reso_num,
                widget.asset.first_buffed_status,
                widget.asset.banket,
                widget.asset.asset_result,
                parsedTempCoolingReheat,
                tfAssetCoolingReheatDate.text,
                tfAssetCoolingEndDate.text);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HotProcessListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: Text(submitText),
        ),
      ],
    );
  }
}
