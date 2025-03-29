import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/coldroomasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldroominfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/coldroomassetui/coldroomassetlistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class ColdRoomAssetInfoUI extends StatefulWidget {
  ColdRoomAsset asset;
  final User user;
  final Role userRole;
  ColdRoomAssetInfoUI(this.asset, this.user, this.userRole);

  @override
  State<ColdRoomAssetInfoUI> createState() => _ColdRoomAssetInfoUIState();
}

class _ColdRoomAssetInfoUIState extends State<ColdRoomAssetInfoUI> {
  var tfAssetName = TextEditingController();
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

  void initState() {
    // TODO: implement initState
    var asset = widget.asset;
    tfAssetName.text = asset.cold_room_name;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ColdRoomAssetListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Info"),),
        body: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(controller: tfAssetName, decoration: const InputDecoration(hintText: "Asset Name"),),

                ElevatedButton(onPressed: (){
                  context.read<ColdRoomInfoCubit>().coldRoomUpdate(widget.asset.id, tfAssetName.text, widget.user.hotel);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ColdRoomAssetListUI(user: widget.user, userRole: widget.userRole)));
                }, child: Text("Güncelle"))
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
