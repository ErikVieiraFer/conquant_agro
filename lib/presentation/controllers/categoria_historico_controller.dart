import 'package:get/get.dart';
import '../../data/models/categoria_historico.dart';
import '../../data/repositories/categoria_historico_repository.dart';

class CategoriaHistoricoController extends GetxController {
  final CategoriaHistoricoRepository _repository = CategoriaHistoricoRepository();
  final RxList<CategoriaHistorico> categoriasHistorico = <CategoriaHistorico>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoriasHistorico();
  }

  void fetchCategoriasHistorico() async {
    try {
      isLoading.value = true;
      categoriasHistorico.value = await _repository.getCategoriasHistorico();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategoriaHistorico(CategoriaHistorico categoria) async {
    try {
      isLoading.value = true;
      await _repository.addCategoriaHistorico(categoria);
      fetchCategoriasHistorico();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategoriaHistorico(CategoriaHistorico categoria) async {
    try {
      isLoading.value = true;
      await _repository.updateCategoriaHistorico(categoria);
      fetchCategoriasHistorico();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategoriaHistorico(String id) async {
    try {
      isLoading.value = true;
      await _repository.deleteCategoriaHistorico(id);
      fetchCategoriasHistorico();
    } finally {
      isLoading.value = false;
    }
  }
}
