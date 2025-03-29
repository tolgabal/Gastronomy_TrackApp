import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/resonumasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocessinfo_cubit.dart';

import '../../../color.dart';
import '../../../data/entity/hotprocessasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../cubit/resonumassetlist_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/temperature_bloc.dart';
import '../homepage.dart';
import 'hotprocesslistui.dart';

class BuffedInfoUI extends StatefulWidget {
  final HotProcessAsset asset;
  final User user;
  final Role userRole;
  const BuffedInfoUI({required this.asset,required this.user, required this.userRole, super.key});

  @override
  State<BuffedInfoUI> createState() => _BuffedInfoUIState();
}

class _BuffedInfoUIState extends State<BuffedInfoUI> {
  var tfAssetBuffedTempOne = TextEditingController();
  var tfAssetBuffedDateOne = TextEditingController();
  var tfAssetBuffedTempTwo = TextEditingController();
  var tfAssetBuffedDateTwo = TextEditingController();
  var tfAssetBuffedTempThree = TextEditingController();
  var tfAssetBuffedDateThree = TextEditingController();
  var tfAssetBuffedTempFour = TextEditingController();
  var tfAssetBuffedDateFour = TextEditingController();
  var tfAssetBuffedTempFive = TextEditingController();
  var tfAssetBuffedDateFive = TextEditingController();
  var tfAssetBuffedTempSix = TextEditingController();
  var tfAssetBuffedDateSix = TextEditingController();
  var tfAssetPresentation = TextEditingController();
  var tfAssetResoNum = TextEditingController();

  bool isExpanded = false;
  bool isSecondMeasurementExpanded = false;
  bool isThirdMeasurementExpanded = false;
  bool isFourthMeasurementExpanded = false;
  bool isFifthMeasurementExpanded = false;
  bool isSixthMeasurementExpanded = false;

  String? selectedResoid;
  int buffedPlace = 0;
  DateTime? selectedDateTime;
  String? timeString;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  bool secTempBool = false;

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
    tfAssetBuffedTempOne.text = asset.buffed_temp_one.toString();
    tfAssetBuffedTempTwo.text = asset.buffed_temp_two.toString();
    tfAssetBuffedTempThree.text = asset.buffed_temp_three.toString();
    tfAssetBuffedTempFour.text = asset.buffed_temp_four.toString();
    tfAssetBuffedTempFive.text = asset.buffed_temp_five.toString();
    tfAssetBuffedTempSix.text = asset.buffed_temp_six.toString();
    tfAssetBuffedDateOne.text = asset.buffed_date_one.toString();
    tfAssetBuffedDateTwo.text = asset.buffed_date_two.toString();
    tfAssetBuffedDateThree.text = asset.buffed_date_three.toString();
    tfAssetBuffedDateFour.text = asset.buffed_date_four.toString();
    tfAssetBuffedDateFive.text = asset.buffed_date_five.toString();
    tfAssetBuffedDateSix.text = asset.buffed_date_six.toString();
    tfAssetResoNum.text = asset.reso_num.toString();

