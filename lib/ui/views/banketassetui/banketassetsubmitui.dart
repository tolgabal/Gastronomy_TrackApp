import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/banketsubmit_cubit.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';
import 'banketassetlistui.dart';

class BanketAssetSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;
  const BanketAssetSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<BanketAssetSubmitUI> createState() => _BanketAssetSubmitUIState();
}

class _BanketAssetSubmitUIState extends State<BanketAssetSubmitUI> {
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
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Banket Arabası Adı"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: tfAssetName,
                  decoration: const InputDecoration(
                    hintText: "Banket Adı Giriniz",
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if(tfAssetName.text == null || tfAssetName.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "İsim Alanı Boş Bırakılamaz!",
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: smallWidgetColor,
                        ),
                      );
                    }
                    context.read<BanketSubmitCubit>().banketSubmit(tfAssetName.text, widget.user.hotel);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BanketAssetListUI(user: widget.user, userRole: widget.userRole)),
                    );
                  },
                  child: const Text("Kaydet"),
                ),
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
