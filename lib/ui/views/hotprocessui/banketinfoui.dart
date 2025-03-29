import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/hotprocessasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocessinfo_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/temperature_bloc.dart';
import '../homepage.dart';
import 'hotprocesslistui.dart';
import 'package:intl/intl.dart'; // Tarih formatlamak için

class BanketInfoUI extends StatefulWidget {
  final HotProcessAsset asset;
  final User user;
  final Role userRole;

  const BanketInfoUI({
    required this.asset,
    required this.user,
    required this.userRole,
    super.key,
  });

  @override
  State<BanketInfoUI> createState() => _BanketInfoUIState();
}

class _BanketInfoUIState extends State<BanketInfoUI> {
  var tfAssetName = TextEditingController();
  var tfAssetQuantity = TextEditingController();
  var tfAssetTemperature = TextEditingController();
  var tfAssetPresentation = TextEditingController();
  var tfAssetBanketTempOne = TextEditingController();
  var tfAssetBanketDateOne = TextEditingController();
  var tfAssetBanketTempTwo = TextEditingController();
  var tfAssetBanketDateTwo = TextEditingController();
  var tfAssetBanketTempThree = TextEditingController();
  var tfAssetBanketDateThree = TextEditingController();
  var tfAssetBanketTempFour = TextEditingController();
  var tfAssetBanketDateFour = TextEditingController();



  bool isExpanded = false;
  bool isSecondMeasurementExpanded = false;
  bool isThirdMeasurementExpanded = false;
  bool isFourthMeasurementExpanded = false;

  String? timeString;
  int _selectedIndex = 0;
  DateTime? selectedDateTime;
  bool secTempBool = true;
  int callingPlace = 0;


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
    super.initState();
    var asset = widget.asset;
    tfAssetName.text = asset.asset_name;
    tfAssetBanketTempOne.text = asset.banket_temperature_one.toString();
    tfAssetBanketDateOne.text = asset.banket_date_one;
    tfAssetBanketTempTwo.text = asset.banket_temperature_two.toString();
    tfAssetBanketDateTwo.text = asset.banket_date_two;
    tfAssetBanketTempThree.text = asset.banket_temperature_three.toString();
    tfAssetBanketDateThree.text = asset.banket_date_three;
    tfAssetBanketTempFour.text = asset.banket_temperature_four.toString();
    tfAssetBanketDateFour.text = asset.banket_date_four;
    if(widget.asset.banket_temperature_one != 333.0)
      secTempBool = false;
    if(widget.asset.banket_temperature_two != 333.0 && widget.asset.banket_temperature_three == 333.0)
      secTempBool = true;

  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HotProcessListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child:Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Banket Ölçüm"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildFirstMeasurementWidget(),
                const SizedBox(height: 16),
                if(widget.asset.banket_temperature_one != 333.0)
                  _buildSecondMeasurementWidget(), // Yeni ölçüm widget'ı
                const SizedBox(height: 16),
                if (widget.asset.banket_temperature_two != 333)
                  _buildThirdMeasurementWidget(),
                const SizedBox(height: 16),
                if (widget.asset.banket_temperature_three != 333)
                  _buildFourthMeasurementWidget(),