    context.read<ResoNumAssetListCubit>().loadAssets(widget.user.hotel);

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          title: const Text("Büfe Ölçüm"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<ResoNumAssetListCubit, List<ResoNumAsset>>(
                  builder: (context, assetList) {
                    if (assetList.isEmpty) {
                      return const Center(child: Text("Reso numarası bulunmamakta."));
                    }
                    else if (widget.asset.reso_num == "") {
                      return DropdownButtonFormField<String>(
                        hint: const Text("Reso Numarası Seçiniz"),
                        value: selectedResoid,
                        items: assetList.map((resoAsset) {
                          return DropdownMenuItem<String>(
                            value: resoAsset.id,
                            child: Text(resoAsset.reso_num_name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedResoid = value;
                            tfAssetResoNum.text = assetList.firstWhere((asset) => asset.id == value).reso_num_name;
                          });
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      );}
                    return Center(child: Text("RESO NUMARASI: " + widget.asset.reso_num, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),));
                  },
                ),

                const SizedBox(height: 16),
                _buildFirstMeasurementWidget(),
                const SizedBox(height: 16),
                if(widget.asset.buffed_temp_one != 333.0)
                  _buildSecondMeasurementWidget(), // Yeni ölçüm widget'ı
                const SizedBox(height: 16),
                if (widget.asset.buffed_temp_two != 333)
                  _buildThirdMeasurementWidget(),
                const SizedBox(height: 16),
                if (widget.asset.buffed_temp_three != 333)
                  _buildFourthMeasurementWidget(),
                const SizedBox(height: 16),
                if (widget.asset.buffed_temp_four != 333)
                  _buildFifthMeasurementWidget(),
                const SizedBox(height: 16),
                if (widget.asset.buffed_temp_five != 333)
                  _buildSixthMeasurementWidget(),
                const SizedBox(height: 16),

                const SizedBox(height: 16),

                _buildSubmitButtons(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,),
      ),);
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
            Text("1.Büfe Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempOne,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 1;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempOne.text = state["temperature"]!;
                          });
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 1;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempOne.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateOne,
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
                        tfAssetBuffedDateOne.text = selectedDateTime.toString();
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
            Text("2.Büfe Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isSecondMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSecondMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempTwo,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 2;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempTwo.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 2;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempTwo.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateTwo,
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
                        tfAssetBuffedDateTwo.text = selectedDateTime.toString();
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
            Text("3.Büfe Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isThirdMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isThirdMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempThree,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 3;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempThree.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 3;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempThree.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateThree,
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
                        tfAssetBuffedDateThree.text = selectedDateTime.toString();
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
            Text("4.Büfe Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isFourthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFourthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempFour,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 4;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempFour.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat,color: Colors.red),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 4;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempFour.text = state["infrared"]!;
                          });
                        }          });
                    },
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedDateFour,
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
                        tfAssetBuffedDateFour.text = selectedDateTime.toString();
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
          !isFifthMeasurementExpanded; // Durumu değiştir
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
            Text("5.Büfe Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isFifthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isFifthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempFive,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 5;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempFive.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 5;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempFive.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateFive,
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
                        tfAssetBuffedDateFive.text = selectedDateTime.toString();
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
          !isSixthMeasurementExpanded; // Durumu değiştir
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
            Text("6.Büfe Ölçüm Değeri",
                style: TextStyle(
                  fontSize: isSixthMeasurementExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isSixthMeasurementExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetBuffedTempSix,
                      decoration: const InputDecoration(
                        labelText: 'Sıcaklık',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 6;
                        context.read<BluetoothCubit>().readTemperatureData();
                        // Normal sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempSix.text = state["temperature"]!;
                          });
                        }                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.thermostat),
                    onPressed: () {
                      setState(() {
                        buffedPlace = 6;
                        context.read<BluetoothCubit>().readInfraredTemperatureData();
                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetBuffedTempSix.text = state["infrared"]!;
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
                      controller: tfAssetBuffedDateSix,
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
                        tfAssetBuffedDateSix.text = selectedDateTime.toString();
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
            tfAssetPresentation.text = "Buffed";
            double parsedBuffedTemperatureOne = double.tryParse(tfAssetBuffedTempOne.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureTwo = double.tryParse(tfAssetBuffedTempTwo.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureThree = double.tryParse(tfAssetBuffedTempThree.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureFour = double.tryParse(tfAssetBuffedTempFour.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureFive = double.tryParse(tfAssetBuffedTempFive.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureSix = double.tryParse(tfAssetBuffedTempSix.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;

            context.read<HotProcessInfoCubit>().hotProcessUpdate(
                widget.asset.id, widget.asset.asset_name, widget.user.username,
                widget.asset.quantity,
                widget.asset.first_temperature,
                widget.asset.banket_temperature_one,
                widget.asset.banket_temperature_two,
                widget.asset.banket_temperature_three,
                widget.asset.banket_temperature_four,
                widget.asset.banket_date_one, widget.asset.banket_date_two,
                widget.asset.banket_date_three,
                widget.asset.banket_date_four,
                widget.asset.sample,
                tfAssetPresentation.text,
                widget.asset.submit_date,
                widget.asset.process_times, widget.asset.hotel,
                parsedBuffedTemperatureOne, parsedBuffedTemperatureTwo,
                parsedBuffedTemperatureThree, parsedBuffedTemperatureFour,
                parsedBuffedTemperatureFive, parsedBuffedTemperatureSix
                , tfAssetBuffedDateOne.text, tfAssetBuffedDateTwo.text, tfAssetBuffedDateThree.text,
                tfAssetBuffedDateFour.text, tfAssetBuffedDateFive.text, tfAssetBuffedDateSix.text,
                widget.asset.cooling_start_temp, widget.asset.cooling_end_temp, widget.asset.cooling_date,
                widget.user.section_id, tfAssetResoNum.text, widget.asset.first_buffed_status,
                widget.asset.banket, widget.asset.asset_result,
                widget.asset.cooling_reheat_temp,widget.asset.cooling_reheat_date,widget.asset.cooling_end_date);
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
        ElevatedButton(
          onPressed: () {
            tfAssetPresentation.text = "End of Buffed";
            double parsedBuffedTemperatureOne = double.tryParse(tfAssetBuffedTempOne.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureTwo = double.tryParse(tfAssetBuffedTempTwo.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureThree = double.tryParse(tfAssetBuffedTempThree.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureFour = double.tryParse(tfAssetBuffedTempFour.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureFive = double.tryParse(tfAssetBuffedTempFive.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
            double parsedBuffedTemperatureSix = double.tryParse(tfAssetBuffedTempSix.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;

            context.read<HotProcessInfoCubit>().hotProcessUpdate(
                widget.asset.id, widget.asset.asset_name, widget.user.username,
                widget.asset.quantity,
                widget.asset.first_temperature,
                widget.asset.banket_temperature_one,
                widget.asset.banket_temperature_two,
                widget.asset.banket_temperature_three,
                widget.asset.banket_temperature_four,
                widget.asset.banket_date_one, widget.asset.banket_date_two,
                widget.asset.banket_date_three,
                widget.asset.banket_date_four,
                widget.asset.sample,
                tfAssetPresentation.text,
                widget.asset.submit_date,
                widget.asset.process_times, widget.asset.hotel,
                parsedBuffedTemperatureOne, parsedBuffedTemperatureTwo,
                parsedBuffedTemperatureThree, parsedBuffedTemperatureFour,
                parsedBuffedTemperatureFive, parsedBuffedTemperatureSix
                , tfAssetBuffedDateOne.text, tfAssetBuffedDateTwo.text, tfAssetBuffedDateThree.text,
                tfAssetBuffedDateFour.text, tfAssetBuffedDateFive.text, tfAssetBuffedDateSix.text,
                widget.asset.cooling_start_temp, widget.asset.cooling_end_temp, widget.asset.cooling_date,
                widget.user.section_id, tfAssetResoNum.text, widget.asset.first_buffed_status,
                widget.asset.banket, widget.asset.asset_result,
                widget.asset.cooling_reheat_temp,widget.asset.cooling_reheat_date,widget.asset.cooling_end_date);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HotProcessListUI(
                    user: widget.user, userRole: widget.userRole),
              ),
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text("Büfe Sonu"),
        ),

      ],
    );
  }
}