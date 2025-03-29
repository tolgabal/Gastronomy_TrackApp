import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../cubit/disinfectionassetsubmit_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';
import 'disinfectionassetlistui.dart';

class DisinfectionAssetSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const DisinfectionAssetSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<DisinfectionAssetSubmitUI> createState() => _DisinfectionAssetSubmitUIState();
}

class _DisinfectionAssetSubmitUIState extends State<DisinfectionAssetSubmitUI> {
  var tfAssetName = TextEditingController();
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
        MaterialPageRoute(builder: (context) => Disinfectionassetlistui(user: widget.user, userRole: widget.userRole)),
      );
      return false;
    },
    child: Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Dezenfeksiyon Ürün Listesi"),
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
                  hintText: "Ürün Adı",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,

              ),
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
                  context.read<DisinfectionAssetSubmitCubit>().disinSubmit(tfAssetName.text, widget.user.hotel);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Disinfectionassetlistui(user: widget.user, userRole: widget.userRole)),
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
