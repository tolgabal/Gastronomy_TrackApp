import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/section.dart';
import 'package:gastrobluecheckapp/ui/views/sectionui/sectionlistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../cubit/sectioninfo_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class SectionInfoUI extends StatefulWidget {
  Section section;
  final User user;
  final Role userRole;
  SectionInfoUI(this.section, this.user, this.userRole, {super.key});

  @override
  State<SectionInfoUI> createState() => _SectionInfoUIState();
}

class _SectionInfoUIState extends State<SectionInfoUI> {
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
  void initState() {
    // TODO: implement initState
    var section = widget.section;
    tfSectionName.text = section.section_name;
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
        appBar: AppBar(title: const Text("Info"),),
        body: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(controller: tfSectionName, decoration: const InputDecoration(hintText: "Bölüm Adı"),),

                ElevatedButton(onPressed: (){
                  context.read<SectionInfoCubit>().sectionUpdate(widget.section.id, tfSectionName.text, widget.user.hotel);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SectionListUI(user: widget.user, userRole: widget.userRole)));
                }, child: const Text("Güncelle"))
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
