import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawingproclistui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/soakingasset.dart';
import '../../../data/entity/user.dart';
import '../../cubit/soakingassetlist_cubit.dart';
import '../../cubit/thawingprocsubmit_cubit.dart';
import '../../middleware/temperature_bloc.dart';

class ThawingProcSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;
  const ThawingProcSubmitUI(
      {required this.user, required this.userRole, super.key});

  @override
  State<ThawingProcSubmitUI> createState() => _ThawingProcSubmitUIState();
}

class _ThawingProcSubmitUIState extends State<ThawingProcSubmitUI> {
  final TextEditingController tfAssetName = TextEditingController();
  final TextEditingController tfAssetQuantity = TextEditingController();
  final TextEditingController tfAssetPartyNo = TextEditingController();
  final TextEditingController tfAssetExpDate = TextEditingController();
  final TextEditingController tfAssetTempOne = TextEditingController();
  final TextEditingController tfAssetTimeOne = TextEditingController();
  final TextEditingController tfAssetResult = TextEditingController();
  final TextEditingController tfAssetEnvTemp = TextEditingController();

  String? selectedAssetId;
  DateTime? selectedDateTime;
  String? timeString;
  bool showTime = false;
  DateTime? reelDateTime;

  List<DropdownMenuItem<String>> _getDropdownItems() {
    double? temperature = double.tryParse(tfAssetTempOne.text);

    if (temperature != null && temperature < 0) {
      return const [
        DropdownMenuItem(value: 'çözündürme', child: Text('Çözündürme')),
        DropdownMenuItem(value: 'suda çözündürme', child: Text('Suda Çözündürme')),
      ];
    } else if (temperature != null && temperature > 0) {
      return const [
        DropdownMenuItem(value: 'tamamlanan', child: Text('Tamamlanan')),
      ];
    } else {
      return const [];
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<SoakingAssetListCubit>().soakingLoadAsset(widget.user.hotel);
    reelDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ThawingProcListUI(user: widget.user, userRole: widget.userRole),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Çözündürme Kayıt"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<SoakingAssetListCubit, List<SoakingAsset>>(
            builder: (context, assetList) {
              if (assetList.isEmpty) {
                return const Center(child: Text("Ürün bulunmamakta"));
              }

              return DropdownSearch<String>(
                items: assetList.map((soakAsset) => soakAsset.asset_name).toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Ürün Seçiniz",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedAssetId = assetList
                        .firstWhere((asset) => asset.asset_name == value)
                        .id;
                    tfAssetName.text = value!;
                  });
                },
                selectedItem: assetList
                    .firstWhere((asset) => asset.id == selectedAssetId, orElse: () => assetList.first)
                    .asset_name,
                popupProps: PopupProps.menu(
                  showSearchBox: true, // Arama kutusunu etkinleştirir
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: 'Ara...',
                    ),
                  ),
                  itemBuilder: (context, item, isSelected) {
                    return ListTile(
                      title: Text(item),
                    );
                  },
                ),
                filterFn: (item, filter) {
                  return item.toLowerCase().contains(filter.toLowerCase());
                },
              );
            },
            ),
                const SizedBox(height: 10),
                TextField(
                  controller: tfAssetQuantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Ürün Miktarı",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: tfAssetPartyNo,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Parti Numarası",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: tfAssetExpDate,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Son Kullanma Tarihi",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDateTime = DateTime.now();
                          DateTime now = DateTime.now();
                          timeString =
                          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
                          tfAssetTimeOne.text = reelDateTime.toString();
                          showTime = true;
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
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: tfAssetTempOne,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {}); // Temp değişikliğinde dropdown güncellenir
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Ürün Sıcaklığı",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        context.read<BluetoothCubit>().readTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfAssetTempOne.text = state["temperature"]!;
                            double.tryParse(tfAssetTempOne.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bigWidgetColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.thermostat, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<BluetoothCubit>()
                            .readInfraredTemperatureData();
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfAssetTempOne.text = state["infrared"]!;
                            double.tryParse(tfAssetTempOne.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

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
                  ],
                ),
                const SizedBox(height: 5),

                TextField(
                  controller: tfAssetEnvTemp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Çözündürme Dolap Sıcaklığı",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: tfAssetResult.text.isNotEmpty ? tfAssetResult.text : null,
                  items: _getDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      tfAssetResult.text = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Yapılacak İşlem",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(tfAssetName.text == null || tfAssetName.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen Ürün Seçiniz!")),
                      );
                      return;
                    }
                    double emptyTemp = -333.0;
                    String emptyDate = "---";
                    double parsedTempOne = double.tryParse(tfAssetTempOne.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;
                    double parsedTempEnv = double.tryParse(tfAssetEnvTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

                    context.read<ThawingProcSubmitCubit>().thawingProcSubmit(
                        widget.user.section_id,//section_name,
                        parsedTempEnv,//asset_env_temp,
                        widget.user.username,//user_name,
                        tfAssetResult.text,//asset_result,
                        tfAssetName.text,//asset_name,
                        tfAssetPartyNo.text,//asset_party_no,
                        tfAssetExpDate.text,//asset_exp_no,
                        int.parse(tfAssetQuantity.text),//asset_quantity,
                        parsedTempOne,//asset_temp_one,
                        tfAssetTimeOne.text,//asset_time_one,
                        emptyTemp,//asset_thawing_temp_one,
                        emptyDate,//asset_thawing_time_one,
                        emptyTemp,//asset_thawing_temp_two,
                        emptyDate,//asset_thawing_time_two,
                        emptyTemp,//asset_thawing_temp_three,
                        emptyDate,//asset_thawing_time_three,
                        emptyTemp,//asset_process_temp,
                        emptyDate,//asset_process_time,
                        emptyDate,//asset_sending_place
                        0,//asset_sending_quantity,
                        emptyDate,//asset_sending_process_type,
                        emptyTemp,//asset_sending_place_temp,
                        int.parse(tfAssetQuantity.text),//kalan,
                        widget.user.hotel);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ThawingProcListUI(
                              user: widget.user, userRole: widget.userRole)),
                    );
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tfAssetExpDate.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }
}
