
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothService extends GetxService {
  final RxBool isScanning = false.obs;
  final RxList<ScanResult> scanResults = <ScanResult>[].obs;
  StreamSubscription? _scanSubscription;

  Future<void> startScan() async {
    isScanning.value = true;
    scanResults.clear();

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      scanResults.value = results;
    });

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    isScanning.value = false;
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    isScanning.value = false;
  }

  @override
  void onClose() {
    stopScan();
    super.onClose();
  }
}
