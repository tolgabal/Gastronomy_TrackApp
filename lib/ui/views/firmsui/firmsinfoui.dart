import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/firms.dart';
import 'package:gastrobluecheckapp/ui/cubit/firmsinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/firmsui/firmslistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class FirmsInfoUI extends StatefulWidget {
  Firms firm;
  final User user;
  final Role userRole;
  FirmsInfoUI(this.firm, this.user, this.userRole);

  @override
  State<FirmsInfoUI> createState() => _FirmsInfoUIState();
}

class _FirmsInfoUIState extends State<FirmsInfoUI> {
  var tfFirmName = TextEditingController();
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
    var firm = widget.firm;
    tfFirmName.text = firm.firm_name;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FirmsListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Information Page"),),
        body: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(controller: tfFirmName, decoration: const InputDecoration(hintText: "Firm Name"),),

                ElevatedButton(onPressed: (){
                  context.read<FirmsInfoCubit>().FirmUpdate(widget.firm.id, tfFirmName.text, widget.user.hotel);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FirmsListUI(user: widget.user, userRole: widget.userRole)));
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
