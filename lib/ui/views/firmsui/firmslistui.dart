import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/firms.dart';
import 'package:gastrobluecheckapp/ui/cubit/firmslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/firmsui/firmsinfoui.dart';
import 'package:gastrobluecheckapp/ui/views/firmsui/firmssubmitui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/infobutton.dart';
import '../../middleware/useroperation.dart';
import '../homepage.dart';

class FirmsListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const FirmsListUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<FirmsListUI> createState() => _FirmsListUIState();
}

class _FirmsListUIState extends State<FirmsListUI> {
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

  void initState(){
    super.initState();
    context.read<FirmsListCubit>().loadFirms(widget.user.hotel);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
            ? TextField(
          decoration: const InputDecoration(hintText: "Firma ara"),
          onChanged: (searching) {
            context.read<FirmsListCubit>().firmSearch(searching, widget.user.hotel);
          },
        )
            : const Text("Firma Listesi"),
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
                context.read<FirmsListCubit>().loadFirms(widget.user.hotel);
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
      body: BlocBuilder<FirmsListCubit, List<Firms>>(
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
                          title: Text("Do you want to delete ${asset.firm_name}?"),
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
                    context.read<FirmsListCubit>().firmDelete(asset.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${asset.firm_name} deleted",
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
                      title: Text(asset.firm_name),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => FirmsInfoUI(asset, widget.user, widget.userRole)),
                        ).then((value) {
                          context.read<FirmsListCubit>().loadFirms(widget.user.hotel);
                        });
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
                      content: Text(InfoMessageProvider.getInfoMessage("firmsinfo")),
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
                  MaterialPageRoute(builder: (context) => FirmsSubmitUI(user: widget.user, userRole: widget.userRole)),
                ).then((value) {
                  context.read<FirmsListCubit>().loadFirms(widget.user.hotel);
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
    );
  }
}
