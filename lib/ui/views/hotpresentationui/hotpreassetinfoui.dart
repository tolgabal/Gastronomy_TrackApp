import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/hotpresentationasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/hotpresentationui/hotpreassetlistui.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';

class HotPreAssetInfoUI extends StatefulWidget {
  final HotPresentationAsset asset;
  final User user;
  final Role userRole;

  HotPreAssetInfoUI(this.asset, this.user, this.userRole);

  @override
  State<HotPreAssetInfoUI> createState() => _HotPreAssetInfoUIState();
}

class _HotPreAssetInfoUIState extends State<HotPreAssetInfoUI> {
  var tfAssetName = TextEditingController();
  bool isReusable = false;

  @override
  void initState() {
    super.initState();
    var asset = widget.asset;
    tfAssetName.text = asset.asset_name;
    if(asset.reuse_isactive == 1) isReusable = true;
  }

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
        appBar: AppBar(
          title: const Text("Information Page"),
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
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: tfAssetName,
                  decoration: const InputDecoration(hintText: "Asset Name"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Reusable:"),
                    Checkbox(
                      value: isReusable,
                      onChanged: (bool? value) {
                        setState(() {
                          isReusable = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    int reuseInt = isReusable ? 1 : 0;
                    context.read<HotPreAssetInfoCubit>().update(
                      widget.asset.id,
                      tfAssetName.text,
                      reuseInt, // Reusable durumunu gönderiyoruz
                      widget.user.hotel
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HotPreAssetListUI(user: widget.user, userRole: widget.userRole)),
                    );
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
