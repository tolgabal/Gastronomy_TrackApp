import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastrobluecheckapp/color.dart'; // Burada mainColor'ı alıyoruz
import 'package:gastrobluecheckapp/ui/cubit/recassetsubmit_cubit.dart';
import 'package:gastrobluecheckapp/ui/views/receivingui/receivinglistui.dart';
import 'package:intl/intl.dart';

import '../../../data/entity/role.dart';
import '../../../data/entity/user.dart';
import '../../../data/entity/firms.dart'; // Firms sınıfını ekliyoruz
import '../../cubit/firmslist_cubit.dart';
import '../../cubit/userlist_cubit.dart';
import '../../middleware/bottomnavigationbar.dart';
import '../../middleware/temperature_bloc.dart';
import '../homepage.dart'; // UserListCubit'i ekliyoruz

class ReceivingSubmitUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ReceivingSubmitUI(this.user, this.userRole, {super.key});

  @override
  _ReceivingAssetFormState createState() => _ReceivingAssetFormState();
}

class _ReceivingAssetFormState extends State<ReceivingSubmitUI> {
  // Controllers for text fields
  final TextEditingController recDateController = TextEditingController();
  final TextEditingController firmNameController = TextEditingController();
  final TextEditingController assetNameController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController prodDateController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();
  final TextEditingController seriNumController = TextEditingController();
  final TextEditingController fatNumController = TextEditingController();
  final TextEditingController assetQuantController = TextEditingController();
  final TextEditingController carHeatController = TextEditingController();
  final TextEditingController assetHeatController = TextEditingController();
  final TextEditingController personnelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String carHygene = 'Uygun';
  String labelCond = 'Uygun';
  String quantType = 'KG';
  String agreement = 'Kabul';
  int agreementInt = 1;
  int callingPlace = 0;

  String searchQuery = ''; // Arama sorgusunu saklamak için
  String firmIdController = "";

