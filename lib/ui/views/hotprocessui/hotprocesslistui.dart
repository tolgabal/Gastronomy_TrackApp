import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/hotprocessasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/middleware/bottomnavigationbar.dart';
import 'package:gastrobluecheckapp/ui/views/hotprocessui/hotprocesssubmitui.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/infobutton.dart';
import '../homepage.dart';
import 'banketinfoui.dart';
import 'buffedinfoui.dart';
import 'coolinginfoui.dart';
import 'endbuffedinfoui.dart';

class HotProcessListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const HotProcessListUI(
      {required this.user, required this.userRole, super.key});

  @override
  State<HotProcessListUI> createState() => _HotProcessListUIState();
}

class _HotProcessListUIState extends State<HotProcessListUI> {
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
    context.read<HotProcessListCubit>().hotProcessAssetLoad(widget.user.hotel, widget.user.section_id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Sıcak Sunum Listesi"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Banket'),
              Tab(text: 'Büfe/Sunum'),
              Tab(text: 'Soğutma & Tekrar Isıtma '),
              Tab(text: "Büfe Sonu")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab(context, "Banket"),
            _buildTab(context, "Buffed"),
            _buildTab(context, "Cooling and Reheat"),
            _buildTab(context, "End of Buffed") // Değeri düzelttim
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
                        title: const Text("Bilgi"),
                        content: Text(InfoMessageProvider.getInfoMessage(
                            "hotprocessinfo") ??
                            "No information available."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("Close"),
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
                      builder: (context) => HotProcessSubmitUI(
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
    );
  }

  Widget _buildTab(BuildContext context, String category) {
    return BlocBuilder<HotProcessListCubit, List<HotProcessAsset>>(
      builder: (context, assetList) {
        if (assetList.isEmpty) {
          return const Center(child: Text("Ürün bulunmamakta."));
        }
        final filteredAssets =
        assetList.where((asset) => asset.presentation == category).toList();
        if (filteredAssets.isEmpty) {
          return const Center(child: Text("Ürün bulunmamakta."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: filteredAssets.length,
          itemBuilder: (context, index) {
            return _buildListItem(filteredAssets[index]);
          },
        );
      },
    );
  }

  Widget _buildListItem(HotProcessAsset asset) {
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
              title: Text(" ${asset.asset_name} ürününü silmek istediğinizden emin misiniz?"),
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
        context.read<HotProcessListCubit>().hotProcessAssetDelete(asset.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${asset.asset_name} silindi",
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: smallWidgetColor,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          if (asset.presentation == "Banket") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BanketInfoUI(asset: asset,
                            user: widget.user, userRole: widget.userRole)));
          } else if (asset.presentation == "Buffed") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BuffedInfoUI(asset: asset,
                            user: widget.user, userRole: widget.userRole)));
          } else if (asset.presentation == "Cooling and Reheat") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CoolingInfoUI(asset: asset, user: widget.user, userRole: widget.userRole)));
          } else if (asset.presentation == "End of Buffed") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EndBuffedInfoUI(asset: asset,
                            user: widget.user, userRole: widget.userRole)));
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
              child:
              Text(asset.asset_name, style: const TextStyle(fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}
