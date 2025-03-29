import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/ui/views/homepage.dart';
import 'package:gastrobluecheckapp/ui/views/loginpage.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/ui/cubit/userlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiglist_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOperation {
  // Kullanıcı giriş kontrolü
  Future<void> loginCheck(
      String username,
      String password,
      BuildContext context,
      TextEditingController passwordController,
      ) async {
    try {
      // Kullanıcı listesini yükle
      await context.read<UserListCubit>().loadUsersForLogin();
      List<User> users = context.read<UserListCubit>().state;

      // Kullanıcıyı bul
      User? user;
      try {
        user = users.firstWhere(
              (user) => user.username == username && user.password == password,
        );
      } catch (e) {
        user = null; // Eğer kullanıcı bulunamazsa null olarak ayarlanır
      }

      if (user != null) {
        // Kullanıcının rolünü yükle
        Role? role = await context
            .read<RoleConfigListCubit>()
            .loadRoleByIdForLogin(user.role_id);

        if (role != null) {
          // Kullanıcı giriş yaptı, durumu kaydet
          await saveLoginState();

          // Giriş başarılı, kullanıcıyı ve rolünü ana sayfaya yönlendir
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Homepage(user: user!, userRole: role),
            ),
          );
        } else {
          _handleLoginError(context, passwordController, 'Rol bulunamadı.');
        }
      } else {
        _handleLoginError(
          context,
          passwordController,
          'Kullanıcı adı veya şifre hatalı.',
        );
      }
    } catch (e) {
      // Herhangi bir hata durumunda gösterilecek mesaj
      _handleLoginError(context, passwordController, 'Bir hata oluştu: $e');
    }
  }

  // Giriş durumu kaydetme
  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Kullanıcının giriş yaptığını kaydediyoruz
  }

  // Kullanıcı giriş durumu kontrolü
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Giriş durumu kontrol ediliyor
  }

  // Hataları yönetmek için yardımcı fonksiyon
  void _handleLoginError(
      BuildContext context,
      TextEditingController controller,
      String errorMessage,
      ) {
    controller.clear(); // Şifreyi temizle
    _showErrorDialog(context, errorMessage); // Hata mesajı göster
  }

  // Hata diyalog penceresi
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: smallWidgetColor,
          title: const Text('Hatalı Giriş'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop(); // Pop-up'ı kapat
              },
            ),
          ],
        );
      },
    );
  }

  // Kullanıcı çıkış işlemi
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Kullanıcı çıkışı kaydediliyor
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
    );
  }
}