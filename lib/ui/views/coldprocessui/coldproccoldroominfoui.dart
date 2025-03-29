import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldprocessasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocessinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/coldprocessui/coldprocesslistui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/temperature_bloc.dart';
import '../homepage.dart';

class ColdProcColdRoomInfoUI extends StatefulWidget {
  final ColdProcessAsset asset;
  final User user;
  final Role userRole;
  const ColdProcColdRoomInfoUI({required this.asset,required this.user, required this.userRole, super.key});

  @override
  State<ColdProcColdRoomInfoUI> createState() => _ColdProcColdRoomInfoUIState();
}

class _ColdProcColdRoomInfoUIState extends State<ColdProcColdRoomInfoUI> {
  var tfAssetColdRoomTempFirst = TextEditingController();
  var tfAssetColdRoomDateFirst = TextEditingController();
  var tfAssetColdRoomTempSecond = TextEditingController();
  var tfAssetColdRoomDateSecond = TextEditingController();
  var tfAssetColdRoomTempThird = TextEditingController();
  var tfAssetColdRoomDateThird = TextEditingController();
  var tfAssetTempDateFirst = TextEditingController();
  var tfAssetColdRoomTempFour = TextEditingController();
  var tfAssetColdRoomDateFour = TextEditingController();
  var tfAssetStatus = TextEditingController();



  String? timeString;
  bool secTempBool = true;
  bool isExpanded = false;
  bool isFirstMeasurementExpanded = false;
  bool isSecondMeasurementExpanded = false;
  bool isThirdMeasurementExpanded = false;
  bool isFourthMeasurementExpanded = false;

