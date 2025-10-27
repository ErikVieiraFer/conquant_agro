import 'package:conquant_agro/data/mock/pesagem_mock.dart';
import 'package:conquant_agro/data/models/pesagem.dart';
import 'package:get/get.dart';

class PesagemController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Pesagem> pesagens = <Pesagem>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarPesagens();
  }

  void carregarPesagens() {
    pesagens.value = PesagemMockData.pesagens;
  }

  void adicionarPesagem(Pesagem novaPesagem) {
    pesagens.add(novaPesagem);
  }

  void editarPesagem(Pesagem pesagemEditada) {
    final index = pesagens.indexWhere((p) => p.id == pesagemEditada.id);
    if (index != -1) {
      pesagens[index] = pesagemEditada;
    }
  }
}