import 'package:conquant_agro/data/models/pasto.dart';
import 'package:conquant_agro/data/repositories/pasto_repository.dart';
import 'package:get/get.dart';

class PastoController extends GetxController {
  final PastoRepository _repository = PastoRepository();
  final RxList<Pasto> pastos = <Pasto>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPastos();
  }

  void fetchPastos() async {
    try {
      isLoading.value = true;
      pastos.value = await _repository.getPastos();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPasto(Pasto pasto) async {
    try {
      isLoading.value = true;
      await _repository.addPasto(pasto);
      fetchPastos();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePasto(Pasto pasto) async {
    try {
      isLoading.value = true;
      await _repository.updatePasto(pasto);
      fetchPastos();
    } finally {
      isLoading.value = false;
    }
  }
}
