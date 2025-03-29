import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/disinfectionprocessasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocessinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionlist_cubit.dart';
import 'package:intl/intl.dart';
import '../../../data/entity/section.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';
import 'disinprocesslistui.dart';

class DisinProcessInfoUI extends StatefulWidget {
  final DisinfectionProcessAsset asset;
  final User user;
  final Role userRole;

  const DisinProcessInfoUI(this.asset, this.user, this.userRole, {super.key});

  @override
  State<DisinProcessInfoUI> createState() => _DisinProcessInfoUIState();
}

class _DisinProcessInfoUIState extends State<DisinProcessInfoUI> {
  var tfDisinprocName = TextEditingController();
  var tfDisinPiece = TextEditingController();
  var tfPieceType = TextEditingController();
  var tfProcType = TextEditingController();
  var tfSection = TextEditingController();
  var tfDateTime = TextEditingController();

  String? selectedAssetid;
  late String selectedSectionname;
  double _processTime = 10;
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
    var asset = widget.asset;

    // Populate fields with asset data
    tfDisinprocName.text = asset.asset_name;
    tfDisinPiece.text = asset.piece.toString();
    tfPieceType.text = asset.piece_type;
    tfProcType.text = asset.procType;
    _processTime = asset.procTime.toDouble();
    selectedAssetid = asset.id;

    // Format the date

    DateTime now = DateTime.now();
    timeString ="${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    tfDateTime.text =timeString!;

    // Section load
    selectedSectionname = asset.section;
    tfSection.text = asset.section;

    context.read<DisinProcessListCubit>().disinLoadAsset(widget.user.hotel, widget.user.section_id);
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve screen size
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding based on screen size
    double horizontalPadding = screenWidth * 0.03; // 3% of screen width as padding

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DisinProcessListUI(
              user: widget.user,
              userRole: widget.userRole,
            ),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Dezenfeksiyon Prosesi"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding), // Use dynamic padding
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Process Name
                TextField(
                  controller: tfDisinprocName,
                  decoration: const InputDecoration(
                    labelText: "Ürün Adı",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Quantity and Piece Type
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

                // Process Time Slider
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "İşlem Süresi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Text("10"),
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
                          const Text("15"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Process Type Buttons
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Dezenfeksiyon Türü",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tfProcType.text = 'Ozon';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tfProcType.text == 'Ozon'
                                    ? smallWidgetColor
                                    : Colors.white,
                              ),
                              child: const Text("Ozon"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  tfProcType.text = 'Sirke';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: tfProcType.text == 'Sirke'
                                    ? smallWidgetColor
                                    : Colors.white,
                              ),
                              child: const Text("Sirke"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section Dropdown

                const SizedBox(height: 10),

                // Submit Date (Read-only)
                TextField(
                  controller: tfDateTime,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Kayıt Tarihi",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Update Button
                ElevatedButton(
                  onPressed: () {
                    context.read<DisinProcessInfoCubit>().disinProcessUpdate(
                      widget.asset.id,
                      tfDisinprocName.text,
                      int.parse(tfDisinPiece.text),
                      _processTime.toInt(),
                      tfProcType.text,
                      widget.asset.section,
                      tfPieceType.text,
                      tfDateTime.text,
                      widget.user.hotel
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisinProcessListUI(
                          user: widget.user,
                          userRole: widget.userRole,
                        ),
                      ),
                    );
                  },
                  child: const Text("Güncelle"),
                ),
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
