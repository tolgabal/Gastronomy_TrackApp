
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/disinfectionprocessasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/main.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/disinprocessui/disinprocessinfoui.dart';
import 'package:gastrobluecheckapp/ui/views/disinprocessui/disinprocesssubmitui.dart';

import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/infobutton.dart';
import '../homepage.dart';

class DisinProcessListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const DisinProcessListUI({required this.user,required this.userRole, super.key});

  @override
  State<DisinProcessListUI> createState() => _DisinProcessListUIState();
}

class _DisinProcessListUIState extends State<DisinProcessListUI> {
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
    // TODO: implement initState
    super.initState();
    context.read<DisinProcessListCubit>().disinLoadAsset(widget.user.hotel, widget.user.section_id);
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
          decoration: const InputDecoration(hintText: "Dezenfeksiyon Proses ürünü ara"),
          onChanged: (searching) {
            context.read<DisinProcessListCubit>().disinProcessSearch(searching, widget.user.hotel, widget.user.section_id);
          },
        )
            : const Text("Dezenfeksiyon Prosesi"),
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
                context.read<DisinProcessListCubit>().disinLoadAsset(widget.user.hotel, widget.user.section_id);
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
      ),body: BlocBuilder<DisinProcessListCubit, List<DisinfectionProcessAsset>>(
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
                        title: Text("${asset.asset_name} silmek istiyor musunuz?"),
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
                  context.read<DisinProcessListCubit>().disinProcessDelete(asset.id);
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DisinProcessInfoUI(asset,widget.user, widget.userRole)),
                      );
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("Ürün bulunmakatadır"));
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
                      content: Text(InfoMessageProvider.getInfoMessage("disinprocessinfo")),
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
                  MaterialPageRoute(builder: (context) => DisinProcessSubmitUI(user: widget.user, userRole: widget.userRole)),
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
    ),
    );
  }
}