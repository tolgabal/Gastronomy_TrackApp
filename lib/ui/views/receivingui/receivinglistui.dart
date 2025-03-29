import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/receivingasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/middleware/bottomnavigationbar.dart';
import 'package:gastrobluecheckapp/ui/middleware/infobutton.dart';
import 'package:gastrobluecheckapp/ui/views/homepage.dart';
import 'package:gastrobluecheckapp/ui/views/receivingui/receivinginfoui.dart';
import 'package:gastrobluecheckapp/ui/views/receivingui/receivingsubmitui.dart';

import '../../cubit/recassetlist_cubit.dart';

class ReceivingListUI extends StatefulWidget {
  final User user;
  final Role userRole;
  const ReceivingListUI({required this.user, required this.userRole, super.key});

  @override
  State<ReceivingListUI> createState() => _ReceivingListUIState();
}

class _ReceivingListUIState extends State<ReceivingListUI> {
  bool searchIsActive = false;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void  _onItemTapped(int index){
    setState(() {
      _selectedIndex =index;
    });

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => Homepage(user: widget.user, userRole: widget.userRole)
        ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_){
      _pageController.jumpToPage(index);
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RecAssetlistCubit>().loadAssets(widget.user.hotel);
  }
  @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
          ? TextField(
          decoration: const InputDecoration(hintText: "Mal kabül ürünü ara"),
          onChanged: (searching){
            context.read<RecAssetlistCubit>().search(searching, widget.user.hotel);
          },
        )
            : const Text("Mal Kabul Ürün Listesi"),
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
                  searchIsActive =false;
                });
                context.read<RecAssetlistCubit>().loadAssets(widget.user.hotel);
              },
            icon: const Icon(Icons.clear)
          )
              :IconButton(
            onPressed: () {
              setState(() {
                searchIsActive = true;
              });
            },
              icon: const Icon(Icons.search),
          )
        ],
      ),

      body: BlocBuilder<RecAssetlistCubit, List<ReceivingAsset>>(
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
                          title: Text(" ${asset.asset_name} silmek istiyor musunuz?"),
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
                    context.read<RecAssetlistCubit>().delete(asset.id);
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

                      onTap: () {

                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("ürün bulunmamaktadır."));
          }
        },
      ),

      floatingActionButton: Stack(
        alignment:  Alignment.bottomLeft,
        children: [
          Positioned(
            bottom: 5,
            left: 30,
            child: FloatingActionButton(
              backgroundColor: bigWidgetColor,
              onPressed: () {
                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(
                    title: const Text("info"),
                    content: Text(InfoMessageProvider.getInfoMessage("ReceivingInfo")),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Kapat"),
                      ),
                    ],
                  );
                },
                );
              },
              child: const Icon(Icons.info,color: Colors.white,),

            ),
          ),
          Positioned(
            bottom: 5,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: bigWidgetColor,
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                MaterialPageRoute(builder: (context) => ReceivingSubmitUI(widget.user, widget.userRole)),
                );
              },
              child: const Icon(Icons.add,color: Colors.white,),
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
}
