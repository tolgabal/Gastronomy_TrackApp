import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/buffedtimesasset.dart';
import 'package:gastrobluecheckapp/main.dart';
import 'package:gastrobluecheckapp/ui/cubit/buffedtimeslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/buffedtimesui/buffedtimesassetsubmitui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/infobutton.dart';
import '../homepage.dart';
import 'buffedtimesassetinfoui.dart';

class BuffedTimesAssetListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const BuffedTimesAssetListUI({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  State<BuffedTimesAssetListUI> createState() => _BuffedTimesAssetListUIState();
}

class _BuffedTimesAssetListUIState extends State<BuffedTimesAssetListUI> {
  List<bool> _isExpandedList = []; // Genişletme durumunu tutan liste
  bool searchIsActive = false;
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
    context.read<BuffedTimesAssetListCubit>().bufedTimesLoadAssets(widget.user.hotel);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Ekran boyutunu al
    final boxWidth = screenSize.width * 0.9; // Kutucuk genişliği (ekranın %90'ı)
    final boxHeight = screenSize.height * 0.1; // Kutucuk yüksekliği (ekranın %20'si)

    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BuffedTimesAssetListUI(user: widget.user, userRole: widget.userRole)),
      );
      return false;
    },
      child:Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
            ? TextField(
          decoration: const InputDecoration(hintText: "Search Asset"),
          onChanged: (searching) {
            context.read<BuffedTimesAssetListCubit>().buffedTimesSearch(searching, widget.user.hotel);
          },
        )
            : const Text("Büfe Zamanı"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          searchIsActive
              ? IconButton(
              onPressed: () {
                setState(() {
                  searchIsActive = false;
                });
                context.read<BuffedTimesAssetListCubit>().bufedTimesLoadAssets(widget.user.hotel);
              },
              icon: const Icon(Icons.clear))
              : IconButton(
              onPressed: () {
                setState(() {
                  searchIsActive = true;
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: BlocBuilder<BuffedTimesAssetListCubit, List<BuffedTimesAsset>>(
        builder: (context, assetList) {
          // İlk yükleme sırasında _isExpandedList'i başlat
          if (_isExpandedList.length != assetList.length) {
            _isExpandedList = List.generate(assetList.length, (index) => false);
          }

          if (assetList.isNotEmpty) {
            return ListView.builder(
              itemCount: assetList.length,
              itemBuilder: (context, index) {
                var asset = assetList[index];
                return Dismissible(
                  key: Key(asset.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(" Büfe Zamanları'nı silmek istiyor musunuz?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Hayır"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Evet"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<BuffedTimesAssetListCubit>().buffedTimesDelete(asset.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Büfe Zamanları silindi",
                          style: const TextStyle(color: Colors.black),
                        ),
                        backgroundColor: smallWidgetColor,
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpandedList[index] = !_isExpandedList[index]; // Genişlet veya daralt
                      });
                    },
                    child: Card(
                      color: smallWidgetColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Büfe Zamanları"),
                          ),
                          // Eğer genişletilmişse, ek bilgileri göster
                          if (_isExpandedList[index]) ...[
                            // Sabah Büfesi Zamanı Kutucuğu
                            Container(
                              width: boxWidth, // Ekrana göre ayarlanmış genişlik
                              height: boxHeight, // Ekrana göre ayarlanmış yükseklik
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(8), // Kutucuk köşe yuvarlama
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3), // Kutucuk gölgesi
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Sabah Büfesi Zamanı:", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8), // Araya biraz boşluk
                                  Text("Başlangıç: ${asset.sabah_baslangic}"),
                                  Text("Bitiş: ${asset.sabah_bitis}"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10), // Kutucuklar arası boşluk

                            // Öğle Büfesi Zamanı Kutucuğu
                            Container(
                              width: boxWidth, // Ekrana göre ayarlanmış genişlik
                              height: boxHeight, // Ekrana göre ayarlanmış yükseklik
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(8), // Kutucuk köşe yuvarlama
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3), // Kutucuk gölgesi
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Öğle Büfesi Zamanı:", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8), // Araya biraz boşluk
                                  Text("Başlangıç: ${asset.ogle_baslangic}"),
                                  Text("Bitiş: ${asset.ogle_bitis}"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10), // Kutucuklar arası boşluk

                            // Akşam Büfesi Zamanı Kutucuğu
                            Container(
                              width: boxWidth, // Ekrana göre ayarlanmış genişlik
                              height: boxHeight, // Ekrana göre ayarlanmış yükseklik
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(8), // Kutucuk köşe yuvarlama
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3), // Kutucuk gölgesi
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Akşam Büfesi Zamanı:", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8), // Araya biraz boşluk
                                  Text("Başlangıç: ${asset.aksam_baslangic}"),
                                  Text("Bitiş: ${asset.aksam_bitis}"),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Henüz veri yok."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: bigWidgetColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuffedTimesAssetSubmitUI(
                user: widget.user,
                userRole: widget.userRole,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      ),
    );
  }
}
