import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/sectionui/sectionlistui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class SectionSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const SectionSubmitUI({required this.user,required this.userRole, super.key});

  @override
  State<SectionSubmitUI> createState() => _SectionSubmitUIState();
}

class _SectionSubmitUIState extends State<SectionSubmitUI> {
  var tfSectionName = TextEditingController();
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
          MaterialPageRoute(builder: (context) => SectionListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Bölüm Kayıt"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: tfSectionName,
                  decoration: const InputDecoration(
                    hintText: "Bölüm Adı",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if(tfSectionName.text == null || tfSectionName.text == "") {
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
                    context.read<SectionSubmitCubit>().sectionSubmit(tfSectionName.text, widget.user.hotel);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SectionListUI(user: widget.user, userRole: widget.userRole)),
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