  int _selectedIndex = 0;
  DateTime? selectedDate;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Homepage(user: widget.user, userRole: widget.userRole),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var asset = widget.asset;
    tfAssetColdRoomTempFirst.text = asset.cold_room_temp_one.toString();
    tfAssetColdRoomDateFirst.text = asset.cold_room_time_one.toString();
    tfAssetColdRoomTempSecond.text = asset.cold_room_temp_two.toString();
    tfAssetColdRoomDateSecond.text = asset.cold_room_time_two.toString();
    tfAssetColdRoomTempThird.text = asset.cold_room_temp_three.toString();
    tfAssetColdRoomDateThird.text = asset.cold_room_time_three.toString();
    tfAssetColdRoomTempFour.text = asset.cold_room_temp_four.toString();
    tfAssetColdRoomDateFour.text = asset.cold_room_time_four;
    tfAssetStatus.text = asset.asset_status;
    if(widget.asset.cold_room_temp_one != -1000.0)
      secTempBool = false;
    if(widget.asset.cold_room_temp_two != -1000.0 && widget.asset.cold_room_temp_three == -1000.0)
      secTempBool = true;

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
    child: Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Cold Room Information"),
      ), body: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAssetInfoCard(),
            const SizedBox(height: 16),

            _buildFirstMeasurementWidget(),
            const SizedBox(height: 16),

            if(widget.asset.cold_room_temp_one != -1000.0)
              _buildSecondMeasurementWidget(),
              const SizedBox(height: 16),

            if(widget.asset.cold_room_temp_two != -1000.0)
              _buildThirdMeasurementWidget(),
            const SizedBox(height: 16),

            if(widget.asset.cold_room_temp_three != -1000.0)
              _buildFourthMeasurementWidget(),
            const SizedBox(height: 16),

            _buildSubmitButtons(),
          ],
        ),
      ),
    ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    ),
    );
  }

  Widget _buildAssetInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${widget.asset.asset_name} Info",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text("Asset Name: ${widget.asset.asset_name}",
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Status: ${widget.asset.asset_status}",
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Date: ${widget.asset.asset_presentation_time}",
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _buildFirstMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFirstMeasurementExpanded =
          !isFirstMeasurementExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isFirstMeasurementExpanded
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
            Text("Soğuk Bekletme 1. Ölçüm",
                style: TextStyle(
                  fontSize: isFirstMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFirstMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdRoomTempFirst,
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
                            tfAssetColdRoomTempFirst.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetColdRoomTempFirst.text = state["infrared"]!;
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
                      controller: tfAssetColdRoomDateFirst,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        selectedDate = DateTime.now();
                        DateTime now = DateTime.now();
                        timeString = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
                        tfAssetColdRoomDateFirst.text = selectedDate.toString();
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
            Text("Soğuk Bekletme 2. Ölçüm",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdRoomTempSecond,
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
                            tfAssetColdRoomTempSecond.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetColdRoomTempSecond.text = state["infrared"]!;
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
                      controller: tfAssetColdRoomDateSecond,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        selectedDate = DateTime.now();
                        DateTime now = DateTime.now();
                        timeString = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
                        tfAssetColdRoomDateSecond.text = selectedDate.toString();
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
          isThirdMeasurementExpanded = !isThirdMeasurementExpanded;
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
            Text("Soğuk Bekletme 3. Ölçüm",
                style: TextStyle(
                  fontSize: isThirdMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isThirdMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdRoomTempThird,
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
                            tfAssetColdRoomTempThird.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetColdRoomTempThird.text = state["infrared"]!;
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
                      controller: tfAssetColdRoomDateThird,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        selectedDate = DateTime.now();
                        DateTime now = DateTime.now();
                        timeString = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
                        tfAssetColdRoomDateThird.text =selectedDate.toString();
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
  Widget _buildFourthMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFourthMeasurementExpanded =
          !isFourthMeasurementExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isFourthMeasurementExpanded
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
            Text("Soğuk Bekletme 4. Ölçüm",
                style: TextStyle(
                  fontSize: isFourthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFourthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetColdRoomTempFour,
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
                            tfAssetColdRoomTempFour.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetColdRoomTempFour.text = state["infrared"]!;
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
                      controller: tfAssetColdRoomDateFour,
                      decoration: const InputDecoration(
                        labelText: 'Tarih',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      setState(() {
                        selectedDate = DateTime.now();
                        DateTime now = DateTime.now();
                        timeString = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}"; // Güncel tarihi ve saati al
                        tfAssetColdRoomDateFour.text = selectedDate.toString();
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(secTempBool)
        ElevatedButton(
          onPressed: () {
            tfAssetStatus.text = "Soğuk Oda";
            double parsedTemperatureOne = double.tryParse(tfAssetColdRoomTempFirst.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureTwo = double.tryParse(tfAssetColdRoomTempSecond.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureThree = double.tryParse(tfAssetColdRoomTempThird.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureFour = double.tryParse(tfAssetColdRoomTempFour.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

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
                parsedTemperatureOne,
                tfAssetColdRoomDateFirst.text,
                parsedTemperatureTwo,
                tfAssetColdRoomDateSecond.text,
                widget.asset.cold_buffed_temp_one,
                widget.asset.cold_buffed_time_one,
                widget.asset.cold_buffed_temp_two,
                widget.asset.cold_buffed_time_two,
                widget.asset.cold_buffed_temp_three,
                widget.asset.cold_buffed_time_three,
                widget.asset.first_buffed_status,
                widget.asset.first_buffed_temp,
                widget.asset.first_buffed_time,
                parsedTemperatureThree,
                tfAssetColdRoomDateThird.text,
                widget.asset.cold_buffed_temp_four,
                widget.asset.cold_buffed_time_four,
                widget.asset.cold_buffed_temp_five,
                widget.asset.cold_buffed_time_five,
                widget.asset.cold_buffed_temp_six,
                widget.asset.cold_buffed_time_six,
                tfAssetStatus.text,
                widget.user.hotel,
                widget.user.section_id,
                parsedTemperatureFour,
                tfAssetColdRoomDateFour.text);

              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ColdProcessListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text("Soğuk Odaya Aktar"),
        ),
        ElevatedButton(
          onPressed: () {
            tfAssetStatus.text = "Büfe/Sunum";
            double parsedTemperatureOne = double.tryParse(tfAssetColdRoomTempFirst.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureTwo = double.tryParse(tfAssetColdRoomTempSecond.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureThree = double.tryParse(tfAssetColdRoomTempThird.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureFour = double.tryParse(tfAssetColdRoomTempFour.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

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
                parsedTemperatureOne,
                tfAssetColdRoomDateFirst.text,
                parsedTemperatureTwo,
                tfAssetColdRoomDateSecond.text,
                widget.asset.cold_buffed_temp_one,
                widget.asset.cold_buffed_time_one,
                widget.asset.cold_buffed_temp_two,
                widget.asset.cold_buffed_time_two,
                widget.asset.cold_buffed_temp_three,
                widget.asset.cold_buffed_time_three,
                widget.asset.first_buffed_status,
                widget.asset.first_buffed_temp,
                widget.asset.first_buffed_time,
                parsedTemperatureThree,
                tfAssetColdRoomDateThird.text,
                widget.asset.cold_buffed_temp_four,
                widget.asset.cold_buffed_time_four,
                widget.asset.cold_buffed_temp_five,
                widget.asset.cold_buffed_time_five,
                widget.asset.cold_buffed_temp_six,
                widget.asset.cold_buffed_time_six,
                tfAssetStatus.text,
                widget.user.hotel,
                widget.user.section_id,
                parsedTemperatureFour,
                tfAssetColdRoomDateFour.text);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ColdProcessListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text("Büfeye Aktar"),
        ),
      ],
    );
  }
}