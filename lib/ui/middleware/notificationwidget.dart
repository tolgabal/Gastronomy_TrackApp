import 'package:flutter/material.dart';
import 'package:gastrobluecheckapp/color.dart';

class NotificationWidget extends StatelessWidget {
  final String notificationText;
  final String? username; // Kullanıcı adı için opsiyonel bir parametre eklendi.

  const NotificationWidget({
    required this.notificationText,
    this.username, // Kullanıcı adı opsiyonel olarak alınıyor.
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // GestureDetector ile dokunma olayları ekleniyor.
      onTap: () {
        if (username != null) {
          showNotification1(username!); // Kullanıcı adı varsa bildirimi göster.
        } else {
          showNotification2(); // Kullanıcı adı yoksa 2. bildirimi göster.
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: bigWidgetColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            notificationText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void showNotification1(String username) {
    print("Bildirim 1: Hoş geldin, $username!"); // Bildirim 1 mesajı
  }

  void showNotification2() {
    print("Bildirim 2: ShotSoftolga"); // Bildirim 2 mesajı
    print("Bildirim 3: @tolgabal_1 & @dogukanuckan"); // Bildirim 3 mesajı
  }

  void showNotification3() {
    print("Bildirim 3: @tolgabal_1 & @dogukanuckan"); // Bildirim 3 mesajı
  }
}