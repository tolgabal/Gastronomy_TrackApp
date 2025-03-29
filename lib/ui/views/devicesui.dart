import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:convert/convert.dart';
import 'package:gastrobluecheckapp/color.dart';

import '../../data/entity/role.dart';
import '../../data/entity/user.dart';
import '../middleware/temperature_bloc.dart';

class DeviceScanScreen extends StatefulWidget {
  final User user;
  final Role userRole;

  DeviceScanScreen(this.user, this.userRole);

  @override
  DeviceScanScreenState createState() => DeviceScanScreenState();
}

class DeviceScanScreenState extends State<DeviceScanScreen> {
  final flutterReactiveBle = FlutterReactiveBle();
  late StreamSubscription<DiscoveredDevice> scanSubscription;
  List<DiscoveredDevice> devices = [];
  bool isScanning = false;
  String temperature = "Sıcaklık Bekleniyor...";
  String infraredTemperature = "Infrared Bekleniyor...";
  TextEditingController tempController = TextEditingController();
  TextEditingController infraredTempController = TextEditingController();
  String currentDeviceId = "";

  final serviceId = Uuid.parse('45544942-4c55-4554-4845-524db87ad700');
  final characteristicIdSensor1 = Uuid.parse('45544942-4c55-4554-4845-524db87ad701');
  final characteristicIdSensor2 = Uuid.parse('45544942-4c55-4554-4845-524db87ad703'); // Infrared karakteristik ID'si

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    setState(() {
      isScanning = true;
    });

    scanSubscription = flutterReactiveBle.scanForDevices(
      withServices: [],
      scanMode: ScanMode.balanced,
    ).listen((device) {
      setState(() {
        if (device.name.isNotEmpty && !devices.any((d) => d.id == device.id)) {
          devices.add(device);
        }
      });
    }, onError: (error) {
      print('Scan error: $error');
    }, onDone: () {
      setState(() {
        isScanning = false;
      });
    });
  }

  void connectToDevice(String deviceId) {
    flutterReactiveBle.connectToDevice(id: deviceId).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        print('Connected to device $deviceId');
        currentDeviceId = deviceId;
        context.read<BluetoothCubit>().deviceId = deviceId;
        discoverServices(deviceId);
      } else if (connectionState.connectionState == DeviceConnectionState.disconnected) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Bağlantı Kesildi'),
              content: Text('Cihaz ile bağlantı kesildi.'),
              actions: [
                TextButton(
                  child: Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }, onError: (error) {
      print('Connection error: $error');
    });
  }

  void discoverServices(String deviceId) {
    flutterReactiveBle.discoverServices(deviceId).then((services) {
      for (var service in services) {
        print('Discovered service: ${service.serviceId}');
        if (service.serviceId == serviceId) {
          print("İlgili servis bulundu. Sıcaklık verisi okunacak.");
          readTemperatureData(deviceId);
          readInfraredTemperatureData(deviceId); // Infrared verisini oku
        }
      }
    }).catchError((error) {
      print('Error discovering services: $error');
    });
  }

  void readTemperatureData(String deviceId) {
    flutterReactiveBle.readCharacteristic(
      QualifiedCharacteristic(
        serviceId: serviceId,
        characteristicId: characteristicIdSensor1,
        deviceId: deviceId,
      ),
    ).then((data) {
      setState(() {
        temperature = parseTemperatureData(data);
        tempController.text = temperature;
        print("Okunan sıcaklık: $temperature");
      });
    }).catchError((error) {
      print('Error reading characteristic: $error');
    });
  }

  void readInfraredTemperatureData(String deviceId) {
    flutterReactiveBle.readCharacteristic(
      QualifiedCharacteristic(
        serviceId: serviceId,
        characteristicId: characteristicIdSensor2,
        deviceId: deviceId,
      ),
    ).then((data) {
      print('Okunan infrared veri: $data'); // Gelen ham veriyi yazdır
      setState(() {
        infraredTemperature = parseInfraredTemperatureData(data);
        infraredTempController.text = infraredTemperature;
        print("Okunan infrared sıcaklık: $infraredTemperature");
      });
    }).catchError((error) {
      print('Error reading infrared characteristic: $error');
    });
  }

  String parseTemperatureData(List<int> rawData) {
    if (rawData.length == 4) {
      try {
        final byteData = ByteData.sublistView(Uint8List.fromList(rawData));
        final floatValue = byteData.getFloat32(0, Endian.little);
        if (floatValue.isNaN || floatValue == double.infinity || floatValue == double.negativeInfinity) {
          return "Sensör Hatası";
        } else {
          return floatValue.toStringAsFixed(2) + " °C";
        }
      } catch (e) {
        return "Veri Çözümleme Hatası";
      }
    } else {
      return "Geçersiz Veri";
    }
  }

  String parseInfraredTemperatureData(List<int> rawData) {
    // Veriyi logla
    print('Raw infrared data: $rawData'); // Gelen ham veriyi yazdır
    if (rawData.length == 4) {
      try {
        // Little-endian formatında float değeri oku
        final byteData = ByteData.sublistView(Uint8List.fromList(rawData));
        final floatValue = byteData.getFloat32(0, Endian.little);
        // Hatalı sıcaklık değerlerini kontrol et
        if (floatValue.isNaN || floatValue == double.infinity || floatValue == double.negativeInfinity) {
          return "Sensör Hatası";
        } else {
          return floatValue.toStringAsFixed(2) + " °C";
        }
      } catch (e) {
        return "Veri Çözümleme Hatası: $e";
      }
    } else {
      return "Geçersiz Veri - Boyut: ${rawData.length}"; // Hata mesajını güncelle
    }
  }



  @override
  void dispose() {
    scanSubscription.cancel();
    tempController.dispose();
    infraredTempController.dispose(); // Infrared TextField için controller'ı temizle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cihaz Taraması', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isScanning)
              Center(child: CircularProgressIndicator()), // Yükleme göstergesi
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text(device.name.isNotEmpty ? device.name : 'Bilinmeyen Cihaz'),
                      subtitle: Text(device.id),
                      trailing: ElevatedButton(
                        onPressed: () => connectToDevice(device.id),  // Her cihaz için bağlantı
                        child: Text('Bağlan'),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Sıcaklık Bilgisi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: tempController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Sıcaklık (°C)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: infraredTempController, // Infrared sıcaklık için yeni TextField
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Infrared Sıcaklık (°C)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Infrared veriyi oku
                      readInfraredTemperatureData(currentDeviceId); // currentDeviceId, bağlı cihazın ID'si olmalı
                    },
                    child: Text('Infrared Sıcaklığı Oku'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isScanning) {
            startScan();
          }
        },
        child: Icon(Icons.search),
      ),
    );
  }
}