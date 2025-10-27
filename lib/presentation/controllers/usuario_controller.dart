import 'package:conquant_agro/data/mock/usuario_mock.dart';
import 'package:conquant_agro/data/models/usuario.dart';
import 'package:get/get.dart';

class UsuarioController extends GetxController {
  final RxList<Usuario> usuarios = <Usuario>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarUsuarios();
  }

  void carregarUsuarios() {
    usuarios.value = UsuarioMockData.usuarios;
  }
}
