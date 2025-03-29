import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/hotpresentationasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/homepage.dart';
import 'package:gastrobluecheckapp/ui/views/hotpresentationui/hotpreassetinfoui.dart';
import 'package:gastrobluecheckapp/ui/views/hotpresentationui/hotpreassetsubmitui.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/infobutton.dart';
import '../../middleware/useroperation.dart';

class HotPreAssetListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const HotPreAssetListUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<HotPreAssetListUI> createState() => _HotPreAssetListUIState();
}

class _HotPreAssetListUIState extends State<HotPreAssetListUI> {
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
    context.read<HotPreAssetListCubit>().loadAssets(widget.user.hotel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
            ? TextField(
          decoration: const InputDecoration(hintText: "Search Asset"),
          onChanged: (searching) {
            context.read<HotPreAssetListCubit>().search(searching, widget.user.hotel);
          },
        )
            : const Text("Hot Presentation Asset List"),
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
                context.read<HotPreAssetListCubit>().loadAssets(widget.user.hotel);
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
      body: BlocBuilder<HotPreAssetListCubit, List<HotPresentationAsset>>(
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
                          title: Text("Do you want to delete ${asset.asset_name}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<HotPreAssetListCubit>().delete(asset.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${asset.asset_name} deleted",
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
                          MaterialPageRoute(builder: (context) => HotPreAssetInfoUI(asset,widget.user, widget.userRole)),);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No assets available."));
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
                      content: Text(InfoMessageProvider.getInfoMessage("hotpreinfo")),
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
                  MaterialPageRoute(builder: (context) => HotPreAssetSubmitUI(user: widget.user, userRole: widget.userRole)),);
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
