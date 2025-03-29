import 'dart:io';
import 'dart:typed_data'; // Uint8List için gerekli
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_saver/file_saver.dart'; // Dosya kaydetme için eklendi
import 'package:intl/intl.dart'; // Tarih formatlama için gerekli

import '../../data/entity/role.dart';
import '../../data/entity/user.dart';

class ReportUI extends StatefulWidget {
  final User user;
  final Role userRole;

  const ReportUI({
    required this.user,
    required this.userRole,
    super.key,
  });

  @override
  _ReportUIState createState() => _ReportUIState();
}

class _ReportUIState extends State<ReportUI> {
  bool isLoading = false;
  List<Map<String, dynamic>> hotProcFilteredData = [];
  List<Map<String, dynamic>> coldProcFilteredData = [];
  List<Map<String, dynamic>> thawingProcFilteredData = [];
  List<Map<String, dynamic>> disinProcFilteredData = [];
  List<Map<String, dynamic>> recFilteredData = [];
  DateTime? startDate;
  DateTime? endDate;

  // Tarih seçici
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(Duration(days: 1)), // Yarın olarak ayarlandı
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(Duration(days: 7)),
        end: endDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  // Tarihi formatlayan yardımcı fonksiyon
  bool isWithinDateRange(String dateString) {
    DateTime recordDate = DateTime.parse(dateString);
    return (startDate != null && (recordDate.isAfter(startDate!) || recordDate.isAtSameMomentAs(startDate!))) &&
        (endDate != null && (recordDate.isBefore(endDate!) || recordDate.isAtSameMomentAs(endDate!)));
  }

  // Section adlarını Firestore'dan çeken bir fonksiyon oluştur
  Future<String> getSectionNameById(String sectionId) async {
    var sectionDoc = await FirebaseFirestore.instance
        .collection('section')
        .doc(sectionId)
        .get();

    if (sectionDoc.exists) {
      return sectionDoc.data()?['section_name'] ?? 'Unknown';
    } else {
      return 'Unknown';
    }
  }

  Future<String> sampleConverter(int intSample) async {
    String sample = 'Evet';
    if (intSample == 0) sample = 'Hayır';
    return sample;
  }

  Future<void> fetchHotProcAssetData() async {
    CollectionReference hotprocasset = FirebaseFirestore.instance.collection('hotprocasset');
    CollectionReference coldprocasset = FirebaseFirestore.instance.collection("coldprocess");
    CollectionReference thawprocasset = FirebaseFirestore.instance.collection("thawingprocasset");
    CollectionReference disinprocasset = FirebaseFirestore.instance.collection("disinprocasset");
    CollectionReference receivingcasset = FirebaseFirestore.instance.collection("receivingasset");

    // Hotprocasset için hotel filtresi uygulanıyor
    QuerySnapshot hotProcSnapshot;
    try {
      hotProcSnapshot = await hotprocasset.where('hotel', isEqualTo: widget.user.hotel).get();
    } catch (e) {
      print('Hotprocasset sorgusu sırasında hata oluştu: $e');
      return; // Hata durumunda işlemi durdur
    }

    // Hotprocasset için tarih filtresi döngü ile uygulanıyor
    hotProcFilteredData = hotProcSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((item) => isWithinDateRange(item['submit_date']))
        .toList()..sort((a, b) => DateTime.parse(a['submit_date']).compareTo(DateTime.parse(b['submit_date'])));


    // Coldprocasset için hotel filtresi uygulanıyor
    QuerySnapshot coldProcSnapshot;
    try {
      coldProcSnapshot = await coldprocasset.where('hotel', isEqualTo: widget.user.hotel).get();
    } catch (e) {
      print('Coldprocasset sorgusu sırasında hata oluştu: $e');
      return; // Hata durumunda işlemi durdur
    }

    // Coldprocasset için tarih filtresi döngü ile uygulanıyor
    coldProcFilteredData = coldProcSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((item) => isWithinDateRange(item['asset_presentation_time']))
        .toList()..sort((a, b) => DateTime.parse(a['asset_presentation_time']).compareTo(DateTime.parse(b['asset_presentation_time'])));

    QuerySnapshot thawProcSnapshot;
    try {
      thawProcSnapshot = await thawprocasset.where('hotel', isEqualTo: widget.user.hotel).get();
    } catch (e) {
      print('hata oluştu: $e');
      return; // Hata durumunda işlemi durdur
    }

    // Hotprocasset için tarih filtresi döngü ile uygulanıyor
    thawingProcFilteredData = thawProcSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((item) => isWithinDateRange(item['asset_time_one']))
        .toList()
      ..sort((a, b) => DateTime.parse(a['asset_time_one']).compareTo(DateTime.parse(b['asset_time_one'])));

    QuerySnapshot disinProcSnapshot;
    try {
      disinProcSnapshot = await disinprocasset.where('hotel', isEqualTo: widget.user.hotel).get();
    } catch (e) {
      print('hata oluştu: $e');
      return; // Hata durumunda işlemi durdur
    }

    // Hotprocasset için tarih filtresi döngü ile uygulanıyor
    disinProcFilteredData = disinProcSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((item) => isWithinDateRange(item['submit_date']))
        .toList()..sort((a, b) => DateTime.parse(a['submit_date']).compareTo(DateTime.parse(b['submit_date'])));

    QuerySnapshot recSnapshot;
    try {
      recSnapshot = await receivingcasset.where('hotel', isEqualTo: widget.user.hotel).get();
    } catch (e) {
      print('hata oluştu: $e');
      return; // Hata durumunda işlemi durdur
    }

    // Hotprocasset için tarih filtresi döngü ile uygulanıyor
    recFilteredData = recSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((item) => isWithinDateRange(item['rec_date']))
        .toList()..sort((a, b) => DateTime.parse(a['rec_date']).compareTo(DateTime.parse(b['rec_date'])));
  }

