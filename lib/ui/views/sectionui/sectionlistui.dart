import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/section.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/sectionui/sectioninfoui.dart';
import 'package:gastrobluecheckapp/ui/views/sectionui/sectionsubmit.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/infobutton.dart';
import '../homepage.dart';

class SectionListUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const SectionListUI({required this.user, required this.userRole, super.key});

  @override
  State<SectionListUI> createState() => _SectionListUIState();
}

class _SectionListUIState extends State<SectionListUI> {
  bool searchIsActive = false;
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
    super.initState();
    context.read<SectionListCubit>().loadSections(widget.user.hotel);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: searchIsActive
            ? TextField(
          decoration: const InputDecoration(hintText: "Bölüm Ara"),
          onChanged: (searching) {
            context.read<SectionListCubit>().sectionSearch(searching, widget.user.hotel);
          },
        )
            : const Text("Bölüm Listesi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          searchIsActive
              ? IconButton(
              onPressed: () {
                setState(() {
                  searchIsActive = false;
                });
                context.read<SectionListCubit>().loadSections(widget.user.hotel);
              },
              icon: const Icon(Icons.clear))
              : IconButton(
              onPressed: () {
                setState(() {
                  searchIsActive = true;
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: BlocBuilder<SectionListCubit, List<Section>>(
        builder: (context, sectionList) {
          if (sectionList.isNotEmpty) {
            return ListView.builder(
              itemCount: sectionList.length,
              itemBuilder: (context, index) {
                var section = sectionList[index];
                return Dismissible(
                  key: Key(section.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("${section.section_name} silmek istiyor musunuz?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Hayır"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Evet"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<SectionListCubit>().sectionDelete(section.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "${section.section_name} silindi",
                          style: const TextStyle(color: Colors.black),
                        ),
                        backgroundColor: smallWidgetColor,
                      ),
                    );
                  },
                  child: Card(
                    color: smallWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(section.section_name),

                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SectionInfoUI(section,widget.user, widget.userRole)),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Bölüm Bulunmamakta."));
          }
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Info Button
          Positioned(
            bottom: 5,
            left: 30,
            child: FloatingActionButton(
              backgroundColor: bigWidgetColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Info"),
                      content: Text(InfoMessageProvider.getInfoMessage("sectioninfo")),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Kapat"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.info, color: Colors.white),
            ),
          ),
          // Add Button
          Positioned(
            bottom: 5,
            right: 0,
            child: FloatingActionButton(
              backgroundColor: bigWidgetColor,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SectionSubmitUI(user: widget.user, userRole: widget.userRole)),
                );
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
