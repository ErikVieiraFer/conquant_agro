import 'package:get/get.dart';
import '../../data/models/gado.dart';
import '../../data/repositories/gado_repository.dart';

class GadoController extends GetxController {
  final GadoRepository _repository = GadoRepository();
  final RxList<Gado> gados = <Gado>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGados();
  }

  void fetchGados() async {
    try {
      isLoading.value = true;
      gados.value = await _repository.getGados();
    } finally {
      isLoading.value = false;
    }
  }
}