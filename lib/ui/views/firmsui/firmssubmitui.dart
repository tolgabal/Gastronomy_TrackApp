import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/firmssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/firmsui/firmslistui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class FirmsSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const FirmsSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<FirmsSubmitUI> createState() => _FirmsSubmitUIState();
}

class _FirmsSubmitUIState extends State<FirmsSubmitUI> {
  var tfFirmName = TextEditingController();
  bool isReusable = false;
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
          MaterialPageRoute(builder: (context) => FirmsListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Firma Kayıt Ekranı"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: tfFirmName,
                  decoration: const InputDecoration(
                    hintText: "Firma Adı",
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(tfFirmName.text == null || tfFirmName.text == "") {
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
                    context.read<FirmsSubmitCubit>().FirmSubmit(tfFirmName.text, widget.user.hotel);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FirmsListUI(user: widget.user, userRole: widget.userRole)),
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
