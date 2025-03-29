import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/ui/cubit/thawingprocinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawingproclistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/thawingprocess.dart';
import '../../../data/entity/user.dart';
import '../../middleware/temperature_bloc.dart';

class ThawProcAssetConInfoUI extends StatefulWidget {
  final ThawingProcess asset;
  final User user;
  final Role userRole;

  const ThawProcAssetConInfoUI({
    required this.asset,
    required this.user,
    required this.userRole,
    super.key,
  });
  @override
  State<ThawProcAssetConInfoUI> createState() => _ThawProcAssetConInfoUIState();
}


class _ThawProcAssetConInfoUIState extends State<ThawProcAssetConInfoUI> {
  var tfAssetThawTempOne = TextEditingController();
  var tfAssetThawDateOne = TextEditingController();
  var tfAssetThawTempTwo = TextEditingController();
  var tfAssetThawDateTwo = TextEditingController();
  var tfAssetThawTempThree = TextEditingController();
  var tfAssetThawDateThree = TextEditingController();
  var tfAssetThawTempFour = TextEditingController();
  var tfAssetThawDateFour = TextEditingController();
  var tfAssetResult = TextEditingController();

  bool isExpanded = false;
  bool isSecondMeasurementExpanded = false;
  bool isThirdMeasurementExpanded = false;
  bool isFourthMeasurementExpanded = false;
  String? timeString;
  DateTime? selectedDateTime;
  bool isSecondAvailable = false;
  bool isThirdAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tfAssetThawTempOne.text = widget.asset.asset_thawing_temp_one.toString();
    tfAssetThawTempTwo.text = widget.asset.asset_thawing_temp_two.toString();
    tfAssetThawTempThree.text = widget.asset.asset_thawing_temp_three.toString();
    tfAssetThawDateOne.text = widget.asset.asset_thawing_time_one;
    tfAssetThawDateTwo.text = widget.asset.asset_thawing_time_two;
    tfAssetThawDateThree.text = widget.asset.asset_thawing_time_three;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("Çözündürme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildFirstMeasurementWidget(),
              const SizedBox(height: 16),
              if(widget.asset.asset_thawing_temp_one != -333)
                _buildSecondMeasurementWidget(),

              const SizedBox(height: 16),
              if(widget.asset.asset_thawing_temp_two != -333)
                _buildThirdMeasurementWidget(),
              const SizedBox(height: 16),
              _buildAssetResultOption(),
              _buildSubmitButtons(),
            ],
          ),
        ),
      ),

    );
  }
  Widget _buildFirstMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded =
          !isExpanded; // Durumu değiştir
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isExpanded
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
            Text("1.Çözündürme Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetThawTempOne,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetThawTempOne.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetThawTempOne.text = state["infrared"]!;
                          });
                        }                      });
                    },
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetThawDateOne,
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
                        tfAssetThawDateOne.text = selectedDateTime.toString();
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
  Widget _buildSecondMeasurementWidget() {
    isSecondAvailable = true;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSecondMeasurementExpanded =
          !isSecondMeasurementExpanded;
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
            Text("2.Çözündürme Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetThawTempTwo,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetThawTempTwo.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetThawTempTwo.text = state["infrared"]!;
                          });
                        }                      });
                    },
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetThawDateTwo,
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
                        tfAssetThawDateTwo.text = selectedDateTime.toString();
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
    isThirdAvailable = true;
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
            Text("3.Çözündürme Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isThirdMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isThirdMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetThawTempThree,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetThawTempThree.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetThawTempThree.text = state["infrared"]!;
                          });
                        }                      });
                    },
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetThawDateThree,
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
                        tfAssetThawDateThree.text = selectedDateTime.toString();
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
  Widget _buildAssetResultOption() {
    List<String> options = [];
    if (double.tryParse(tfAssetThawTempOne.text) != null) {
      if (double.parse(tfAssetThawTempOne.text) < 0 && isSecondAvailable==false && isThirdAvailable == false) {
        options = ['Çözündürme', 'Suda Çözündürme'];
      }else if(double.parse(tfAssetThawTempTwo.text) < 0 && isThirdAvailable == false ){
        options = ['Çözündürme', 'Suda Çözündürme'];
      }
      else {
        options = ['Tamamlanan'];
      }
    }
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Sonuç Seçin'),
      value: tfAssetResult.text.isEmpty ? null : tfAssetResult.text,
      onChanged: (value) {
        setState(() {
          tfAssetResult.text = value!;
        });
      },
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems() {
    // Sıcaklık değerlerini kontrol et
    double? tempOne = double.tryParse(tfAssetThawTempOne.text);
    double? tempTwo = double.tryParse(tfAssetThawTempTwo.text);
    double? tempThree = double.tryParse(tfAssetThawTempThree.text);

    // Sıcaklık değerlerinden herhangi biri 0'dan büyükse sadece 'tamamlanan' seçeneği olacak
    if ((tempOne != null && tempOne > 0) ||
        (tempTwo != null && tempTwo > 0) ||
        (tempThree != null && tempThree > 0)) {
      tfAssetResult.text = 'tamamlanan';
      return const [
        DropdownMenuItem(value: 'tamamlanan', child: Text('Tamamlanan')),
      ];
    } else {
      tfAssetResult.text = 'çözündürme';
      // Aksi halde 'çözündürme' ve 'suda çözündürme' seçeneklerini göster
      return const [
        DropdownMenuItem(value: 'çözündürme', child: Text('Çözündürme')),
        DropdownMenuItem(value: 'suda çözündürme', child: Text('Suda Çözündürme')),
      ];
    }
  }
  Widget _buildSubmitButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            double parsedTempOne = double.tryParse(tfAssetThawTempOne.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTempTwo = double.tryParse(tfAssetThawTempTwo.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTempThree = double.tryParse(tfAssetThawTempThree.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

            context.read<ThawingProcInfoCubit>().thawingProcUpdate(
                widget.asset.id,
                widget.user.section_id,
                widget.asset.asset_env_temp,
                widget.user.username,
                tfAssetResult.text,
                widget.asset.asset_name,
                widget.asset.asset_party_no,
                widget.asset.asset_exp_no,
                widget.asset.asset_quantity,
                widget.asset.asset_temp_one,
                widget.asset.asset_time_one,
                parsedTempOne,//asset_thawing_temp_one,
                tfAssetThawDateOne.text,//asset_thawing_time_one,
                parsedTempTwo,//asset_thawing_temp_two,
                tfAssetThawDateTwo.text,//asset_thawing_time_two,
                parsedTempThree,//asset_thawing_temp_three,
                tfAssetThawDateThree.text,//asset_thawing_time_three,
                widget.asset.asset_process_temp,
                widget.asset.asset_process_time,
                widget.asset.asset_sending_place,
                widget.asset.asset_sending_quantity,
                widget.asset.asset_sending_process_type,
                widget.asset.asset_sending_place_temp,
                widget.asset.kalan,
                widget.asset.hotel);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ThawingProcListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text("Çözündürmeye Devam Et"),
        ),

      ],
    );
  }


}
