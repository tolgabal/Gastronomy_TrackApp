import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/banketasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/banketinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/banketassetui/banketassetlistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class BanketAssetInfoUI extends StatefulWidget {
  BanketAsset asset;
  final User user;
  final Role userRole;
  BanketAssetInfoUI(this.asset, this.user, this.userRole);

  @override
  State<BanketAssetInfoUI> createState() => _BanketAssetInfoUIState();
}

class _BanketAssetInfoUIState extends State<BanketAssetInfoUI> {
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


  @override
  void initState() {
    // TODO: implement initState
    var asset = widget.asset;
    tfAssetName.text = asset.banket_name;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BanketAssetListUI(user: widget.user, userRole: widget.userRole)),
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
                  context.read<BanketInfoCubit>().banketUpdate(widget.asset.id, tfAssetName.text, widget.user.hotel);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BanketAssetListUI(user: widget.user, userRole: widget.userRole)));
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
