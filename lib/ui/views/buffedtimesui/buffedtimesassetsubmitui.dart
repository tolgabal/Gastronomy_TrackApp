import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../cubit/buffedtimessubmit_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';
import 'buffedtimesassetlistui.dart';

class BuffedTimesAssetSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const BuffedTimesAssetSubmitUI({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  State<BuffedTimesAssetSubmitUI> createState() => _BuffedTimesAssetSubmitUIState();
}

class _BuffedTimesAssetSubmitUIState extends State<BuffedTimesAssetSubmitUI> {
  var tfSabahBaslangic = TextEditingController();
  var tfSabahBitis = TextEditingController();
  var tfOgleBaslangic = TextEditingController();
  var tfOgleBitis = TextEditingController();
  var tfAksamBaslangic = TextEditingController();
  var tfAksamBitis = TextEditingController();

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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BuffedTimesAssetListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Büfe Zamanı Kayıt"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sabah Büfesi Kutusu
                  Card(
                    color: smallWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Text(
                            "Sabah Büfesi",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tfSabahBaslangic,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Başlangıç Saati",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tfSabahBitis,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Bitiş Saati",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Boşluk

                  // Öğle Büfesi Kutusu
                  Card(
                    color: smallWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Text(
                            "Öğle Büfesi",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tfOgleBaslangic,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Başlangıç Saati",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tfOgleBitis,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Bitiş Saati",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Boşluk

                  // Akşam Büfesi Kutusu
                  Card(
                    color: smallWidgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          const Text(
                            "Akşam Büfesi",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tfAksamBaslangic,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Başlangıç Saati",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: tfAksamBitis,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Bitiş Saati",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Butonu
                  ElevatedButton(
                    onPressed: () {
                      context.read<BuffedTimesAssetSubmitCubit>().buffedTimesSubmit(
                          tfSabahBaslangic.text, tfSabahBitis.text,
                          tfOgleBaslangic.text, tfOgleBitis.text,
                          tfAksamBaslangic.text, tfAksamBitis.text,
                          widget.user.hotel);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BuffedTimesAssetListUI(user: widget.user, userRole: widget.userRole)),
                      );
                    },
                    child: const Text("Kaydet"),
                  ),
                ],
              ),
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
