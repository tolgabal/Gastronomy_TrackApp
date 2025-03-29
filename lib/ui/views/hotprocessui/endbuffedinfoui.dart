import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocessinfo_cubit.dart';
import '../../../data/entity/hotprocessasset.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../../data/entity/section.dart';
import '../../cubit/sectionlist_cubit.dart';
import 'hotprocesslistui.dart';

class EndBuffedInfoUI extends StatefulWidget {
  final HotProcessAsset asset;
  final User user;
  final Role userRole;

  const EndBuffedInfoUI({
    required this.asset,
    required this.user,
    required this.userRole,
    super.key,
  });

  @override
  State<EndBuffedInfoUI> createState() => _EndBuffedInfoUIState();
}

class _EndBuffedInfoUIState extends State<EndBuffedInfoUI> {
  var tfAssetFirstBuffedStatus = TextEditingController();
  var tfSection = TextEditingController();
  var tfAssetStatus = TextEditingController();
  var tfAssetPresentation = TextEditingController();
  var tfAssetResult = TextEditingController();
  var tfProcessTimes = TextEditingController();

  String? selectedOption;
  String? selectedSectionid;

  @override
  void initState() {
    super.initState();
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
    tfAssetPresentation.text = widget.asset.presentation;
    selectedSectionid =  widget.asset.section_name.toString();
    tfAssetFirstBuffedStatus.text = widget.asset.first_buffed_status;
    tfAssetResult.text = widget.asset.asset_result;
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
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Büfe Sonu"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if(widget.asset.first_buffed_status != "Soğutma ve Tekrar Isıtma")
              // Option Seçimi
                DropdownButtonFormField<String>(
                  hint: const Text("Seçim Yapın"),
                  value: selectedOption,
                  items: ['Ürün Bitti', 'İmha', 'Soğutma ve Tekrar Isıtma', 'Section'].map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                      if (selectedOption == 'Soğutma ve Tekrar Isıtma') {
                        setState(() {
                          tfAssetPresentation.text = "Cooling and Reheat";
                          tfAssetFirstBuffedStatus.text = selectedOption!;

                        });
                      }else if(selectedOption == "Ürün Bitti"|| selectedOption == "İmha"){
                        setState(() {
                          tfAssetResult.text = selectedOption!;
                          tfAssetPresentation.text  = selectedOption!;
                        });
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              if(widget.asset.first_buffed_status == "Soğutma ve Tekrar Isıtma")
                DropdownButtonFormField<String>(
                  hint: const Text("Seçim Yapın"),
                  value: selectedOption,
                  items: ['Ürün Bitti', 'İmha'].map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                      if (selectedOption == 'Soğutma ve Tekrar Isıtma') {
                        setState(() {
                          tfAssetPresentation.text = "Cooling and Reheat";
                          tfAssetFirstBuffedStatus.text = selectedOption!;

                        });
                      }else if(selectedOption == "Ürün Bitti"|| selectedOption == "İmha"){
                        setState(() {
                          tfAssetResult.text = selectedOption!;
                          tfAssetPresentation.text  = selectedOption!;
                        });
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 20),
              TextField(
                controller: tfProcessTimes,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Kalan Küvet Miktarı",
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              if (selectedOption == 'Section')
                BlocBuilder<SectionListCubit, List<Section>>(
                  builder: (context, sectionList) {
                    if (sectionList.isEmpty) {
                      return const Center(child: Text("Section bulunmamakta"));
                    }

                    return DropdownButtonFormField<String>(
                      hint: const Text("Section Seçiniz"),
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
                          tfSection.text = sectionList
                              .firstWhere((section) => section.id == value)
                              .section_name;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),

              // Güncelle butonu
              ElevatedButton(
                onPressed: () {
                  context.read<HotProcessInfoCubit>().hotProcessUpdate(
                      widget.asset.id,
                      widget.asset.asset_name,
                      widget.asset.user_name,
                      widget.asset.quantity,
                      widget.asset.first_temperature,
                      widget.asset.banket_temperature_one,
                      widget.asset.banket_temperature_two,
                      widget.asset.banket_temperature_three,
                      widget.asset.banket_temperature_four,
                      widget.asset.banket_date_one,
                      widget.asset.banket_date_two,
                      widget.asset.banket_date_three,
                      widget.asset.banket_date_four,
                      widget.asset.sample,
                      tfAssetPresentation.text,
                      widget.asset.submit_date,
                      int.parse(tfProcessTimes.text),
                      widget.asset.hotel,
                      widget.asset.buffed_temp_one,
                      widget.asset.buffed_temp_two,
                      widget.asset.buffed_temp_three,
                      widget.asset.buffed_temp_four,
                      widget.asset.buffed_temp_five,
                      widget.asset.buffed_temp_six,
                      widget.asset.buffed_date_one,
                      widget.asset.buffed_date_two,
                      widget.asset.buffed_date_three,
                      widget.asset.buffed_date_four,
                      widget.asset.buffed_date_five,
                      widget.asset.buffed_date_six,
                      widget.asset.cooling_start_temp,
                      widget.asset.cooling_end_temp,
                      widget.asset.cooling_date,
                      selectedSectionid!,
                      widget.asset.reso_num,
                      tfAssetFirstBuffedStatus.text,
                      widget.asset.banket,
                      tfAssetResult.text,
                      widget.asset.cooling_reheat_temp,
                      widget.asset.cooling_reheat_date,
                      widget.asset.cooling_end_date
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotProcessListUI(
                          user: widget.user, userRole: widget.userRole),
                    ),
                  );
                },
                child: const Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),);
  }
}