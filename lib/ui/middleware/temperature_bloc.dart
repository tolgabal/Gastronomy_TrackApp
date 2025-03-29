import 'dart:typed_data' as typed_data;
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothCubit extends Cubit<Map<String, String>> {
  final FlutterReactiveBle flutterReactiveBle;
  late String deviceId; // Cihaz ID'si burada saklanacak
  final Uuid serviceId = Uuid.parse('45544942-4c55-4554-4845-524db87ad700');
  final Uuid characteristicIdSensor1 = Uuid.parse('45544942-4c55-4554-4845-524db87ad701');
  final Uuid characteristicIdInfrared = Uuid.parse('45544942-4c55-4554-4845-524db87ad703'); // Infrared karakteristik ID'si

  BluetoothCubit(this.flutterReactiveBle, {required this.deviceId}) : super({"temperature": "Sıcaklık Bekleniyor...", "infrared": "Infrared Bekleniyor..."});

  void readTemperatureData() {
    flutterReactiveBle.readCharacteristic(
      QualifiedCharacteristic(
        serviceId: serviceId,
        characteristicId: characteristicIdSensor1,
        deviceId: deviceId,
      ),
    ).then((data) {
      String temperature = _parseTemperatureData(data);
      emit({"temperature": temperature, "infrared": state["infrared"]!}); // Sıcaklık güncellendi
    }).catchError((error) {
      emit({"temperature": "Veri okunamadı: $error", "infrared": state["infrared"]!});
    });
  }

  void readInfraredTemperatureData() {
    flutterReactiveBle.readCharacteristic(
      QualifiedCharacteristic(
        serviceId: serviceId,
        characteristicId: characteristicIdInfrared,
        deviceId: deviceId,
      ),
    ).then((data) {
      String infraredTemperature = _parseInfraredTemperatureData(data);
      emit({"temperature": state["temperature"]!, "infrared": infraredTemperature}); // Infrared sıcaklık güncellendi
    }).catchError((error) {
      emit({"temperature": state["temperature"]!, "infrared": "Veri okunamadı: $error"});
    });
  }

  String _parseTemperatureData(List<int> rawData) {
    if (rawData.length == 4) {
      try {
        // Uint8List'i ByteData'ya çevir
        final byteData = typed_data.ByteData.sublistView(typed_data.Uint8List.fromList(rawData));

        // Float32 türünde veriyi küçük endian olarak al
        final floatValue = byteData.getFloat32(0, Endian.little);

        // NaN veya sonsuzluk kontrolü yap
        if (floatValue.isNaN || floatValue == double.infinity || floatValue == double.negativeInfinity) {
          return "Sensör Hatası";
        } else {
          return floatValue.toStringAsFixed(2);
        }
      } catch (e) {
        return "Veri Çözümleme Hatası";
      }
    } else {
      return "Geçersiz Veri";
    }
  }

  String _parseInfraredTemperatureData(List<int> rawData) {
    if (rawData.length == 4) {
      try {
        // Uint8List'i ByteData'ya çevir
        final byteData = typed_data.ByteData.sublistView(typed_data.Uint8List.fromList(rawData));

        // Float32 türünde veriyi küçük endian olarak al
        final floatValue = byteData.getFloat32(0, Endian.little);

        // NaN veya sonsuzluk kontrolü yap
        if (floatValue.isNaN || floatValue == double.infinity || floatValue == double.negativeInfinity) {
          return "Sensör Hatası";
        } else {
          return floatValue.toStringAsFixed(2);
        }
      } catch (e) {
        return "Veri Çözümleme Hatası: $e";
      }
    } else {
      return "Geçersiz Veri - Boyut: ${rawData.length}";
    }
  }
}