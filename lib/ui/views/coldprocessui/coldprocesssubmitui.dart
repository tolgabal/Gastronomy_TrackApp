import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/coldpresentationasset.dart';
import 'package:gastrobluecheckapp/data/entity/coldroomasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocesssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldroomlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/middleware/bottomnavigationbar.dart';
import 'package:gastrobluecheckapp/ui/views/coldprocessui/coldprocesslistui.dart';
import 'package:gastrobluecheckapp/ui/views/coldroomassetui/coldroomassetlistui.dart';
import 'package:gastrobluecheckapp/ui/views/homepage.dart';
import 'package:intl/intl.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/section.dart';
import '../../../data/entity/user.dart';
import '../../cubit/coldprocesssubmit_cubit.dart';
import '../../middleware/temperature_bloc.dart';

class ColdProcessSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ColdProcessSubmitUI({
    required this.user,
    required this.userRole,
    super.key,
  });

  @override
  State<ColdProcessSubmitUI> createState() => _ColdProcessSubmitUIState();
}

class _ColdProcessSubmitUIState extends State<ColdProcessSubmitUI> {
  final TextEditingController tfAssetName = TextEditingController();
  final TextEditingController tfAssetPreTemp = TextEditingController();
  final TextEditingController tfAssetPreTime = TextEditingController();
  final TextEditingController tfSample = TextEditingController();
  final TextEditingController tfColdRoomName = TextEditingController();
  final TextEditingController tfColdBuffedNo = TextEditingController();
  final TextEditingController tfAssetQuantity = TextEditingController();
  final TextEditingController tfColdPreStartTemp = TextEditingController();
  final TextEditingController tfColdPreStartTime = TextEditingController();
  final TextEditingController tfColdPreEndTime = TextEditingController();
  final TextEditingController tfColdRoomTempOne = TextEditingController();
  final TextEditingController tfColdRoomTimeOne = TextEditingController();
  final TextEditingController tfColdPreEndTemp = TextEditingController();
  final TextEditingController tfFirstBuffedTemp = TextEditingController();
  final TextEditingController tfFirstBuffedTime = TextEditingController();
  final TextEditingController tfSectionName = TextEditingController();

