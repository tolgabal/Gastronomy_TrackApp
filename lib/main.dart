import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:gastrobluecheckapp/ui/cubit/banketinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/banketlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/banketsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/buffedtimesinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/buffedtimeslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/buffedtimessubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldpreassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldpreassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocessinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldprocesssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldroominfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldroomlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/coldroomsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinfectionassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinfectionassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinfectionassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocessinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/disinprocesssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/firmsinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/firmslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/firmssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotpreassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocessinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocesslist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/hotprocesssubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/recassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/recassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/recassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/resonumassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/resonumassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/resonumsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiginfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiglist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfigsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectioninfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/sectionsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/soakingassetinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/soakingassetlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/soakingassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/thawingprocinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/thawingproclist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/thawingprocsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/userinfo_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/userlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/usersubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/middleware/temperature_bloc.dart';
import 'package:gastrobluecheckapp/ui/views/homepage.dart';
import 'package:gastrobluecheckapp/ui/views/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Hata ayıklama için hata mesajını konsola yazdırın
    print("Firebase initialization error: $e");
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle(); // Örnek oluşturma

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user; // Kullanıcı bilgilerini tutmak için
  Role? role; // Kullanıcı rolünü tutmak için
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus(); // Uygulama başlatıldığında oturum durumunu kontrol eder
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Oturum açık mı kontrol et
    });

    if (isLoggedIn) {
      // Oturum açık ise kullanıcı ve rol bilgilerini yükle
      user = await loadUserData(); // Kullanıcı verilerini yükle
      role = await loadUserRole(user?.role_id); // Kullanıcı rolünü yükle
    }
    // Kullanıcı veya rol null ise tekrar güncelleyerek login ekranına yönlendir
    if (user == null || role == null) {
      setState(() {
        isLoggedIn = false; // Oturum kapalı
      });
    }
  }

  Future<User?> loadUserData() async {
    // Kullanıcı verilerini yüklemek için UserListCubit'i kullan
    final userListCubit = context.read<UserListCubit>();
    await userListCubit.loadUsersForLogin();
    List<User> users = userListCubit.state;

    // Kullanıcıyı bul (örneğin, kullanıcı adı veya başka bir kritere göre)
    return users.firstWhere((user) => user.username == "kullanici_adi"); // Kullanıcı adı için orElse ekleyin
  }

  Future<Role?> loadUserRole(String? roleId) async {
    if (roleId == null) return null; // Eğer roleId null ise null döndür
    // Kullanıcı rolünü yüklemek için RoleConfigListCubit'i kullan
    final roleConfigCubit = context.read<RoleConfigListCubit>();
    return await roleConfigCubit.loadRoleByIdForLogin(roleId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HotPreAssetSubmitCubit()),
        BlocProvider(create: (context) => HotPreAssetInfoCubit()),
        BlocProvider(create: (context) => HotPreAssetListCubit()),
        BlocProvider(create: (context) => ColdPreAssetListCubit()),
        BlocProvider(create: (context) => ColdPreAssetInfoCubit()),
        BlocProvider(create: (context) => ColdPreAssetSubmitCubit()),
        BlocProvider(create: (context) => DisinfectionAssetSubmitCubit()),
        BlocProvider(create: (context) => DisinfectionInfoCubit()),
        BlocProvider(create: (context) => DisinfectionAssetListCubit()),
        BlocProvider(create: (context) => FirmsSubmitCubit()),
        BlocProvider(create: (context) => FirmsInfoCubit()),
        BlocProvider(create: (context) => FirmsListCubit()),
        BlocProvider(create: (context) => SoakingAssetListCubit()),
        BlocProvider(create: (context) => SoakingAssetInfoCubit()),
        BlocProvider(create: (context) => SoakingAssetSubmitCubit()),
        BlocProvider(create: (context) => RoleConfigSubmitCubit()),
        BlocProvider(create: (context) => RoleConfigInfoCubit()),
        BlocProvider(create: (context) => RoleConfigListCubit()),
        BlocProvider(create: (context) => UserSubmitCubit()),
        BlocProvider(create: (context) => UserInfoCubit()),
        BlocProvider(create: (context) => UserListCubit()),
        BlocProvider(create: (context) => SectionSubmitCubit()),
        BlocProvider(create: (context) => SectionInfoCubit()),
        BlocProvider(create: (context) => SectionListCubit()),
        BlocProvider(create: (context) => RecAssetlistCubit()),
        BlocProvider(create: (context) => RecAssetSubmitCubit()),
        BlocProvider(create: (context) => RecAssetInfoCubit()),
        BlocProvider(create: (context) => DisinProcessAssetSubmitCubit()),
        BlocProvider(create: (context) => DisinProcessListCubit()),
        BlocProvider(create: (context) => DisinProcessInfoCubit()),
        BlocProvider(create: (context) => HotProcessSubmitCubit()),
        BlocProvider(create: (context) => HotProcessListCubit()),
        BlocProvider(create: (context) => HotProcessInfoCubit()),
        BlocProvider(create: (context) => ThawingProcListCubit()),
        BlocProvider(create: (context) => ThawingProcSubmitCubit()),
        BlocProvider(create: (context) => ThawingProcInfoCubit()),
        BlocProvider(create: (context) => ColdProcessListCubit()),
        BlocProvider(create: (context) => ColdProcessSubmitCubit()),
        BlocProvider(create: (context) => ColdProcessInfoCubit()),
        BlocProvider(create: (context) => BluetoothCubit(widget.flutterReactiveBle,deviceId: "")), // BluetoothCubit'i ekle
        BlocProvider(create: (context) => ColdRoomListCubit()),
        BlocProvider(create: (context) => ColdRoomSubmitCubit()),
        BlocProvider(create: (context) => ColdRoomInfoCubit()),
        BlocProvider(create: (context) => BanketListCubit()),
        BlocProvider(create: (context) => BanketSubmitCubit()),
        BlocProvider(create: (context) => BanketInfoCubit()),
        BlocProvider(create: (context) => BuffedTimesAssetInfoCubit()),
        BlocProvider(create: (context) => BuffedTimesAssetListCubit()),
        BlocProvider(create: (context) => BuffedTimesAssetSubmitCubit()),
        BlocProvider(create: (context) => ResoNumAssetInfoCubit()),
        BlocProvider(create: (context) => ResoNumAssetListCubit()),
        BlocProvider(create: (context) => ResoNumAssetSubmitCubit()),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: isLoggedIn && user != null && role != null ? Homepage(user: user!, userRole: role!) : LoginPage(),
      ),
    );
  }
}