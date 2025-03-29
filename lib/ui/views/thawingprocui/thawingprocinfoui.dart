import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawingproclistui.dart';

import '../../../color.dart';
import '../../../data/entity/hotpresentationasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/section.dart';
import '../../../data/entity/thawingprocess.dart';
import '../../../data/entity/user.dart';
import '../../cubit/sectionlist_cubit.dart';
import '../../cubit/thawingprocinfo_cubit.dart';
import '../../cubit/thawingprocsubmit_cubit.dart';
import '../../middleware/temperature_bloc.dart';

class ThawingProcInfoUI extends StatefulWidget {
  final ThawingProcess asset;
  final User user;
  final Role userRole;

  const ThawingProcInfoUI({
    required this.asset,
    required this.user,
    required this.userRole,
    super.key,
  });
  @override
  State<ThawingProcInfoUI> createState() => _ThawingProcInfoUIState();
}

class _ThawingProcInfoUIState extends State<ThawingProcInfoUI> {
  var tfAssetProcessTemp = TextEditingController();
  var tfAssetProcessTime = TextEditingController();
  var tfAssetProcTemp = TextEditingController();
  var tfAssetProcTime = TextEditingController();
  var tfPreAssetName = TextEditingController();
  var tfAssetKalanQuant = TextEditingController();

  List<Section> selectedSections = [];
  Map<Section, TextEditingController> sectionWeightMap = {};