                const SizedBox(height: 16),
                _buildSubmitButtons(secTempBool),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,),
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
            Text("1.Banket Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBanketTempOne,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        callingPlace = 1;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempOne.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        callingPlace = 1;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempOne.text = state["infrared"]!;
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
                      controller: tfAssetBanketDateOne,
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
                        tfAssetBanketDateOne.text = selectedDateTime.toString();
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
            Text("2.Banket Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBanketTempTwo,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        callingPlace = 2;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempTwo.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        callingPlace = 2;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempTwo.text = state["infrared"]!;
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
                      controller: tfAssetBanketDateTwo,
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
                        tfAssetBanketDateTwo.text = selectedDateTime.toString();
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
            Text("3.Banket Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isThirdMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isThirdMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBanketTempThree,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        callingPlace = 3;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempThree.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red,),
                    onPressed: () {
                      setState(() {
                        callingPlace = 3;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempThree.text = state["infrared"]!;
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
                      controller: tfAssetBanketDateThree,
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
                        tfAssetBanketDateThree.text = selectedDateTime.toString();
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
          !isFourthMeasurementExpanded; // Durumu değiştir
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
            Text("4.Banket Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isFourthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFourthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBanketTempFour,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        callingPlace = 4;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempFour.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red),
                    onPressed: () {
                      setState(() {
                        callingPlace = 4;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBanketTempFour.text = state["infrared"]!;
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
                      controller: tfAssetBanketDateFour,
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
                        tfAssetBanketDateFour.text = selectedDateTime.toString();
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


  Widget _buildSubmitButtons(bool secTempBool) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            tfAssetPresentation.text = "Buffed";
            double parsedTemperatureOne = double.tryParse(tfAssetBanketTempOne.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedTemperatureTwo = double.tryParse(tfAssetBanketTempTwo.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedTemperatureThree = double.tryParse(tfAssetBanketTempThree.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedTemperatureFour = double.tryParse(tfAssetBanketTempFour.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;


            context.read<HotProcessInfoCubit>().hotProcessUpdate(widget.asset.id, widget.asset.asset_name, widget.user.username, widget.asset.quantity, widget.asset.first_temperature, parsedTemperatureOne,
                parsedTemperatureTwo, parsedTemperatureThree,parsedTemperatureFour, tfAssetBanketDateOne.text, tfAssetBanketDateTwo.text,
                tfAssetBanketDateThree.text, tfAssetBanketDateFour.text, widget.asset.sample, tfAssetPresentation.text,
                widget.asset.submit_date, widget.asset.process_times, widget.user.hotel, widget.asset.buffed_temp_one,
                widget.asset.buffed_temp_two, widget.asset.buffed_temp_three, widget.asset.buffed_temp_four,
                widget.asset.buffed_temp_five, widget.asset.buffed_temp_six, widget.asset.buffed_date_one,
                widget.asset.buffed_date_two, widget.asset.buffed_date_three, widget.asset.buffed_date_four,
                widget.asset.buffed_date_five, widget.asset.buffed_date_six, widget.asset.cooling_start_temp,
                widget.asset.cooling_end_temp, widget.asset.cooling_date, widget.user.section_id, widget.asset.reso_num,
                widget.asset.first_buffed_status, widget.asset.banket,
                widget.asset.asset_result,widget.asset.cooling_reheat_temp,
                widget.asset.cooling_reheat_date,widget.asset.cooling_end_date);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HotProcessListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text("Büfe"),
        ),
        if(secTempBool)
          ElevatedButton(
            onPressed: () {
              tfAssetPresentation.text = "Banket";
              double parsedTemperatureOne = double.tryParse(tfAssetBanketTempOne.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
              double parsedTemperatureTwo = double.tryParse(tfAssetBanketTempTwo.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
              double parsedTemperatureThree = double.tryParse(tfAssetBanketTempThree.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
              double parsedTemperatureFour = double.tryParse(tfAssetBanketTempFour.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;


              context.read<HotProcessInfoCubit>().hotProcessUpdate(widget.asset.id, widget.asset.asset_name, widget.user.username,
                  widget.asset.quantity, widget.asset.first_temperature, parsedTemperatureOne,
                  parsedTemperatureTwo, parsedTemperatureThree,parsedTemperatureFour, tfAssetBanketDateOne.text, tfAssetBanketDateTwo.text,
                  tfAssetBanketDateThree.text, tfAssetBanketDateFour.text, widget.asset.sample, tfAssetPresentation.text,
                  widget.asset.submit_date, widget.asset.process_times, widget.user.hotel, widget.asset.buffed_temp_one,
                  widget.asset.buffed_temp_two, widget.asset.buffed_temp_three, widget.asset.buffed_temp_four,
                  widget.asset.buffed_temp_five, widget.asset.buffed_temp_six, widget.asset.buffed_date_one,
                  widget.asset.buffed_date_two, widget.asset.buffed_date_three, widget.asset.buffed_date_four,
                  widget.asset.buffed_date_five, widget.asset.buffed_date_six, widget.asset.cooling_start_temp,
                  widget.asset.cooling_end_temp, widget.asset.cooling_date, widget.user.section_id, widget.asset.reso_num,
                  widget.asset.first_buffed_status, widget.asset.banket,
                  widget.asset.asset_result,widget.asset.cooling_reheat_temp,
                  widget.asset.cooling_reheat_date,widget.asset.cooling_end_date);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HotProcessListUI(
                        user: widget.user, userRole: widget.userRole)),
              );
            },
            style: ElevatedButton.styleFrom(),
            child: const Text("Bankete Aktar"),
          ),
      ],
    );
  }
}