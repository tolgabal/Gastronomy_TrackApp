/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/buffedtimesasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/buffedtimesinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/buffedtimesui/buffedtimesassetlistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class BuffedTimesAssetInfoUI extends StatefulWidget {
  BuffedTimesAsset asset;
  final User user;
  final Role userRole;
  BuffedTimesAssetInfoUI(this.asset, this.user, this.userRole);

  @override
  State<BuffedTimesAssetInfoUI> createState() => _BuffedTimesAssetInfoUIState();
}

class _BuffedTimesAssetInfoUIState extends State<BuffedTimesAssetInfoUI> {
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BuffedTimesAssetListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child:Scaffold(
        appBar: AppBar(title: const Text("Information Page"),),
        body: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(controller: tfAssetName, decoration: const InputDecoration(hintText: "Asset Name"),),

                ElevatedButton(onPressed: (){
                  context.read<BuffedTimesAssetInfoCubit>().buffedTimesUpdate(widget.asset.id, tfAssetName.text, widget.user.hotel);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BuffedTimesAssetListUI(user: widget.user, userRole: widget.userRole)));
                }, child: Text("Update"))
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
*/