  // Düzgün bir validasyon için bir değişken ekleyelim
  bool isNoteRequired = false;
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            Homepage(user: widget.user, userRole: widget.userRole),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(index);
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<FirmsListCubit>().loadFirms(widget.user.hotel);
    context
        .read<UserListCubit>()
        .loadUsers(widget.user.hotel); // Personel listesini yükle
  }

  // Method to pick date
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReceivingListUI(
                  user: widget.user, userRole: widget.userRole)),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text('Receiving Asset Form'),
        ),
        body: Container(
          color: mainColor, // Arka plan rengi
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSection(
                  title: 'Ürün Bilgileri',
                  child: Column(
                    children: [
                      _buildTextField(assetNameController, 'Ürün Adı'),
                      const SizedBox(height: 5),
                      _buildTextField(brandController, 'Marka'),
                      const SizedBox(height: 5),
                      _buildDatePickerField(
                          prodDateController, 'Üretim Tarihi'),
                      const SizedBox(height: 5),
                      _buildDatePickerField(expDateController, 'SKT'),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(
                                  assetQuantController, 'Ürün Miktarı',
                                  isNumeric: true)), // Asset Quantity

                          SizedBox(width: 50), // Aralık ekleyelim
                          DropdownButton<String>(
                            value: quantType,
                            items: <String>['KG', 'Litre', 'Adet']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                quantType = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _buildTextField(seriNumController, 'Seri Numarası'),
                      const SizedBox(height: 5),
                      _buildTextField(
                          fatNumController, 'Fatura/İrsaliye Numarası'),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(height: 16), // Gruplar arasında boşluk
                _buildSection(
                  title: 'Mal Kabul Bilgileri',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: _buildTextField(
                                  recDateController, 'Kayıt Tarihi',
                                  isReadOnly: true)), // Rec. Date readonly
                          IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              // Anlık tarih ve saati al
                              setState(() {
                                recDateController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime.now());
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _buildFirmDropdown(), // Firm Dropdown
                      const SizedBox(height: 5),
                      _buildPersonnelDropdown(), // Personnel Dropdown
                      const SizedBox(height: 5),

                      _buildRadioField(
                          'Araç Hijyeni', ['Uygun', 'Uygun Değil'], carHygene,
                          (val) {
                        setState(() {
                          carHygene = val!;
                          // Eğer car hygiene uygun değilse, not alanı zorunlu olacak
                          if (carHygene == 'Uygun Değil') {
                            agreement =
                                'Şartlı Kabul'; // Şartlı kabul varsayılan olarak seçili
                          }
                          // Not zorunluluğunu güncelle
                          isNoteRequired = agreement == 'Şartlı Kabul' ||
                              agreement ==
                                  'Red'; // Şartlı kabul veya red seçilmişse not zorunlu
                        });
                      }),
                      _buildRadioField('Label Condition',
                          ['Uygun', 'Uygun Değil'], labelCond, (val) {
                        setState(() {
                          labelCond = val!;
                          // Eğer car hygiene uygun değilse, not alanı zorunlu olacak

                          // Not zorunluluğunu güncelle
                          isNoteRequired = agreement == 'Şartlı Kabul' ||
                              agreement ==
                                  'Red'; // Şartlı kabul veya red seçilmişse not zorunlu
                        });
                      })
                    ],
                  ),
                ),
                SizedBox(height: 16), // Gruplar arasında boşluk
                _buildSection(
                  title: 'Sıcaklık Ölçümleri',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // Alanlar arası boşluğu ayarlamak için
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                carHeatController,
                                'Araç',
                                isNumeric: true,
                                onTap: () {
                                  // Car Heat alanı tıklanınca yapılacaklar
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Car Heat Info'),
                                      content: Text(
                                          'Araç sıcaklığı ile ilgili bilgi.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Kapat'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ), // Car Heat
                            SizedBox(
                                width: 8), // Buton ile alan arasında boşluk
                            ElevatedButton(
                              onPressed: () {
                                callingPlace = 1;
                                // Bluetooth sıcaklık verisini al
                                context
                                    .read<BluetoothCubit>()
                                    .readTemperatureData();

                                // Infrared sıcaklık verisi geldiğinde güncelleniyor
                                final state =
                                    context.read<BluetoothCubit>().state;
                                if (state["temperature"] !=
                                    "Sıcaklık Bekleniyor...") {
                                  setState(() {
                                    carHeatController.text =
                                        state["temperature"]!;
                                  });
                                }
                              },
                              child: Icon(
                                Icons.thermostat,
                                color: Colors.red,
                              ), // Termometre ikonu
                            ),
                            ElevatedButton(
                              onPressed: () {
                                callingPlace = 1;
                                // Bluetooth sıcaklık verisini al
                                context
                                    .read<BluetoothCubit>()
                                    .readInfraredTemperatureData();

                                // Infrared sıcaklık verisi geldiğinde güncelleniyor
                                final state =
                                    context.read<BluetoothCubit>().state;
                                if (state["infrared"] !=
                                    "Infrared Bekleniyor...") {
                                  setState(() {
                                    carHeatController.text = state["infrared"]!;
                                  });
                                }
                              },
                              child: Icon(Icons.thermostat), // Termometre ikonu
                            ),
                          ],
                        ),
                      ), // Car Heat Row
                      SizedBox(width: 16), // Aralık ekleyelim
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                assetHeatController,
                                'Ürün ',
                                isNumeric: true,
                                onTap: () {
                                  // Asset Heat alanı tıklanınca yapılacaklar
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Ürün'),
                                      content: Text(
                                          'Varlık sıcaklığı ile ilgili bilgi.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Kapat'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ), // Asset Heat
                            SizedBox(
                                width: 8), // Buton ile alan arasında boşluk
                            ElevatedButton(
                              onPressed: () {
                                callingPlace = 0;
                                // Bluetooth sıcaklık verisini al
                                context
                                    .read<BluetoothCubit>()
                                    .readTemperatureData();

                                // Infrared sıcaklık verisi geldiğinde güncelleniyor
                                final state =
                                    context.read<BluetoothCubit>().state;
                                if (state["temperature"] !=
                                    "Sıcaklık Bekleniyor...") {
                                  setState(() {
                                    assetHeatController.text =
                                        state["temperature"]!;
                                  });
                                }
                              },
                              child: Icon(Icons.thermostat), // Termometre ikonu
                            ),
                            SizedBox(
                                width: 8), // Buton ile alan arasında boşluk
                            ElevatedButton(
                              onPressed: () {
                                callingPlace = 0;
                                // Bluetooth sıcaklık verisini al
                                context
                                    .read<BluetoothCubit>()
                                    .readInfraredTemperatureData();

                                // Infrared sıcaklık verisi geldiğinde güncelleniyor
                                final state =
                                    context.read<BluetoothCubit>().state;
                                if (state["infrared"] !=
                                    "Infrared Bekleniyor...") {
                                  setState(() {
                                    assetHeatController.text =
                                        state["infrared"]!;
                                  });
                                }
                              },
                              child: const Icon(Icons.thermostat,
                                  color: Colors.red), // Termometre ikonu
                            ),
                          ],
                        ),
                      ), // Asset Heat Row
                    ],
                  ),
                ),
                SizedBox(height: 16), // Gruplar arasında boşluk
                _buildSection(
                  title: 'Mal Kabul Durumu',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildToggleButtons(),
                      _buildTextField(noteController, 'Not',
                          isRequired: isNoteRequired), // Zorunlu alan
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Submit action
                    _submitForm();
                  },
                  child: Text('Kaydet'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    // title parametrelerini kontrol ettik
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: smallWidgetColor, // Grupların iç rengi
        border: Border.all(color: Colors.indigo, width: 0),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8), // Başlık ile içerik arasında boşluk
          child,
        ],
      ),
    );
  }

  Widget _buildFirmDropdown() {
    return GestureDetector(
      onTap: () {
        _showFirmSelectionModal(context);
      },
      child: AbsorbPointer(
        child: TextField(
          controller: firmNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Firma Seçiniz",
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonnelDropdown() {
    return GestureDetector(
      onTap: () {
        _showPersonnelSelectionModal(context);
      },
      child: AbsorbPointer(
        child: TextField(
          controller: personnelController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Eşlik Eden Personel",
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _showFirmSelectionModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 400,
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Arama terimini güncelle
                  });
                  // Arama fonksiyonunu çağır
                  context
                      .read<FirmsListCubit>()
                      .firmSearch(searchQuery, widget.user.hotel);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Firma Ara',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              Expanded(
                child: BlocBuilder<FirmsListCubit, List<Firms>>(
                  builder: (context, firmList) {
                    if (firmList.isEmpty) {
                      return const Center(child: Text("No firm found"));
                    }

                    return ListView.builder(
                      itemCount: firmList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(firmList[index].firm_name ?? ''),
                          onTap: () {
                            setState(() {
                              firmNameController.text =
                                  firmList[index].firm_name ?? '';
                              firmIdController = firmList[index].id ?? '';
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showPersonnelSelectionModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 400,
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Arama terimini güncelle
                  });
                  // Arama fonksiyonunu çağır
                  context
                      .read<UserListCubit>()
                      .search(searchQuery, widget.user.hotel);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Personel Ara',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              Expanded(
                child: BlocBuilder<UserListCubit, List<User>>(
                  builder: (context, userList) {
                    if (userList.isEmpty) {
                      return const Center(
                          child: Text("Personel bulunmamaktadır."));
                    }

                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(userList[index].username ?? ''),
                          onTap: () {
                            setState(() {
                              personnelController.text =
                                  userList[index].username ?? '';
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isReadOnly = false,
    bool isNumeric = false,
    bool isRequired = false,
    VoidCallback? onTap, // onTap parametresi eklendi
  }) {
    return GestureDetector(
      // Tıklama olayını dinlemek için GestureDetector kullandık
      onTap: onTap, // onTap'ı burada kullanıyoruz
      child: SizedBox(
        height: 50,
        width: 300,
        child: TextField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : null, // Sadece sayı girişi
          decoration: InputDecoration(
            labelText: label + (isRequired ? ' *' : ''),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () => _selectDate(context, controller),
      child: AbsorbPointer(
        child: _buildTextField(controller, label),
      ),
    );
  }

  Widget _buildRadioField(String title, List<String> options, String groupValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Row(
          children: options.map((option) {
            return Row(
              children: [
                Radio<String>(
                  value: option,
                  groupValue: groupValue,
                  onChanged: onChanged,
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildToggleButtons() {
    return ToggleButtons(
      isSelected: [
        agreement == 'Kabul',
        agreement == 'Şartlı Kabul',
        agreement == 'Red',
      ],
      onPressed: (int index) {
        setState(() {
          agreement = index == 0
              ? 'Kabul'
              : index == 1
                  ? 'Şartlı Kabul'
                  : 'Red';
          isNoteRequired = agreement == 'Şartlı Kabul' ||
              agreement == 'Red'; // Not zorunluluğunu güncelle
          if (agreement == "Kabul") {
            agreementInt = 1;
          }
          if (agreement == "Şartlı Kabul") {
            agreementInt = 2;
          }
          if (agreement == "Red") {
            agreementInt = 0;
          }
        });
      },
      children: const [
        Padding(padding: EdgeInsets.all(16.0), child: Text('Kabul')),
        Padding(padding: EdgeInsets.all(16.0), child: Text('Şartlı Kabul')),
        Padding(padding: EdgeInsets.all(16.0), child: Text('Red')),
      ],
    );
  }

  void _submitForm() {
    // Form verilerini gönderme işlemi
    int assetQuantity = int.parse(assetQuantController.text);
    print('Form submitted');
    int parsedCarTemperature = int.tryParse(
            carHeatController.text.replaceAll(RegExp(r'[^\d.]'), '')) ??
        0;
    int parsedCarBuffedTemp = int.tryParse(
            assetHeatController.text.replaceAll(RegExp(r'[^\d.]'), '')) ??
        0;

    context.read<RecAssetSubmitCubit>().submit(
        recDateController.text,
        firmIdController,
        assetNameController.text,
        brandController.text,
        prodDateController.text,
        expDateController.text,
        seriNumController.text,
        fatNumController.text,
        carHygene == "uygun" ? 1 : 0,
        labelCond == "uygun" ? 1 : 0,
        assetQuantity,
        quantType,
        parsedCarTemperature,
        parsedCarBuffedTemp,
        agreementInt,
        personnelController.text,
        noteController.text,
        widget.user.hotel,
        widget.user.username);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ReceivingListUI(user: widget.user, userRole: widget.userRole)),
    );
  }
}
