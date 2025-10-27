import 'package:get/get.dart';
import '../../data/models/movimentacao_gado.dart';
import '../../data/repositories/movimentacao_gado_repository.dart';

class MovimentacaoGadoController extends GetxController {
  final String gadoId;
  final MovimentacaoGadoRepository _repository = MovimentacaoGadoRepository();
  final RxList<MovimentacaoGado> movimentacoesGado = <MovimentacaoGado>[].obs;
  final RxBool isLoading = false.obs;

  MovimentacaoGadoController(this.gadoId);

  @override
  void onInit() {
    super.onInit();
    fetchMovimentacoesGado();
  }

  void fetchMovimentacoesGado() async {
    try {
      isLoading.value = true;
      movimentacoesGado.value = await _repository.getMovimentacoesGado(gadoId);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMovimentacaoGado(MovimentacaoGado movimentacao) async {
    try {
      isLoading.value = true;
      await _repository.addMovimentacaoGado(movimentacao);
      fetchMovimentacoesGado();
    } finally {
      isLoading.value = false;
    }
  }
}