  Future<File> createExcel(List<Map<String, dynamic>> hotProcData, List<Map<String, dynamic>> coldProcData, List<Map<String, dynamic>> thawProcData, List<Map<String, dynamic>> disinProcData, List<Map<String, dynamic>> recProcData) async {
    var excel = Excel.createExcel();

    // Sıcak Sunum Raporları sayfasını oluşturuyoruz
    Sheet sheethotproc = excel['Sıcak Sunum Raporları'];
    sheethotproc.appendRow([
      'Bölüm Adı', 'Kullanıcı Adı', 'Yemek Adı', 'Numune Alındı mı?', 'Üretilen Miktar/küvet', 'Banket Arabası', 'Reşo Numarası', 'Pişirme Hazırlama Sıcaklığı',
      'Pişirme- Hazırlama Ürün Merkez Sıcaklığı Ölçüm Zamanı', 'Sıcak Araba & Banket Bekletme 1. Ölçümü', 'Sıcak Banket Bekletme Zamanı', 'Sıcak Araba & Banket Bekletme 2. Ölçümü',
      'Sıcak Banket Bekletme Zamanı 2', 'Büfe Sunum Sıcaklığı 1. Ölçüm', 'Sunum Ölçüm Zamanı 1', 'Büfe Sunum Sıcaklığı 2. Ölçüm', 'Sunum Ölçüm Zamanı 2', 'Büfe Sunum Sıcaklığı 3. Ölçüm',
      'Sunum Ölçüm Zamanı 3', 'İlk Büfe Sonu Durumu', 'Kalan Miktar Küvet', 'Sıcak Sunum Soğutma Başlangıç Sıcaklığı', 'Sıcak Sunum Soğutma Başlangıç Sıcaklığı Ölçüm Zamanı',
      'Sıcak Sunum Soğutma Bitiş Sıcaklığı', 'Sıcak Sunum Soğutma Bitiş Sıcaklığı Ölçüm Zamanı', 'Soğutma Tekrar Isıtma Sıcaklığı', 'Soğutma Tekrar Isıtma Sıcaklığı Ölçüm Zamanı',
      'Sıcak Araba Banket Bekletme 3. Ölçüm', 'Sıcak Banket Bekletme Zamanı 3' , 'Sıcak Araba & Banket Bekletme 4. Ölçümü', 'Sıcak Banket Bekletme Zamanı 4', 'Büfe Sunum Sıcaklığı 4. Ölçüm',
      'Sunum Sıcaklığı Ölçüm Zamanı 4', 'Büfe Sunum Sıcaklığı 5. Ölçümü', 'Sunum Sıcaklığı Ölçüm Zamanı 5', 'Büfe Sunum Sıcaklığı 6. Ölçümü', 'Sunum Sıcaklığı Ölçüm Zamanı 6',
      'Ürün Son Durumu'
    ]);

    for (var item in hotProcData) {
      String sectionName = await getSectionNameById(item['section_name']);
      sheethotproc.appendRow([
        sectionName, item['user_name'], item['asset_name'], item['sample'], item['quantity'], item['banket'], item['reso_num'], item['first_temperature'],
        item['submit_date'], item['banket_temperature_one'], item['banket_date_one'], item['banket_temperature_two'], item['banket_date_two'], item['buffed_temp_one'],
        item['buffed_date_one'], item['buffed_temp_two'], item['buffed_date_two'], item['buffed_temp_three'], item['buffed_date_three'], item['first_buffed_status'], item['process_times'],
        item['cooling_start_temp'], item['cooling_date'], item['cooling_end_temp'], item['cooling_end_date'], item['cooling_reheat_temp'], item['cooling_reheat_date'],
        item['banket_temperature_three'], item['banket_date_three'],  item['banket_temperature_four'], item['banket_date_four'], item['buffed_temp_four'], item['buffed_date_four'],
        item['buffed_temp_five'], item['buffed_date_five'], item['buffed_temp_six'], item['buffed_date_six'],  item['asset_result']
      ]);
    }

    // Soğuk Sunum Raporları sayfasını oluşturuyoruz
    Sheet sheetcoldproc = excel['Soğuk Sunum Raporları'];
    sheetcoldproc.appendRow([
      'BÖLÜM / SECTION ADI','Kullanıcı Adı', 'Yemek Adı', 'Numune Alındı Mı?', 'Üretilen Miktar / Küvet', 'Soğuk Oda', 'Soğuk Büfe Numarası',
      'Pişirme Hazırlama Sıcaklığı', 'Pişirme - Hazırlama Ürün Merkez Sıcaklığı Ölçüm Zamanı', 'Soğuk Sunum Soğutma Başlangıç Sıcaklığı',
      'Soğutma Başlangıç Sıcaklığı Ölçüm Zamanı', 'Soğuk Sunum Soğutma Bitiş Sıcaklığı ', 'Soğutma Bitiş Sıcaklığı Ölçüm Zamanı',
      'Soğuk Odada Bekletme Sıcaklığı 1', 'Soğuk Bekletme Sıcaklığı Ölçüm Zamanı 1', 'Soğuk Odada Bekletme Sıcaklığı 2', 'Soğuk Bekletme Sıcaklığı Ölçüm Zamanı 2',
      'Soğuk Büfe Sunum  Sıcaklığı 1', 'Soğuk Sunum  Sıcaklığı Ölçüm Zamanı 1', 'Soğuk Büfe Sunum Sıcaklığı 2', 'Soğuk Sunum Sıcaklığı Ölçüm Zamanı 2',
      'Soğuk Büfe  Sunum  Sıcaklığı 3', 'Soğuk Sunum  Sıcaklığı Ölçüm Zamanı 3', 'İlk Büfe Sonu Durumu', 'BÜFE SONU KARAR  ÖLÇÜMÜ ',
      'BÜFE SONU KARAR  ÖLÇÜMÜ  ZAMANI', 'Soğuk Odada Bekletme Sıcaklığı 3', 'Soğuk Odada Bekletme Sıcaklığı Zamanı 3', 'Soğuk Odada Bekletme Sıcaklığı 4',
      'Soğuk Odada Bekletme Sıcaklığı Zamanı 4', 'Soğuk Büfe Sunum Sıcaklığı 4', 'Soğuk Sunum Sıcaklığı Ölçüm Zamanı 4', 'Soğuk Büfe Sunum Sıcaklığı 5',
      'Soğuk Sunum  Sıcaklığı Ölçüm Zamanı 5', 'Soğuk Büfe Sunum Sıcaklığı 6', 'Soğuk Sunum  Sıcaklığı Ölçüm Zamanı 6', 'Ürün Son Durumu'
    ]);

    for (var colditem in coldProcData) {
      String sectionName = await getSectionNameById(colditem['section']);
      String sample = await sampleConverter(colditem['sample']);
      sheetcoldproc.appendRow([
        sectionName, colditem['user_name'], colditem['asset_name'], sample, colditem['asset_quantity'],
        colditem['cold_room_name'], colditem['cold_buffed_no'], colditem['asset_presentation_temp'], colditem['asset_presentation_time'],
        colditem['cold_pre_start_temp'], colditem['cold_pre_start_time'], colditem['cold_pre_end_temp'], colditem['cold_pre_end_time'],
        colditem['cold_room_temp_one'], colditem['cold_room_time_one'], colditem['cold_room_temp_two'], colditem['cold_room_time_two'],
        colditem['cold_buffed_temp_one'], colditem['cold_buffed_time_one'], colditem['cold_buffed_temp_two'], colditem['cold_buffed_time_two'],
        colditem['cold_buffed_temp_three'], colditem['cold_buffed_time_three'], colditem['first_buffed_status'], colditem['first_buffed_temp'],
        colditem['first_buffed_time'], colditem['cold_room_temp_three'], colditem['cold_room_time_three'], colditem['cold_room_temp_four'],
        colditem['cold_room_time_four'], colditem['cold_buffed_temp_four'], colditem['cold_buffed_time_four'], colditem['cold_buffed_temp_five'],
        colditem['cold_buffed_time_five'], colditem['cold_buffed_temp_six'], colditem['cold_buffed_time_six'], colditem['asset_status']
      ]);
    }

    Sheet sheetthawproc = excel['Çözündürme Sunum Raporları'];
    sheetthawproc.appendRow([
      'Bölüm Adı', 'Ortam Sıcaklığı', 'Çözündürme Kullanıcı Adı', 'Ürün Durumu', 'Ürün Adı', 'Parti Numarası', 'SKT',
      'Ürün Çözündürme İşleme Başlangıç Kilogramı', 'Ürün Kabul & Çözündürme Başlangıç Ölçümü', 'Çözündürme Başlangıç Ölçüm Zamanı',
      'Çözündürme Ölçümü 1', 'Çözündürme  Ölçüm Zamanı 1', 'Çözündürme Ölçümü  2', 'Çözündürme Sıcaklığı Ölçüm Zamanı 2',
      'Çözündürme Ölçümü  3', 'Çözündürme  Ölçüm Zamanı 3', 'Ürün İşleme Ölçümü', 'Ürün İşleme Ölçüm  Zamanı',
      'Sevk Yeri', 'Sevk Miktarı', 'Ürün İşleniş Şekli', 'Ortam Sıcaklığı Ürün İşleme'
    ]);

    for (var thawitem in thawProcData) { //DOĞUKANLA YAP. NEYİ NEREYE GÖNDERECEĞİMİ BİLEMEDİM
      String sectionName = await getSectionNameById(thawitem['section_name']);
      sheetthawproc.appendRow([
        sectionName, thawitem['asset_env_temp'], thawitem['user_name'], thawitem['asset_result'], thawitem['asset_name'], thawitem['asset_party_no'],
        thawitem['asset_exp_no'], thawitem['asset_quantity'], thawitem['asset_temp_one'], thawitem['asset_time_one'], thawitem['asset_thawing_temp_one'],
        thawitem['asset_thawing_time_one'], thawitem['asset_thawing_temp_two'], thawitem['asset_thawing_time_two'], thawitem['asset_thawing_temp_three'],
        thawitem['asset_thawing_time_three'], thawitem['asset_process_temp'], thawitem['asset_process_time'],
        thawitem['asset_sending_place'], thawitem['asset_sending_quantity'], thawitem['asset_sending_process_type'], thawitem['asset_sending_place_temp'] // Ortam Sıcaklığı Ürün İşleme
      ]);
    }

    Sheet sheetdisinproc = excel['Dezenfeksiyon Sunum Raporları'];
    sheetdisinproc.appendRow([
      'Dezenfeksiyon Kullanıcı Adı', 'Ürün Adı', 'DEZENFEKSİYON TÜRÜ', 'İşlem Zamanı', 'DEZENFEKSİYON SÜRESİ',
      'Ürün Miktarı', 'Kilo/Bağ', 'Sevk Edilen Bölüm', 'SEVK MİKTARI'
    ]);//PROCESS TIME 10 İLE 15 DAKİKA ARASINDAKİ DEĞER---- PROCESS TYPE OZON YA DA SİRKE

    for (var disinitem in disinProcData) {
      String sectionName = await getSectionNameById(disinitem['section']);
      sheetdisinproc.appendRow([
        disinitem['user_name'], disinitem['asset_name'], disinitem['procType'], disinitem['submit_date'],
        disinitem['procTime'], disinitem['piece'], disinitem['piece_type'], sectionName, disinitem['piece']
      ]);}

    Sheet sheetrecproc = excel['Mal Kabul Sunum Raporları'];
    sheetrecproc.appendRow([
      'Section Name', 'Tarih', 'işlemi Yapan', 'Araç Hijyeni Uygunluk', 'Etiket Bilgisi Uygunluk'
          'Araç İçi Sıcaklık', 'Ürün Merkez Sıcaklığı', 'Fatura / İrsaliye No',  'Firma Adı', 'Marka', 'Ürün Adı',
      'Parti/Seri No', 'SKT', 'Mal Kabul Durumu', 'Açıklama', 'Ürün Kabul Miktarı', 'KG/ADET', 'Eşlik Eden Personel', 'Fotoğraflar'
    ]);

    for (var recItem in recProcData) {
      sheetrecproc.appendRow([
        'Mal Kabul', recItem['rec_date'], recItem['username'], recItem['car_hygene'],
        recItem['label_cond'], recItem['car_heat'], recItem['asset_heat'],recItem['fat_num'],recItem['firm_id'] /*buraya id değil isim çekilecek*/, recItem['brand'],
        recItem['asset_name'], recItem['seri_num'], recItem['exp_date'], recItem['agreement'], recItem['note'], recItem['asset_quant'], recItem['quant_type'],
        recItem['personnel']
      ]);}


    // Dosya kaydetme kısmı
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/raporlar.xlsx';
    File excelFile = File(filePath);
    await excelFile.writeAsBytes(excel.encode()!);

    return excelFile;
  }


