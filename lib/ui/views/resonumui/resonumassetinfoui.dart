import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/data/entity/resonumasset.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/ui/views/resonumui/resonumassetlistui.dart';

import '../../../data/entity/user.dart';
import '../../cubit/resonumassetinfo_cubit.dart';

class ResoNumAssetInfoUI extends StatefulWidget {
  ResoNumAsset asset;
  final User user;
  final Role userRole;
  ResoNumAssetInfoUI(this.asset, this.user, this.userRole);

  @override
  State<ResoNumAssetInfoUI> createState() => _ResoNumAssetInfoUIState();
}

class _ResoNumAssetInfoUIState extends State<ResoNumAssetInfoUI> {
  var tfAssetName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var asset = widget.asset;
    tfAssetName.text = asset.reso_num_name;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResoNumAssetListUI(user: widget.user, userRole: widget.userRole)),
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
                TextField(controller: tfAssetName, decoration: const InputDecoration(hintText: "Asset Name"),),

                ElevatedButton(onPressed: (){
                  context.read<ResoNumAssetInfoCubit>().resoNumUpdate(widget.asset.id, tfAssetName.text, widget.user.hotel);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResoNumAssetListUI(user: widget.user, userRole: widget.userRole)));
                }, child: Text("Güncelle"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
