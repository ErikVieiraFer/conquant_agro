import 'package:conquant_agro/data/mock/pesagem_grupo_mock.dart';
import 'package:conquant_agro/data/models/pesagem_grupo.dart';
import 'package:get/get.dart';

class PesagemGrupoController extends GetxController {
  final RxList<PesagemGrupo> pesagensGrupos = <PesagemGrupo>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarPesagensGrupos();
  }

  void carregarPesagensGrupos() {
    pesagensGrupos.value = PesagemGrupoMockData.pesagensGrupos;
  }
}