  String? tfAssetStatus;
  String? selectedAssetId;
  String? selectedcoldRoomid;
  int _selectedIndex = 0;
  bool isSampleChecked = false;
  bool showTime = false;
  String? timeString;
  DateTime? selectedDateTime;
  String? selectedSectionid;
  DateTime? reelDateTime;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            Homepage(user: widget.user, userRole: widget.userRole),
      ),
    );
  }

  List<String> getAssetStatusOptions() {
    double assetTemp = double.tryParse(tfAssetPreTemp.text) ?? 0;
    return assetTemp > 10 ? ['Soğutma'] : ['Büfe/Sunum', 'Soğuk Oda'];
  }

  @override
  void initState() {
    super.initState();
    context.read<ColdPreAssetListCubit>().coldLoadAsset(widget.user.hotel);
    context.read<ColdRoomListCubit>().coldRoomLoadAsset(widget.user.hotel);
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
                ColdProcessListUI(user: widget.user, userRole: widget.userRole),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Soğuk Sunum Prosesi"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
              BlocBuilder<ColdPreAssetListCubit, List<ColdPresentationAsset>>(
            builder: (context, assetList) {
              if (assetList.isEmpty) {
                return const Center(child: Text("Ürün bulunmamaktadır"));
              }

              return DropdownSearch<String>(
                items: assetList.map((procAsset) => procAsset.asset_name).toList(),
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
                  showSearchBox: true,  // Arama kutusu gösteriliyor
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
                _buildTextField(tfAssetQuantity, "Ürün Miktarı",
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTemperatureAndTimeRow(),
                const SizedBox(height: 10),
                _buildAssetStatusDropdown(),
                const SizedBox(height: 10),
                BlocBuilder<ColdRoomListCubit, List<ColdRoomAsset>>(
                  builder: (context, coldRoomList) {
                    if (coldRoomList.isEmpty) {
                      return const Center(
                          child: Text("Soğuk oda bulunmamakta."));
                    }

                    return DropdownButtonFormField<String>(
                      hint: const Text("Soğuk Oda Seçiniz"),
                      value: selectedcoldRoomid,
                      items: coldRoomList.map((coldRoomAsset) {
                        return DropdownMenuItem<String>(
                          value: coldRoomAsset.id,
                          child: Text(coldRoomAsset.cold_room_name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedcoldRoomid = value;
                          tfColdRoomName.text = coldRoomList
                              .firstWhere((asset) => asset.id == value)
                              .cold_room_name;
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
                _buildSampleCheckbox(),
                const SizedBox(height: 10),
                Container(
                  padding:
                      EdgeInsets.all(16.0), // Kenarlardan boşluk ekleyebilirsin
                  decoration: BoxDecoration(
                    color: smallWidgetColor, // Arka plan rengi ayarlayabilirsin
                    borderRadius: BorderRadius.circular(
                        10.0), // Köşeleri yuvarlatabilirsin
                    border: Border.all(
                      color: Colors.black, // Çerçeve rengi
                      width: 1.0, // Çerçeve kalınlığı
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Pişirmede ürün merkez sıcaklığı minimum 75 derece olmalıdır.",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(
                          height:
                              8.0), // İki metin arasına boşluk ekleyebilirsin
                      Text(
                          "Hazırlamada ürün merkez sıcaklığı 10 dereceden fazla ise ürünü blast chiller'a gönderiniz.",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _selectedIndex, onTap: _onItemTapped),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTemperatureAndTimeRow() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDateTime = DateTime.now();
              DateTime now = DateTime.now();
              timeString =
                  "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}";
              showTime = true;
              tfAssetPreTime.text = reelDateTime.toString();
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
          child: _buildTextField(tfAssetPreTemp, "Sıcaklık",
              keyboardType: TextInputType.number),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              context.read<BluetoothCubit>().readTemperatureData();
              // Normal sıcaklık verisi geldiğinde güncelleniyor
              final state = context.read<BluetoothCubit>().state;
              if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                setState(() {
                  tfAssetPreTemp.text = state["temperature"]!;
                });
              }
            });
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
            setState(() {
              context.read<BluetoothCubit>().readInfraredTemperatureData();
              final state = context.read<BluetoothCubit>().state;
              if (state["infrared"] != "Infrared Bekleniyor...") {
                setState(() {
                  tfAssetPreTemp.text = state["infrared"]!;
                });
              }
            });
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
    );
  }

  Widget _buildAssetStatusDropdown() {
    return DropdownButtonFormField<String>(
      hint: const Text("Aktarım Yerini Seçiniz"),
      value: tfAssetStatus,
      items: getAssetStatusOptions().map((status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          tfAssetStatus = value;
        });
      },
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSampleCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isSampleChecked,
          onChanged: (bool? value) {
            setState(() {
              isSampleChecked = value ?? false;
              tfSample.text = isSampleChecked ? 'Checked' : 'Unchecked';
            });
          },
        ),
        const Text('Şahit numune alındı mı?'),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if(tfAssetName.text == null || tfAssetName.text == ""){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Lütfen Ürün Seçiniz!")),
          );
          return;
        }

        int? assetQuantity;

        String assetQuantityText = tfAssetQuantity.text.trim();
        if (assetQuantityText.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ürün Miktarı Boş Bırakılamaz!")),
          );
          return;
        }

        try {
          assetQuantity = int.parse(assetQuantityText);
          if (assetQuantity < 0) {
            throw FormatException("Asset Quantity cannot be negative.");
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hatalı Miktar Girişi: ${e.toString()}")),
          );
          return;
        }
        int sampleStatus = isSampleChecked ? 1 : 0;
        double emptyTemp = -1000.0;
        String emptyDate = '';
        assetQuantity = int.parse(assetQuantityText);
        tfColdPreStartTemp.text = tfAssetPreTemp.text;
        tfColdPreStartTime.text = selectedDateTime.toString();
        double parsedTemperature = double.tryParse(tfAssetPreTemp.text.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0;

        context.read<ColdProcessSubmitCubit>().coldProcSubmit(
              tfAssetName.text,
              widget.user.username,
              sampleStatus,
              int.parse(tfAssetQuantity.text),
              tfColdRoomName.text,
              emptyDate, //cold_buffed_no,
              parsedTemperature, //asset_presentation_temp,
              reelDateTime.toString(), //asset_presentation_time,
              emptyTemp, //cold_pre_start_temp,
              emptyDate, //cold_pre_start_time,
              emptyDate, //cold_pre_end_time,
              emptyTemp, //cold_pre_end_temp,
              emptyTemp, //cold_room_temp_one,
              emptyDate, //cold_room_time_one,
              emptyTemp, //cold_room_temp_two,
              emptyDate, //cold_room_time_two,
              emptyTemp, //cold_buffed_temp_one,
              emptyDate, //cold_buffed_time_one,
              emptyTemp, //cold_buffed_temp_two,
              emptyDate, //cold_buffed_time_two,
              emptyTemp, //cold_buffed_temp_three,
              emptyDate, //cold_buffed_time_three,
              emptyDate, //first_buffed_status,
              emptyTemp, //first_buffed_temp,
              emptyDate, //first_buffed_time,
              emptyTemp, //cold_room_temp_three,
              emptyDate, //cold_room_time_three,
              emptyTemp, //cold_buffed_temp_four,
              emptyDate, //cold_buffed_time_four,
              emptyTemp, //cold_buffed_temp_five,
              emptyDate, //cold_buffed_time_five,
              emptyTemp, //cold_buffed_temp_six,
              emptyDate, //cold_buffed_time_six,
              tfAssetStatus!, //asset_status,
              widget.user.hotel,
              widget.user.section_id,
              emptyTemp, //cold_room_temp_four,
              emptyDate, //cold_room_time_four
            );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ColdProcessListUI(
                  user: widget.user, userRole: widget.userRole)),
        );
      },
      child: const Text("Kaydet"),
    );
  }
}
