import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/ui/cubit/resonumsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/resonumui/resonumassetlistui.dart';

import '../../../color.dart';
import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';

class ResoNumAssetSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;
  const ResoNumAssetSubmitUI({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  State<ResoNumAssetSubmitUI> createState() => _ResoNumAssetSubmitUIState();
}

class _ResoNumAssetSubmitUIState extends State<ResoNumAssetSubmitUI> {
  var tfAssetName = TextEditingController();

  void navigateToAssetListUI() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResoNumAssetListUI(user: widget.user, userRole: widget.userRole)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigateToAssetListUI();
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Reşo Numara Listesi"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: navigateToAssetListUI,
          ),
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
                    hintText: "Reşo Numarası",
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
                    if (tfAssetName.text.isNotEmpty) {
                      context.read<ResoNumAssetSubmitCubit>().resoNumSubmit(tfAssetName.text, widget.user.hotel);
                      navigateToAssetListUI();
                    }
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