  bool isExpanded = false;
  DateTime? selectedDateTime;
  String? timeString;
  String? selectedAssetid;
  int reelKalan = 0;
  bool isSectionsExpanded = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var asset = widget.asset;
    context.read<HotPreAssetListCubit>().loadAssets(widget.user.hotel);
    reelKalan = widget.asset.kalan;
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
    tfAssetKalanQuant.text = asset.kalan.toString();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ThawingProcListUI(
              user: widget.user,
              userRole: widget.userRole,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Asset Info"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildFirstMeasurementWidget(),
                const SizedBox(height: 16),
                TextField(
                  controller: tfAssetProcTemp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Ürün İşleme Ortam Sıcaklığı",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<HotPreAssetListCubit, List<HotPresentationAsset>>(
                  builder: (context, assetList) {
                    if (assetList.isEmpty) {
                      return const Center(child: Text("Ürün bulunmamakta."));
                    }

                    return DropdownButtonFormField<String>(
                      hint: const Text("Nihai ürün seçiniz"),
                      value: selectedAssetid,
                      items: assetList.map((procAsset) {
                        return DropdownMenuItem<String>(
                          value: procAsset.id,
                          child: Text(procAsset.asset_name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAssetid = value;
                          tfPreAssetName.text = assetList.firstWhere((asset) => asset.id == value).asset_name;
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                if (true) ...[
                  TextField(
                    controller: tfAssetKalanQuant,
                    keyboardType: TextInputType.number,
                    enabled: false, // Düzenlenemez hale getirir
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Ürün Miktarı",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSectionsExpanded = !isSectionsExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSectionsExpanded
                          ? bigWidgetColor
                          : smallWidgetColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Sections",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Icon(
                          isSectionsExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                if (isSectionsExpanded) ...[
                  BlocBuilder<SectionListCubit, List<Section>>(
                    builder: (context, sectionList) {
                      if (sectionList.isEmpty) {
                        return const Center(
                            child: Text("No sections available"));
                      }
                      return Column(
                        children: sectionList.map((section) {
                          sectionWeightMap.putIfAbsent(
                              section, () => TextEditingController());

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(section.section_name),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: sectionWeightMap[section],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: "Kg",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                  10), // TextField ile buton arasına boşluk
                              GestureDetector(
                                onTap: () {
                                  String sectionName = section.section_name;
                                  if (sectionWeightMap[section] == null) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Uyarı"),
                                          content: const Text(
                                              "Lütfen miktar giriniz!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Pop-up'ı kapat
                                              },
                                              child: const Text("Tamam"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  int kalan = reelKalan -
                                      int.parse(
                                          sectionWeightMap[section]!.text);
                                  if (kalan >= 0) {
                                    reelKalan = kalan;
                                    tfAssetKalanQuant.text =
                                        reelKalan.toString();
                                    setState(() {
                                      if (widget.asset.asset_thawing_temp_one
                                          .toString() ==
                                          "---") {
                                        double parsedProcTemp = double.tryParse(tfAssetProcessTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
                                        double parsedEnvTemp = double.tryParse(tfAssetProcTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

                                        context
                                            .read<ThawingProcInfoCubit>()

                                            .thawingProcUpdate(widget.asset.id, widget.asset.section_name, widget.asset.asset_env_temp, widget.user.username, widget.asset.asset_result, widget.asset.asset_name, widget.asset.asset_party_no, widget.asset.asset_exp_no, widget.asset.asset_quantity, widget.asset.asset_temp_one, widget.asset.asset_time_one, widget.asset.asset_thawing_temp_one, widget.asset.asset_thawing_time_one, widget.asset.asset_thawing_temp_two, widget.asset.asset_thawing_time_two, widget.asset.asset_thawing_temp_three, widget.asset.asset_thawing_time_three, widget.asset.asset_process_temp, widget.asset.asset_process_time, widget.asset.asset_sending_place, widget.asset.asset_sending_quantity, widget.asset.asset_sending_process_type, widget.asset.asset_sending_place_temp, kalan, widget.user.hotel);
                                        context
                                            .read<ThawingProcSubmitCubit>()
                                            .thawingProcSubmit(widget.asset.section_name, widget.asset.asset_env_temp, widget.asset.user_name, widget.asset.asset_result, widget.asset.asset_name, widget.asset.asset_party_no, widget.asset.asset_exp_no, 0, widget.asset.asset_temp_one, widget.asset.asset_time_one, widget.asset.asset_thawing_temp_one, widget.asset.asset_thawing_time_one, widget.asset.asset_thawing_temp_two, widget.asset.asset_thawing_time_two, widget.asset.asset_thawing_temp_three, widget.asset.asset_thawing_time_three, parsedProcTemp, tfAssetProcessTime.text, sectionName, int.parse(sectionWeightMap[section]!.text), tfPreAssetName.text, parsedEnvTemp, 0, widget.asset.hotel);
                                      } else {
                                        tfAssetKalanQuant.text =
                                            reelKalan.toString();
                                        double parsedProcTemp = double.tryParse(tfAssetProcessTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
                                        double parsedEnvTemp = double.tryParse(tfAssetProcTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

                                        context
                                            .read<ThawingProcInfoCubit>()

                                            .thawingProcUpdate(widget.asset.id, widget.asset.section_name, widget.asset.asset_env_temp, widget.user.username, widget.asset.asset_result, widget.asset.asset_name, widget.asset.asset_party_no, widget.asset.asset_exp_no, widget.asset.asset_quantity, widget.asset.asset_temp_one, widget.asset.asset_time_one, widget.asset.asset_thawing_temp_one, widget.asset.asset_thawing_time_one, widget.asset.asset_thawing_temp_two, widget.asset.asset_thawing_time_two, widget.asset.asset_thawing_temp_three, widget.asset.asset_thawing_time_three, widget.asset.asset_process_temp, widget.asset.asset_process_time, widget.asset.asset_sending_place, widget.asset.asset_sending_quantity, widget.asset.asset_sending_process_type, widget.asset.asset_sending_place_temp, kalan, widget.user.hotel);
                                        context
                                            .read<ThawingProcSubmitCubit>()
                                            .thawingProcSubmit(widget.asset.section_name, widget.asset.asset_env_temp, widget.asset.user_name, widget.asset.asset_result, widget.asset.asset_name, widget.asset.asset_party_no, widget.asset.asset_exp_no, 0, widget.asset.asset_temp_one, widget.asset.asset_time_one, widget.asset.asset_thawing_temp_one, widget.asset.asset_thawing_time_one, widget.asset.asset_thawing_temp_two, widget.asset.asset_thawing_time_two, widget.asset.asset_thawing_temp_three, widget.asset.asset_thawing_time_three, parsedProcTemp, tfAssetProcessTime.text, sectionName, int.parse(sectionWeightMap[section]!.text), tfPreAssetName.text, parsedEnvTemp, 0, widget.asset.hotel);

                                      }
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Uyarı"),
                                          content: const Text(
                                              "Ürün Başarıyla Sevk Edildi!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Pop-up'ı kapat
                                              },
                                              child: const Text("Tamam"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Uyarı"),
                                          content: const Text(
                                              "Yeterli miktarda ürün bulunmamakta!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Pop-up'ı kapat
                                              },
                                              child: const Text("Tamam"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.blue, // Butonun arka plan rengi
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Text("Sevk Et"), // Butonun ikonu
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
                ElevatedButton(onPressed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ThawingProcListUI(
                            user: widget.user, userRole: widget.userRole)),
                  );
                }, child: Text("Geri Dön"))


              ],
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
            Text("Ürün İşleme Ölçümü",
                style: TextStyle(
                  fontSize: isExpanded ? 24 : 18,
                  fontWeight: FontWeight.bold,
                )),
            if (isExpanded) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tfAssetProcessTemp,
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
                            tfAssetProcessTemp.text = state["temperature"]!;
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
                            tfAssetProcessTemp.text = state["infrared"]!;
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
                      controller: tfAssetProcessTime,
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
                        tfAssetProcessTime.text = selectedDateTime.toString();
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

}
