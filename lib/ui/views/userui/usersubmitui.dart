import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/ui/cubit/usersubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiglist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/userui/userlistui.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';

import '../../../data/entity/section.dart';
import '../../../data/entity/user.dart';
import '../../cubit/sectionlist_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../homepage.dart';

class UserSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const UserSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<UserSubmitUI> createState() => _UserSubmitUIState();
}

class _UserSubmitUIState extends State<UserSubmitUI> {
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
    // Role listesini sayfa yüklendiğinde çek
    context.read<RoleConfigListCubit>().loadRoles(widget.user.hotel);
    context.read<SectionListCubit>().loadSections(widget.user.hotel);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserListUI(logUser: widget.user, userRole: widget.userRole)),
        );
    return false;
    },
      child: Scaffold(
        backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text("User Submit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Username input field
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: tfUsername,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Password input field
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: tfPassword,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),

              // Name input field
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: tfName,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // Role selection dropdown
              BlocBuilder<RoleConfigListCubit, List<Role>>(
                builder: (context, roleList) {
                  if (roleList.isEmpty) {
                    return const Center(child: Text("No roles available"));
                  }

                  return DropdownButtonFormField<String>(
                    hint: const Text("Select Role"),
                    value: selectedRoleId, // Role ID'yi göstermek için
                    items: roleList.map((role) {
                      return DropdownMenuItem<String>(
                        value: role.id, // Role ID'si
                        child: Text(role.role_name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoleId = value; // Seçilen Role ID'sini güncelle
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),

              BlocBuilder<SectionListCubit, List<Section>>(
                builder: (context, sectionList) {
                  if (sectionList.isEmpty) {
                    return const Center(child: Text("No sections available")); // Düzenlendi
                  }

                  return DropdownButtonFormField<String>(
                    hint: const Text("Select Section"),
                    value: selectedSectionId, // Seçilen Section ID'yi göstermek için
                    items: sectionList.map((section) {
                      return DropdownMenuItem<String>(
                        value: section.id, // Section ID'si
                        child: Text(section.section_name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSectionId = value; // Seçilen Section ID'sini güncelle
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20), // Adding some space before the submit button
              ElevatedButton(
                onPressed: () {
                  if (selectedRoleId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a role"),
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

                  // Submit user data using the Cubit
                  if (widget.user.username.trim() == 'admin'.trim()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // TextField kontrolü için bir controller tanımlıyoruz
                        TextEditingController hotelNameController = TextEditingController();

                        return AlertDialog(
                          title: Text('Hotel Adı Girin'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: hotelNameController, // Kullanıcıdan otel adını almak için
                                decoration: InputDecoration(
                                  labelText: 'Hotel Adı',
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('Submit'),
                              onPressed: () {
                                // Kullanıcının girdiği otel adını al
                                String enteredHotelName = hotelNameController.text;
                                // Submit fonksiyonunu çağırıyoruz
                                context.read<UserSubmitCubit>().submit(
                                  selectedRoleId!,
                                  selectedSectionId!,
                                  tfUsername.text,
                                  tfPassword.text,
                                  tfName.text,
                                  enteredHotelName, // Burada TextField'dan gelen otel adını gönderiyoruz
                                );

                                // Pop-up'ı kapatıyoruz
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => UserListUI(logUser: widget.user, userRole: widget.userRole)),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else {
                    context.read<UserSubmitCubit>().submit(
                      selectedRoleId!, // Seçilen role_id'yi gönderiyoruz
                      selectedSectionId!,
                      tfUsername.text,
                      tfPassword.text,
                      tfName.text,
                      widget.user.hotel,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UserListUI(logUser: widget.user, userRole: widget.userRole)),
                    );
                  }

                  // Navigate back to the User List UI

                },
                child: const Text("Submit"),
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