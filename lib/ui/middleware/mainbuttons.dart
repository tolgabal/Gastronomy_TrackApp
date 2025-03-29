import 'package:flutter/material.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/resonumasset.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/banketassetui/banketassetlistui.dart';
import 'package:gastrobluecheckapp/ui/views/buffedtimesui/buffedtimesassetlistui.dart';
import 'package:gastrobluecheckapp/ui/views/disinprocessui/disinprocesslistui.dart';
import 'package:gastrobluecheckapp/ui/views/homepage.dart';
import 'package:gastrobluecheckapp/ui/views/hotprocessui/hotprocesslistui.dart';
import 'package:gastrobluecheckapp/ui/views/resonumui/resonumassetlistui.dart';
import 'package:gastrobluecheckapp/ui/views/roleconfigui/roleconfiglistui.dart';
import 'package:gastrobluecheckapp/ui/views/sectionui/sectionlistui.dart';
import 'package:gastrobluecheckapp/ui/views/thawingprocui/thawingproclistui.dart';
import 'package:gastrobluecheckapp/ui/views/updateuserui.dart';

import '../../data/entity/role.dart';
import '../../data/entity/user.dart';
import '../views/coldpresentationui/coldpreassetlistui.dart';
import '../views/coldprocessui/coldprocesslistui.dart';
import '../views/coldroomassetui/coldroomassetlistui.dart';
import '../views/devicesui.dart';
import '../views/disinfectionui/disinfectionassetlistui.dart';
import '../views/firmsui/firmslistui.dart';
import '../views/hotpresentationui/hotpreassetlistui.dart';
import '../views/receivingui/receivinglistui.dart';
import '../views/reportsui.dart';
import '../views/soakingui/soakingassetlistui.dart';
import '../views/userui/userlistui.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final IconData icon;
  final int id;
  final User user;
  final Role userRole;

  CustomButton({
    required this.text,
    required this.height,
    required this.icon,
    required this.id,
    required this.user,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if( id == 1 ){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HotProcessListUI(user: user, userRole: userRole)));
        }else if (id == 2){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ColdProcessListUI(user: user, userRole: userRole)));
        }else if (id == 3){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DisinProcessListUI(user: user, userRole: userRole)));
        }else if (id == 4){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ThawingProcListUI(user: user, userRole: userRole)));
        }else if (id == 6){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivingListUI(user: user, userRole: userRole)));
        }else if (id == 7){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Disinfectionassetlistui(user: user, userRole: userRole)));
        }else if (id == 8){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SoakingAssetListUI(user: user, userRole: userRole)));
        }else if (id == 9){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HotPreAssetListUI(user: user, userRole: userRole)));
        }else if (id == 10){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ColdPreAssetListUI(user: user, userRole: userRole)));
        }else if (id == 11){
          Navigator.push(context, MaterialPageRoute(builder: (context) => FirmsListUI(user: user, userRole: userRole)));
        }else if (id == 12){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserListUI(logUser: user, userRole: userRole)));
        }else if (id == 13){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  BuffedTimesAssetListUI(user: user, userRole: userRole)));
        }else if (id == 14){
          Navigator.push(context, MaterialPageRoute(builder: (context) => RoleConfigListUI(user: user, userRole: userRole)));
        }else if (id == 15){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SectionListUI(user: user, userRole: userRole)));
        }else if (id == 16){
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReportUI(user: user, userRole: userRole)));
        }else if (id == 17){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceScanScreen(user, userRole)));
        }else if (id == 18){
          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserUI(user, user, userRole)));
        }else if (id == 19){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BanketAssetListUI(user: user, userRole: userRole)));
        }else if (id == 20){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ColdRoomAssetListUI(user: user, userRole: userRole)));
        }else if (id == 21){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ResoNumAssetListUI(user: user, userRole: userRole)));
        }




      },
      child: Card(
        color: smallWidgetColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Yuvarlak köşeler
        ),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 40,color: mainColor,), // Sol üst köşedeki ikon
                Spacer(),
                Text(
                  text.toUpperCase(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.arrow_forward,color: mainColor,), // Ok simgesi
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}