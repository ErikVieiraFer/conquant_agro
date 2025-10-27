import 'package:get/get.dart';
import '../../data/models/movimentacao.dart';
import '../../data/repositories/movimentacao_repository.dart';

class MovimentacaoController extends GetxController {
  final MovimentacaoRepository _repository = MovimentacaoRepository();
  final RxList<Movimentacao> movimentacoes = <Movimentacao>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovimentacoes();
  }

  void fetchMovimentacoes() async {
    try {
      isLoading.value = true;
      movimentacoes.value = await _repository.getMovimentacoes();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMovimentacao(Movimentacao movimentacao) async {
    try {
      isLoading.value = true;
      await _repository.addMovimentacao(movimentacao);
      fetchMovimentacoes();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMovimentacao(Movimentacao movimentacao) async {
    try {
      isLoading.value = true;
      await _repository.updateMovimentacao(movimentacao);
      fetchMovimentacoes();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMovimentacao(String id) async {
    try {
      isLoading.value = true;
      await _repository.deleteMovimentacao(id);
      fetchMovimentacoes();
    } finally {
      isLoading.value = false;
    }
  }
}
