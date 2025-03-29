import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldprocessasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocesslist_cubit.dart';

import '../../../color.dart'; // Renk temalarını içeriyor
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';

import '../../middleware/bottomnavigationbar.dart'; // Alt menü
import '../../middleware/infobutton.dart'; // Bilgi butonu
import '../homepage.dart'; // Ana sayfa
import 'coldprocbuffedinfoui.dart';
import 'coldproccoldroominfoui.dart';
import 'coldproccoolinginfoui.dart';
import 'coldprocesssubmitui.dart';
import 'endofcoldbuffed.dart'; // Cold Process Submit UI

class ColdProcessListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ColdProcessListUI({required this.user, required this.userRole, super.key});

  @override
  State<ColdProcessListUI> createState() => _ColdProcessListUIState();
}

class _ColdProcessListUIState extends State<ColdProcessListUI> {
  bool searchIsActive = false;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();


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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(index);
    });
  }


  @override
  void initState() {
    super.initState();
    loadAssetsForAllCategories();
  }

  void loadAssetsForAllCategories() {
    context.read<ColdProcessListCubit>().coldProcLoad(
        widget.user.hotel, widget.user.section_id);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage(user: widget.user, userRole: widget.userRole)),
      );
      return false;
    },
      child: DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Soğuk Sunum Prosesi"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Soğuk Oda'),
              Tab(text: 'Büfe/Sunum'),
              Tab(text: 'Soğutma'),
              Tab(text: 'Büfe Sonu',)

            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab(context, "Soğuk Oda"),
            _buildTab(context, "Büfe/Sunum"),
            _buildTab(context, "Soğutma"),
            _buildTab(context, "Büfe Sonu")
          ],
        ),
        floatingActionButton: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Positioned(
              bottom: 5,
              left: 30,
              child: FloatingActionButton(
                backgroundColor: bigWidgetColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Info"),
                        content: Text(InfoMessageProvider.getInfoMessage(
                            "coldprocinfo") ?? "No information available."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Kapat"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.info, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 0,
              child: FloatingActionButton(
                backgroundColor: bigWidgetColor,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ColdProcessSubmitUI(
                              user: widget.user, userRole: widget.userRole),
                    ),
                  ).then((value) {
                    loadAssetsForAllCategories();
                  });
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    ),
    );
  }

  Widget _buildTab(BuildContext context, String category) {
    return BlocBuilder<ColdProcessListCubit, List<ColdProcessAsset>>(
      builder: (context, assetList) {
        if (assetList.isEmpty) {
          return const Center(child: Text("Ürün bulunmamaktadır."));
        }
        final filteredAssets = assetList.where((asset) =>
        asset.asset_status == category).toList();
        if (filteredAssets.isEmpty) {
          return const Center(child: Text("Ürün bulunmamaktadır"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: filteredAssets.length,
          itemBuilder: (context, index) {
            return _buildListItem(
                filteredAssets[index]); // assetName'a dikkat et
          },
        );
      },
    );
  }

  Widget _buildListItem(ColdProcessAsset asset) {
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
              title: Text("${asset.asset_name} isimli ürünü silmek istediğinizden emin misiniz?"),
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
        context.read<ColdProcessListCubit>().coldProcDelete(asset.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${asset.asset_name} isimli ürün silindi",
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: smallWidgetColor,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          if (asset.asset_status == "Soğuk Oda") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ColdProcColdRoomInfoUI(asset: asset,user: widget.user, userRole: widget.userRole),
              ),
            );
          } else if (asset.asset_status == "Büfe/Sunum") {

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ColdProcBuffedInfoUI(asset: asset,user: widget.user, userRole: widget.userRole),
              ),
            );
          }else if (asset.asset_status == "Soğutma") {

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ColdProcCoolingInfoUI(asset: asset,user: widget.user, userRole: widget.userRole),
              ),
            );
          }else if (asset.asset_status == "Büfe Sonu") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ColdProcEndBuffedUI(asset: asset,user: widget.user, userRole: widget.userRole),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: smallWidgetColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                asset.asset_name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}