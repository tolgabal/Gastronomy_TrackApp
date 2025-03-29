import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/disinfectionasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/section.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinfectionassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocesssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/middleware/bottomnavigationbar.dart';
import 'package:intl/intl.dart';

import '../../middleware/notificationwidget.dart';
import 'disinprocesslistui.dart';

class DisinProcessSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;
  const DisinProcessSubmitUI({required this.user, required this.userRole, super.key});

  @override
  State<DisinProcessSubmitUI> createState() => _DisinProcessSubmitUIState();
}

class _DisinProcessSubmitUIState extends State<DisinProcessSubmitUI> {
  final TextEditingController tfDisinprocName = TextEditingController();
  final TextEditingController tfDisinPiece = TextEditingController();
  final TextEditingController tfPieceType = TextEditingController();
  final TextEditingController tfProcType = TextEditingController();
  final TextEditingController tfProcTime = TextEditingController();
  final TextEditingController tfSection = TextEditingController();

  DateTime now = DateTime.now();
  String? selectedAssetid;
  String? selectedSectionid;
  int _selectedIndex = 0;
  double _processTime = 10;
  String? formattedDateTime;
  final PageController _pageController = PageController();
  String? timeString;

  final NotificationWidget _notificationWidget = const NotificationWidget(notificationText: "");

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    formattedDateTime = now.toString();

    context.read<DisinfectionAssetListCubit>().disinLoadAssets(widget.user.hotel);
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DisinProcessListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dezenfeksiyon Prosesi"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<DisinfectionAssetListCubit, List<DisinfectionAsset>>(
            builder: (context, procList) {
              if (procList.isEmpty) {
                return const Center(child: Text("Ürün bulunmamaktadır"));
              }

              return DropdownSearch<String>(
                items: procList.map((procAsset) => procAsset.asset_name).toList(),
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Ürün Seçiniz",
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedAssetid = procList
                        .firstWhere((asset) => asset.asset_name == value)
                        .id;
                    tfDisinprocName.text = value!;
                  });
                },
                selectedItem: procList
                    .firstWhere((asset) => asset.id == selectedAssetid, orElse: () => procList.first)
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

                // Quantity ve Process Type Dropdown (yan yana)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: tfDisinPiece,
                        decoration: const InputDecoration(
                          labelText: "Miktar",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        hint: const Text("Birim"),
                        value: tfPieceType.text.isNotEmpty ? tfPieceType.text : null,
                        items: ['Kg', 'Bağ'].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            tfPieceType.text = value ?? '';
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Process Time Slider (10 - 15 dakika arası)
                Center(
                  child: Text(
                    "İşlem Süresi",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text("10"), // Sol kenara 10 eklenir
                    Expanded(
                      child: Slider(
                        value: _processTime,
                        min: 10,
                        max: 15,
                        divisions: 5,
                        label: "${_processTime.toInt()} dakika",
                        onChanged: (newValue) {
                          setState(() {
                            _processTime = newValue;
                          });
                        },
                      ),
                    ),
                    const Text("15"), // Sağ kenara 15 eklenir
                  ],
                ),
                Center(
                  child: Text(
                    "${_processTime.toInt()} dakika",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Araya boşluk ekliyoruz

// Process Type Butonları
                Center(
                  child: Text(
                    "Dezenfeksiyon Türü",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 'Ozon' butonu
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tfProcType.text = 'Ozon';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tfProcType.text == 'Ozon' ? smallWidgetColor : Colors.white,
                        ),
                        child: const Text("Ozon"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // 'Sirke' butonu
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            tfProcType.text = 'Sirke';
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tfProcType.text == 'Sirke' ? smallWidgetColor : Colors.white,
                        ),
                        child: const Text("Sirke"),

                    ),
                    )],
                ),

                const SizedBox(height: 20),

                BlocBuilder<SectionListCubit, List<Section>>(
                  builder: (context, sectionList) {
                    if (sectionList.isEmpty) {
                      return const Center(child: Text("Sevk yeri bulunmamaktadır"));
                    }

                    return DropdownButtonFormField<String>(
                      hint: const Text("Sevk Yeri"),
                      value: selectedSectionid,
                      items: sectionList.map((section) {
                        return DropdownMenuItem<String>(
                          value: section.id,
                          child: Text(section.section_name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSectionid = value;
                          tfSection.text = sectionList.firstWhere((section) => section.id == value).section_name;
                          }
                        );
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if(tfDisinprocName.text == null || tfDisinprocName.text == ""){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lütfen Ürün Seçiniz!")),
                      );
                      return;
                    }
                    context.read<DisinProcessAssetSubmitCubit>().disinProcessSubmit(
                      tfDisinprocName.text,
                      int.parse(tfDisinPiece.text),
                      _processTime.toInt(),
                      tfProcType.text,
                      selectedSectionid!,
                      tfPieceType.text,
                      formattedDateTime!,
                      widget.user.username,
                        widget.user.hotel
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DisinProcessListUI(user: widget.user, userRole: widget.userRole)),
                    );
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
      ),
    );
  }
}
