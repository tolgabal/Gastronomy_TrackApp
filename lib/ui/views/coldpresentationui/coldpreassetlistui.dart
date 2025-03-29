import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldpresentationasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/middleware/useroperation.dart';
import 'package:gastrobluecheckapp/ui/views/coldpresentationui/coldpreassetinfoui.dart';
import 'package:gastrobluecheckapp/ui/views/coldpresentationui/coldpreassetsubmitui.dart';
import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/infobutton.dart';
import '../homepage.dart';

class ColdPreAssetListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ColdPreAssetListUI({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  State<ColdPreAssetListUI> createState() => _ColdPreAssetListUIState();
}

class _ColdPreAssetListUIState extends State<ColdPreAssetListUI> {
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
    context.read<ColdPreAssetListCubit>().coldLoadAsset(widget.user.hotel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
            ? TextField(
          decoration: const InputDecoration(hintText: "Soğuk Sunum Ürün Ara"),
          onChanged: (searching) {
            context.read<ColdPreAssetListCubit>().coldSearch(searching, widget.user.hotel);
          },
        )
            : const Text("Soğuk Sunum Ürün Listesi"),
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
                context.read<ColdPreAssetListCubit>().coldLoadAsset(widget.user.hotel);
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
      body: BlocBuilder<ColdPreAssetListCubit, List<ColdPresentationAsset>>(
        builder: (context, assetList) {
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
                          title: Text(" ${asset.asset_name} silmek ister misiniz?"),
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
                    context.read<ColdPreAssetListCubit>().coldDelete(asset.id);
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
                  child: Card(
                    color: smallWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(asset.asset_name),
                      trailing: Icon(
                        asset.reuse_isactive == 1 ? Icons.check_circle : Icons.cancel,
                        color: asset.reuse_isactive == 1 ? Colors.green : Colors.red,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => coldPreAssetInfoUI(asset,widget.user, widget.userRole)),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Listede ürün bulunmamaktadır."));
          }
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Info Button
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
                      content: Text(InfoMessageProvider.getInfoMessage("coldpreinfo")),
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
          // Add Button
          Positioned(
            bottom: 5,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: bigWidgetColor,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ColdPreAssetSubmitUI(user: widget.user, userRole: widget.userRole)),
                );
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
    );
  }
}
