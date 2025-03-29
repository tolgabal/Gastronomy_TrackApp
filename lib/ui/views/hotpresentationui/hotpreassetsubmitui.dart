import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/hotpresentationui/hotpreassetlistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';

class HotPreAssetSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const HotPreAssetSubmitUI({required this.user,required this.userRole, Key? key}) : super(key: key);

  @override
  State<HotPreAssetSubmitUI> createState() => _HotPreAssetSubmitUIState();
}

class _HotPreAssetSubmitUIState extends State<HotPreAssetSubmitUI> {
  var tfAssetName = TextEditingController();
  bool isReusable = false;
  int reuseInt = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HotPreAssetListUI(user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text("Ürün Ekleme"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HotPreAssetListUI(user: widget.user, userRole: widget.userRole)),
              );
            },
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
                    hintText: "Ürün Adı",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Tekrar Kullanılabilir mi? : "),
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
                    context.read<HotPreAssetSubmitCubit>().submit(tfAssetName.text, reuseInt, widget.user.hotel);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HotPreAssetListUI(user: widget.user, userRole: widget.userRole)),
                    );
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
