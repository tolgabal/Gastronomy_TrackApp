import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/ui/cubit/userlist_cubit.dart';
import 'package:gastrobluecheckapp/ui/cubit/roleconfiglist_cubit.dart';
import 'package:gastrobluecheckapp/ui/middleware/useroperation.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserOperation userOperation = UserOperation();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    context.read<UserListCubit>().loadUsersForLogin();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String username = _usernameController.text.trim(); // Kullanıcı adı boşlukları temizlendi
    String password = _passwordController.text.trim(); // Şifre boşlukları temizlendi
    User nullUser = new User("id", "role_id", "section_id", "username", "password", "name", "hotel");
    Role nullRole = new Role("id", "role_name", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "hotel");

    List<User> users = context.read<UserListCubit>().state;

    // Kullanıcıyı bulmak için daha güvenilir bir yöntem
    User? user = users.firstWhere(
          (user) => user.username == username && user.password == password,
      orElse: () => nullUser, // Eğer kullanıcı bulunamazsa null döner
    );

    if (user != nullUser) {
      await context.read<RoleConfigListCubit>().loadRoles(user.hotel);
      List<Role> roles = context.read<RoleConfigListCubit>().state;

      // Rolü bulmak için daha güvenilir bir yöntem
      Role? role = roles.firstWhere((role) => role.id == user.role_id, orElse: () => nullRole);

      if (role != nullUser) {
        _controller.forward();
        await Future.delayed(Duration(milliseconds: 300));
        userOperation.loginCheck(username, password, context, _passwordController);
      } else {
        _showErrorDialog("Kullanıcı için rol bulunamadı: $username");
      }
    } else {
      _showErrorDialog("Geçersiz kullanıcı adı veya şifre");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hata"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog'u kapat
              },
              child: Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/loginpage_pic.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Image.asset(
                    'assets/images/gastroblue.png',
                    height: 150,
                    width: 300,
                  ),
                  SizedBox(height: 32),
                  _buildTextField(_usernameController, 'Kullanıcı Adı', false),
                  SizedBox(height: 16),
                  _buildTextField(_passwordController, 'Şifre', true),
                  SizedBox(height: 24),
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Text('GİRİŞ YAP', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bigWidgetColor,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool obscure) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        obscureText: obscure,
      ),
    );
  }
}