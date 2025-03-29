import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';

import '../../../data/entity/coldprocessasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../cubit/coldprocessinfo_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/temperature_bloc.dart';
import '../homepage.dart';
import 'coldprocesslistui.dart';

class ColdProcBuffedInfoUI extends StatefulWidget {
  final ColdProcessAsset asset;
  final User user;
  final Role userRole;
  const ColdProcBuffedInfoUI({required this.asset,required this.user, required this.userRole, super.key});


  @override
  State<ColdProcBuffedInfoUI> createState() => _ColdProcBuffedInfoUIState();
}

class _ColdProcBuffedInfoUIState extends State<ColdProcBuffedInfoUI> {
  var tfColdBuffedNo = TextEditingController();
  var tfAssetBuffedTempFirst= TextEditingController();
  var tfAssetBuffedDateFirst = TextEditingController();
  var tfAssetBuffedTempSecond = TextEditingController();
  var tfAssetBuffedDateSecond = TextEditingController();
  var tfAssetBuffedTempThird = TextEditingController();
  var tfAssetBuffedDateThird = TextEditingController();
  var tfAssetBuffedTempForth = TextEditingController();
  var tfAssetBuffedDateForth = TextEditingController();
  var tfAssetBuffedTempFifth = TextEditingController();
  var tfAssetBuffedDateFifth = TextEditingController();
  var tfAssetBuffedTempSixth = TextEditingController();
  var tfAssetBuffedDateSixth = TextEditingController();
  var tfAssetStatus = TextEditingController();

  bool isExpanded = false;
  bool isFirstMeasurementExpanded = false;

