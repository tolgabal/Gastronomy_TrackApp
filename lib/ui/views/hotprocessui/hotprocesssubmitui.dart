import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/banketasset.dart';
import 'package:gastrobluecheckapp/data/entity/hotpresentationasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/cubit/banketlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocesssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/hotprocessui/hotprocesslistui.dart';
import '../../../color.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/temperature_bloc.dart';
import '../homepage.dart';

class HotProcessSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;
  const HotProcessSubmitUI({required this.user, required this.userRole, super.key});

  @override
  State<HotProcessSubmitUI> createState() => _HotProcessSubmitUIState();
}

class _HotProcessSubmitUIState extends State<HotProcessSubmitUI> {
  final TextEditingController tfAssetName = TextEditingController();
  final TextEditingController tfSectionName = TextEditingController();
  final TextEditingController tfQuantity = TextEditingController();
  final TextEditingController tfTemperature = TextEditingController();
  final TextEditingController tfSample = TextEditingController();
  final TextEditingController tfBanket = TextEditingController();
  final TextEditingController tfPresentation = TextEditingController();
  final TextEditingController tfBuffedDate = TextEditingController();
  final TextEditingController tfBuffedTemp = TextEditingController();
  final TextEditingController tfResoNum = TextEditingController();



  DateTime now = DateTime.now();
  String? selectedAssetid;
  String? selectedSectionid;
  String? selectedBanketid;
  String? selectedResoNumid;
  DateTime? selectedDateTime;
  DateTime? reelDateTime;



  bool isBanketChecked = false;

  List<String> options = ["Banket", "Büfe/Sunum", "Soğutma ve Tekrar Isıtma"];
  String? selectedOption;

  bool showTime = false;
  String? timeString;
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
    super.initState();
    context.read<HotPreAssetListCubit>().loadAssets(widget.user.hotel);
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
    context.read<BanketListCubit>().banketLoadAsset(widget.user.hotel);
    reelDateTime = DateTime.now();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HotProcessListUI(user: widget.user, userRole: widget.userRole),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          title: const Text("Sıcak Sunum"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<HotPreAssetListCubit, List<HotPresentationAsset>>(
            builder: (context, assetList) {
              if (assetList.isEmpty) {
                return const Center(child: Text("Ürün bulunmamaktadır."));
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
                    selectedAssetid = assetList
                        .firstWhere((asset) => asset.asset_name == value)
                        .id;
                    tfAssetName.text = value!;
                  });
                },
                selectedItem: assetList
                    .firstWhere((asset) => asset.id == selectedAssetid, orElse: () => assetList.first)
                    .asset_name,
                popupProps: PopupProps.menu(
                  showSearchBox: true, // Arama kutusu etkinleştirildi
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
                  controller: tfQuantity,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Ürün Miktarı",
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),



                BlocBuilder<BanketListCubit, List<BanketAsset>>(
                  builder: (context, banketList) {
                    if (banketList.isEmpty) {
                      return const Center(child: Text("No banket available"));
                    }

                    return DropdownButtonFormField<String>(
                      hint: const Text("Banket Seçiniz"),
                      value: selectedBanketid,
                      items: banketList.map((banketAsset) {
                        return DropdownMenuItem<String>(
                          value: banketAsset.id,
                          child: Text(banketAsset.banket_name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBanketid = value;
                          tfBanket.text = banketList.firstWhere((banket) => banket.id == value).banket_name;
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

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDateTime = DateTime.now();
                          DateTime now = DateTime.now();
                          timeString = "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}"; // Güncel tarihi ve saati al
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: tfTemperature,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Merkez Sıcaklık",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),const SizedBox(width:10),
                    GestureDetector(
                      onTap: () {
                        context.read<BluetoothCubit>().readTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["temperature"] != "Sıcaklık Bekleniyor...") {
                          setState(() {
                            tfTemperature.text = state["temperature"]!;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bigWidgetColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.thermostat),
                      ),
                    ),
                    const SizedBox(width:10),
                    GestureDetector(
                      onTap: () {
                        context.read<BluetoothCubit>().readInfraredTemperatureData();

                        // Infrared sıcaklık verisi geldiğinde güncelleniyor
                        final state = context.read<BluetoothCubit>().state;
                        if (state["infrared"] != "Infrared Bekleniyor...") {
                          setState(() {
                            tfTemperature.text = state["infrared"]!;
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
                  ],
                ),
                const SizedBox(height: 16),
                // Checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isBanketChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isBanketChecked = value ?? false;
                        });
                      },
                    ),
                    const Text("Şahit Numune Alındı mı?"),
                  ],
                ),
                const SizedBox(height: 16),


                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: smallWidgetColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Text(
                    "Pişirmeye aktarmak için ürün merkez sıcaklığı 75 derece olmalı",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Option Dropdown
                DropdownButtonFormField<String>(
                  hint: const Text("Aktarım Yeri"),
                  value: selectedOption,
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                      if(selectedOption == 'Büfe/Sunum'){
                        tfPresentation.text = 'Buffed';
                      }else if( selectedOption == 'Soğutma ve Tekrar Isıtma'){
                        tfPresentation.text = 'Cooling and Reheat';
                      }else if( selectedOption == 'Banket') {
                        tfPresentation.text = 'Banket';
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () {
                    if(tfAssetName.text == null || tfAssetName.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen Ürün Seçiniz!")),
                      );
                      return;
                    }
                    if(isBanketChecked){
                      tfSample.text = "Evet";
                    }else{
                      tfSample.text = "Hayır";
                    }
                    double emptyTemp = 333.0;
                    String emptyDate = "---";
                    tfBuffedTemp.text = tfTemperature.text;

                    try {

                      double parsedTemperature = double.tryParse(tfTemperature.text.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
                      context.read<HotProcessSubmitCubit>().hotProcessSubmit(
                          tfAssetName.text,
                          widget.user.username,
                          int.parse(tfQuantity.text),
                          parsedTemperature,
                          emptyTemp,//banket_temperature_one,
                          emptyTemp,//banket_temperature_two,
                          emptyTemp,//banket_temperature_three,
                          emptyTemp,//banket_temperature_four,
                          emptyDate,//banket_date_one,
                          emptyDate,//banket_date_two,
                          emptyDate,//banket_date_three,
                          emptyDate,//banket_date_four,
                          tfSample.text,
                          tfPresentation.text,
                          reelDateTime.toString(),
                          1,//process_times,
                          widget.user.hotel,
                          emptyTemp,//buffed_temp_one,
                          emptyTemp,//buffed_temp_two,
                          emptyTemp,//buffed_temp_three,
                          emptyTemp,//buffed_temp_four,
                          emptyTemp,//buffed_temp_five,
                          emptyTemp,//buffed_temp_six,
                          emptyDate,//buffed_date_one,
                          emptyDate,//buffed_date_two,
                          emptyDate,//buffed_date_three
                          emptyDate,//buffed_date_four,
                          emptyDate,//buffed_date_five,
                          emptyDate,//buffed_date_six,
                          emptyTemp,//cooling_start_temp,
                          emptyTemp,//cooling_end_temp,
                          "",//cooling_date,
                          widget.user.section_id,//section_name,
                          "",//reso_num,
                          "",//first_buffed_status,
                          tfBanket.text,
                      "",
                        emptyTemp, //cooling_reheat_temp,
                        emptyDate,//cooling_reheat_date,
                        emptyDate,//cooling_end_date,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HotProcessListUI(user: widget.user, userRole: widget.userRole)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lütfen tüm alanları doğru bir şekilde doldurun."))
                      );
                    }
                  },
                  child: const Text("Kaydet"),
                )

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
}