  Future<void> saveFile(File excelFile) async {
    final Uint8List bytes = await excelFile.readAsBytes(); // Excel dosyasını Uint8List olarak oku
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final String result = await FileSaver.instance.saveFile(
      name: 'gastroblue_checkapp_${widget.user.hotel}_raporları_$formattedDate',
      bytes: bytes,
      ext: 'xlsx',
      mimeType: MimeType.other,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Dosya başarıyla kaydedildi: $result')),
    );
  }

  Future<void> sendEmail(File excelFile) async {
    final Email email = Email(
      body: 'Gastro Blue Check App Raporu ektedir.',
      subject: 'Gastro Blue Check App Raporu',
      recipients: ['tolgabal752@gmail.com'],
      attachmentPaths: [excelFile.path],
      isHTML: false,
    );
    try {
      await FlutterEmailSender.send(email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rapor başarıyla gönderildi!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-posta gönderilirken bir hata oluştu: $error')),
      );
    }
  }

  Future<void> generateAndSendReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      await fetchHotProcAssetData(); // Verileri çek
      if (hotProcFilteredData.isNotEmpty || coldProcFilteredData.isNotEmpty) {
        File excelFile = await createExcel(hotProcFilteredData, coldProcFilteredData, thawingProcFilteredData, disinProcFilteredData, recFilteredData);

        // Dosyayı kaydetme işlemi
        try {
          await saveFile(excelFile);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dosya kaydetme sırasında hata oluştu: $e')),
          );
          return; // Hata durumunda işlemi durdur
        }

        // E-posta gönderme işlemi
        try {
          await sendEmail(excelFile);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('E-posta gönderme sırasında hata oluştu: $e')),
          );
          return; // Hata durumunda işlemi durdur
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rapor başarıyla oluşturulup gönderildi!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hiç veri bulunamadı!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raporlar'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text('Tarih Aralığı Seç'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateAndSendReport,
              child: Text('Raporu Oluştur ve Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}