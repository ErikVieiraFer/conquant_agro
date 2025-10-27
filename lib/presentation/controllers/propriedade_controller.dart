import 'package:conquant_agro/data/mock/propriedade_mock.dart';
import 'package:conquant_agro/data/models/propriedade.dart';
import 'package:get/get.dart';

class PropriedadeController extends GetxController {
  final RxList<Propriedade> propriedades = <Propriedade>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarPropriedades();
  }

  void carregarPropriedades() {
    propriedades.value = PropriedadeMockData.propriedades;
  }
}
