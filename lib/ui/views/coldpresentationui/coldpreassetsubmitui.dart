import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldpreassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/coldpresentationui/coldpreassetlistui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class ColdPreAssetSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ColdPreAssetSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<ColdPreAssetSubmitUI> createState() => _ColdPreAssetSubmitUIState();
}

class _ColdPreAssetSubmitUIState extends State<ColdPreAssetSubmitUI> {
  var tfAssetName = TextEditingController();
  bool isReusable = false;
  int reuseInt = 0;
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
        MaterialPageRoute(builder: (context) => ColdPreAssetListUI(user: widget.user, userRole: widget.userRole)),
      );
      return false;
    },
    child: Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("Soğuk Sunum Ürün Adı"),
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
                  hintText: "Soğuk Sunum Ürün Adı",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Tekrar kullanılabilir mi?:"),
                  Checkbox(
                    value: isReusable,
                    onChanged: (bool? value) {
                      setState(() {
                        isReusable = value ?? false;
                        reuseInt = isReusable ? 1 : 0;
                      });
                    },
                  ),
                ],
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
                  context.read<ColdPreAssetSubmitCubit>().coldSubmit(tfAssetName.text, reuseInt, widget.user.hotel);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ColdPreAssetListUI(user: widget.user, userRole: widget.userRole)),
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

