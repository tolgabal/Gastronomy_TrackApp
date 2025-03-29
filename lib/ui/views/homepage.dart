import 'package:flutter/material.dart';
import 'package:gastrobluecheckapp/color.dart';
import 'package:gastrobluecheckapp/data/entity/role.dart';
import 'package:gastrobluecheckapp/data/entity/user.dart';
import 'package:gastrobluecheckapp/ui/middleware/mainbuttons.dart';
import 'package:gastrobluecheckapp/ui/middleware/useroperation.dart';
import '../middleware/bottomnavigationbar.dart';
import '../middleware/notificationwidget.dart'; // NotificationWidget sınıfı dahil edildi
import 'package:gastrobluecheckapp/ui/views/hotpresentationui/hotpreassetinfoui.dart';
class Homepage extends StatefulWidget {
  final User user; // Kullanıcı adını alacak
  final Role userRole;

  const Homepage({required this.user, required this.userRole, Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  int _showButton = 0;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final PageController _pageController = PageController(); // PageController oluşturuldu

  final NotificationWidget _notificationWidget = NotificationWidget(notificationText: ""); // NotificationWidget nesnesi

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showButton = index;
    });
    _pageController.jumpToPage(index); // Seçilen sayfaya geçiş yap
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index; // Kaydırarak geçiş yapılan sayfanın indeksini güncelle
    });
  }

  void _logout() {
    UserOperation().logout(context); // Logout işlemi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "GASTROBLUE CHECK APP",
          style: TextStyle(
            color: smallWidgetColor,
            fontFamily: "bebasNeue",
            fontSize: 32,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Çıkış yap butonuna tıklandığında logout çağrılır
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: SizedBox(
              height: 130,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Bildirim 1 - Hoş geldin mesajı (kullanıcı adıyla birlikte)
                  GestureDetector(
                    onTap: () {
                      _notificationWidget.showNotification1(widget.user.username);
                    },
                    child: NotificationWidget(notificationText: "Hoş geldin, ${widget.user.username}!"),
                  ),

                  // Bildirim 2 - showNotification2 fonksiyonu çağrılır
                  GestureDetector(
                    onTap: () {
                      _notificationWidget.showNotification2();
                    },
                    child: NotificationWidget(notificationText: "Bildirim 2: Toplantı hatırlatıcısı!"),
                  ),


                ],
              ),
            ),
          ),

          // Kaydırılabilir butonlar alanı
          Expanded(
            child: PageView(
              controller: _pageController, // PageController burada kullanılıyor
              onPageChanged: _onPageChanged, // Sayfa değiştiğinde çağrılacak
              children: [
                // İlk sayfa butonları
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      if(widget.userRole.hotpre == 1)
                      CustomButton(text: "Sıcak Sunum", height: 60, icon: Icons.local_fire_department,id: 1, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.coldpre == 1)
                      CustomButton(text: "Soğuk Sunum", height: 80, icon: Icons.icecream,id: 2, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.disinf == 1)
                      CustomButton(text: "Dezenfeksiyon", height: 70, icon: Icons.cleaning_services,id: 3, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.soak == 1)
                      CustomButton(text: "Çözündürme & Et İşleme", height: 60, icon: Icons.local_drink,id: 4, user: widget.user, userRole: widget.userRole),

                      if(widget.userRole.receiving == 1)
                      CustomButton(text: "Mal Kabul", height: 75, icon: Icons.check_circle,id: 6, user: widget.user, userRole: widget.userRole),
                    ],
                  ),
                ),
                // İkinci sayfa butonları
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      if(widget.userRole.disinf_list == 1)
                      CustomButton(text: "Dezenfeksiyon Ürün Listesi", height: 60, icon: Icons.list_alt,id: 7, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.candr_list == 1)
                      CustomButton(text: "Çözündürme & Et İşleme Ürün Listesi", height: 80, icon: Icons.list,id: 8, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.hotpre_list == 1)
                      CustomButton(text: "Sıcak Sunum Ürün Listesi", height: 70, icon: Icons.local_fire_department,id: 9, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.coldpre_list == 1)
                      CustomButton(text: "Soğuk Sunum Ürün Listesi", height: 60, icon: Icons.icecream,id: 10, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.receiving_firms == 1)
                      CustomButton(text: "Mal Kabul Firma Listesi", height: 75, icon: Icons.business,id: 11, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.hotpre_list == 1)
                        CustomButton(text: "Banket Arabası Listesi", height: 75, icon: Icons.car_rental,id: 19, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.receiving_firms == 1)
                        CustomButton(text: "Soğuk Oda Listesi", height: 75, icon: Icons.severe_cold_sharp,id: 20, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.hotpre_list == 1)
                        CustomButton(text: "Reso Numaraları", height: 75, icon: Icons.severe_cold_sharp,id: 21, user: widget.user, userRole: widget.userRole),

                    ],
                  ),
                ),
                // Üçüncü sayfa butonları
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      if(widget.userRole.personnel == 1)
                      CustomButton(text: "Personel Ekleme/Güncelleme", height: 70, icon: Icons.people,id: 12, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.buffedtimes == 1)
                      CustomButton(text: "Büfe Zamanları", height: 80, icon: Icons.access_time,id: 13, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.roleconfig == 1)
                      CustomButton(text: "Rol Ekleme/Güncelleme.", height: 60, icon: Icons.security,id: 14, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.personnel == 1)
                      CustomButton(text: "Bölümler", height: 70, icon: Icons.people,id: 15, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.reports == 1)
                      CustomButton(text: "Raporlar", height: 75, icon: Icons.report,id: 16, user: widget.user, userRole: widget.userRole),
                    ],
                  ),
                ),
                // Dördüncü sayfa butonları
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      if(widget.userRole.devices == 1)
                      CustomButton(text: "Cihazlar", height: 70, icon: Icons.device_hub,id: 17, user: widget.user, userRole: widget.userRole),
                      if(widget.userRole.updateuser == 1)
                      CustomButton(text: "Kullanıcı Güncelleme", height: 80, icon: Icons.update,id: 18, user: widget.user, userRole: widget.userRole),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Alt gezinme çubuğuna tıklama olayını yönetir
      ),
    );
  }
}