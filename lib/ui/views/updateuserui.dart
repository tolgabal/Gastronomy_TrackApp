import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart'; // Rol modelini içe aktar
import 'package:gastrobluecheckapp/ui/cubit/userinfo_cubit.dart'; // Kullanıcı güncelleme işlemi için Cubit'i buradan içe aktar
import 'package:gastrobluecheckapp/ui/cubit/roleconfiglist_cubit.dart'; // Role Cubit'i içe aktar
import 'package:gastrobluecheckapp/ui/views/userui/userlistui.dart';

import '../../../data/entity/section.dart';
import '../cubit/sectionlist_cubit.dart';
import '../middleware/bottomnavigationbar.dart';
import 'homepage.dart'; // Güncelleme sonrası yönlendirilecek sayfa

class UpdateUserUI extends StatefulWidget {
  final User user;
  final User logUser;
  final Role userRole;

  UpdateUserUI(this.user, this.logUser, this.userRole);

  @override
  State<UpdateUserUI> createState() => _UserInfoUIState();
}

class _UserInfoUIState extends State<UpdateUserUI> {
  var tfUsername = TextEditingController();
  var tfPassword = TextEditingController();
  var tfName = TextEditingController();
  var tfHotel = TextEditingController();
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
  // Seçilen role id'yi burada saklayacağız
  String? selectedRoleId;
  String? selectedSectionId;

  @override
  void initState() {
    super.initState();
    // Kullanıcı bilgilerinin mevcut değerlerini TextField'lara dolduruyoruz
    var user = widget.user;
    tfUsername.text = user.username;
    tfPassword.text = user.password;
    tfName.text = user.name;
    tfHotel.text = user.hotel;

    // Mevcut role_id'yi sakla
    selectedRoleId = user.role_id;
    selectedSectionId = user.section_id;

    // Roller yüklensin
    context.read<RoleConfigListCubit>().loadRoles(widget.logUser.hotel);
    context.read<SectionListCubit>().loadSections(widget.logUser.hotel);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(backgroundColor: mainColor,
            title: const Text("Kullanıcı Güncelleme")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // İsim alanı
                TextField(
                  controller: tfName,
                  decoration: const InputDecoration(hintText: "İsim"),
                ),
                // Şifre alanı
                TextField(
                  controller: tfPassword,
                  decoration: const InputDecoration(hintText: "Şifre"),
                  obscureText: true,
                ),
                // Güncelle butonu
                ElevatedButton(
                  onPressed: () {
                    // Eğer rol seçilmediyse hata verdir
                    if (selectedRoleId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(""),
                        ),
                      );
                      return;
                    }

                    if (selectedSectionId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a section"),
                        ),
                      );
                      return;
                    }

                    if (tfUsername.text == null || tfPassword.text == null || tfName.text == null || tfHotel.text == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all areas"),
                        ),
                      );
                      return;
                    }

                    // Bloc yardımıyla kullanıcı güncellemesi yapılıyor
                    context.read<UserInfoCubit>().update(
                      widget.user.id,
                      selectedRoleId!, // Seçilen role_id'yi gönderiyoruz
                      selectedSectionId!,
                      tfUsername.text,
                      tfPassword.text,
                      tfName.text,
                      tfHotel.text,
                    );

                    // Güncelleme sonrası kullanıcı listesine geri dönülüyor
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage(user: widget.logUser, userRole: widget.userRole)));
                  },
                  child: const Text("Güncelle"),
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