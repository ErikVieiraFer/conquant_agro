import 'package:get/get.dart';
import '../../data/repositories/manejo_repository.dart';

class ManejoController extends GetxController {
  final ManejoRepository _repository = ManejoRepository();
  final RxBool isLoading = false.obs;

  void fetchMovimentacoes() async {
    try {
      isLoading.value = true;
      await _repository.getMovimentacoes();
    } finally {
      isLoading.value = false;
    }
  }
}