  bool isSecondMeasurementExpanded = false;
  bool isThirdMeasurementExpanded = false;
  bool isFourthMeasurementExpanded = false;
  bool isFifthMeasurementExpanded = false;
  bool isSixthMeasurementExpanded = false;
  String? timeString;
  DateTime? selectedDate;
  int _selectedIndex = 0;

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
    tfAssetBuffedTempFirst.text = asset.cold_buffed_temp_one.toString();
    tfAssetBuffedDateFirst.text = asset.cold_buffed_time_one.toString();
    tfAssetBuffedTempSecond.text = asset.cold_buffed_temp_two.toString();
    tfAssetBuffedDateSecond.text = asset.cold_buffed_time_two.toString();
    tfAssetBuffedTempThird.text = asset.cold_buffed_temp_three.toString();
    tfAssetBuffedDateThird.text = asset.cold_buffed_time_three.toString();
    tfAssetBuffedTempForth.text = asset.cold_buffed_temp_four.toString();
    tfAssetBuffedDateForth.text = asset.cold_buffed_time_four.toString();
    tfAssetBuffedTempFifth.text = asset.cold_buffed_temp_five.toString();
    tfAssetBuffedDateFifth.text = asset.cold_buffed_time_five.toString();
    tfAssetBuffedTempSixth.text = asset.cold_buffed_temp_six.toString();
    tfAssetBuffedDateSixth.text = asset.cold_buffed_time_six.toString();
    tfColdBuffedNo.text = asset.cold_buffed_no.toString();
    tfAssetStatus.text = asset.asset_status;
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
        title: const Text("Büfe/Sunum"),
      ), body: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: tfColdBuffedNo,
              decoration: InputDecoration(
                labelText: "Büfe Numarası",
                hintText: "Büfe numarasını giriniz",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            _buildFirstMeasurementWidget(),
            const SizedBox(height: 16),
            if(widget.asset.cold_buffed_temp_one != -1000.0)
              _buildSecondMeasurementWidget(),

            const SizedBox(height: 16),
            if(widget.asset.cold_buffed_temp_two != -1000.0)
              _buildThirdMeasurementWidget(),
            const SizedBox(height: 16),
            if(widget.asset.cold_buffed_temp_three != -1000.0)
              _buildFourthMeasurementWidget(),
            const SizedBox(height: 16),
            if(widget.asset.cold_buffed_temp_four != -1000.0)
              _buildFifthMeasurementWidget(),
            const SizedBox(height: 16),
            if(widget.asset.cold_buffed_temp_five != -1000.0)
              _buildSixthMeasurementWidget(),
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
    ),);
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
            Text("1.Büfe Ölçümü",
                style: TextStyle(
                  fontSize: isFirstMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFirstMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempFirst,
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
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempFirst.text = state["temperature"]!;
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
                            tfAssetBuffedTempFirst.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateFirst,
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
                        tfAssetBuffedDateFirst.text = selectedDate.toString();
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
            Text("2.Büfe Ölçümü",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempSecond,
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
                            tfAssetBuffedTempSecond.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempSecond.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateSecond,
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
                        tfAssetBuffedDateSecond.text = selectedDate.toString();

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
          !isThirdMeasurementExpanded;
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
            Text("3.Büfe Ölçümü",
                style: TextStyle(
                  fontSize: isThirdMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isThirdMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempThird,
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
                            tfAssetBuffedTempThird.text = state["temperature"]!;
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
                            tfAssetBuffedTempThird.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateThird,
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
                        tfAssetBuffedDateThird.text = selectedDate.toString();
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
            Text("4.Büfe Ölçümü",
                style: TextStyle(
                  fontSize: isFourthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFourthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempForth,
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
                            tfAssetBuffedTempForth.text = state["temperature"]!;
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
                            tfAssetBuffedTempForth.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateForth,
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
                        tfAssetBuffedDateForth.text = selectedDate.toString();
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
  Widget _buildFifthMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFifthMeasurementExpanded =
          !isFifthMeasurementExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isFifthMeasurementExpanded
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
            Text("5.Büfe Ölçümü",
                style: TextStyle(
                  fontSize: isFifthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFifthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempFifth,
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
                            tfAssetBuffedTempFifth.text = state["temperature"]!;
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
                            tfAssetBuffedTempFifth.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateFifth,
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
                        tfAssetBuffedDateFifth.text = selectedDate.toString();
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
  Widget _buildSixthMeasurementWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSixthMeasurementExpanded =
          !isSixthMeasurementExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: isSixthMeasurementExpanded
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
            Text("6.Büfe Ölçümü",
                style: TextStyle(
                  fontSize: isSixthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSixthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempSixth,
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
                            tfAssetBuffedTempSixth.text = state["temperature"]!;
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
                            tfAssetBuffedTempSixth.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateSixth,
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
                        tfAssetBuffedDateSixth.text = selectedDate.toString();
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
        ElevatedButton(

          onPressed: () {
            double parsedBuffedTempOne = double.tryParse(tfAssetBuffedTempFirst.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempTwo = double.tryParse(tfAssetBuffedTempSecond.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempThree = double.tryParse(tfAssetBuffedTempThird.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempFour = double.tryParse(tfAssetBuffedTempForth.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureFive = double.tryParse(tfAssetBuffedTempFifth.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempSix = double.tryParse(tfAssetBuffedTempSixth.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            tfAssetStatus.text = "Büfe/Sunum";
            context.read<ColdProcessInfoCubit>().coldProcUpdate(widget.asset.id,
                widget.asset.asset_name,
                widget.user.username,
                widget.asset.sample,
                widget.asset.asset_quantity,
                widget.asset.cold_room_name,
                tfColdBuffedNo.text,
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
                parsedBuffedTempOne,
                tfAssetBuffedDateFirst.text,
                parsedBuffedTempTwo,
                tfAssetBuffedDateSecond.text,
                parsedBuffedTempThree,
                tfAssetBuffedDateThird.text,
                widget.asset.first_buffed_status,
                widget.asset.first_buffed_temp,
                widget.asset.first_buffed_time,
                widget.asset.cold_room_temp_three,
                widget.asset.cold_room_time_three,
                parsedBuffedTempFour,
                tfAssetBuffedDateForth.text,
                parsedTemperatureFive,
                tfAssetBuffedDateFifth.text,
                parsedBuffedTempSix,
                tfAssetBuffedDateSixth.text,
                tfAssetStatus.text,
                widget.user.hotel,
                widget.user.section_id,
                widget.asset.cold_room_temp_four,
                widget.asset.cold_room_time_four);

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
        ElevatedButton(
          onPressed: () {
            double parsedBuffedTempOne = double.tryParse(tfAssetBuffedTempFirst.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempTwo = double.tryParse(tfAssetBuffedTempSecond.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempThree = double.tryParse(tfAssetBuffedTempThird.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempFour = double.tryParse(tfAssetBuffedTempForth.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedTemperatureFive = double.tryParse(tfAssetBuffedTempFifth.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            double parsedBuffedTempSix = double.tryParse(tfAssetBuffedTempSixth.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
            tfAssetStatus.text = "Büfe Sonu";
            context.read<ColdProcessInfoCubit>().coldProcUpdate(
                widget.asset.id,
                widget.asset.asset_name,
                widget.user.username,
                widget.asset.sample,
                widget.asset.asset_quantity,
                widget.asset.cold_room_name,
                tfColdBuffedNo.text,
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
                parsedBuffedTempOne,
                tfAssetBuffedDateFirst.text,
                parsedBuffedTempTwo,
                tfAssetBuffedDateSecond.text,
                parsedBuffedTempThree,
                tfAssetBuffedDateThird.text,
                widget.asset.first_buffed_status,
                widget.asset.first_buffed_temp,
                widget.asset.first_buffed_time,
                widget.asset.cold_room_temp_three,
                widget.asset.cold_room_time_three,
                parsedBuffedTempFour,
                tfAssetBuffedDateForth.text,
                parsedTemperatureFive,
                tfAssetBuffedDateFifth.text,
                parsedBuffedTempSix,
                tfAssetBuffedDateSixth.text,
                tfAssetStatus.text,
                widget.user.hotel,
                widget.user.section_id,
                widget.asset.cold_room_temp_four,
                widget.asset.cold_room_time_four);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ColdProcessListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text("Büfe Sonu'na Aktar"),
        ),
      ],
    );
  }
}