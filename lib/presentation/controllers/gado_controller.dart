import 'package:get/get.dart';
import '../../core/services/api_service.dart';
import '../../data/models/gado.dart';

class GadoController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Gado> gados = <Gado>[].obs;
  final RxList<String> racas = <String>[].obs;
  final RxList<String> pelagens = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString propriedadeIdAtual = ''.obs;

  @override
  void onInit() {
    super.onInit();
    carregarRacas();
    carregarPelagens();
  }

  // Carregar lista de raças do back-end
  Future<void> carregarRacas() async {
    try {
      final response = await _apiService.getRacas();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        racas.value = data.map((item) => item['nome'] as String).toList();
      }
    } catch (e) {
      // Usar lista padrão em caso de erro
      racas.value = [
        'Nelore',
        'Angus',
        'Brahman',
        'Gir',
        'Guzerá',
        'Tabapuã',
        'Senepol',
        'Brangus',
        'Canchim',
        'Charolês',
        'Hereford',
        'Limousin',
        'Simental',
        'Holandês',
        'Jersey',
        'Girolando',
        'Outra',
      ];
    }
  }

  // Carregar lista de pelagens do back-end
  Future<void> carregarPelagens() async {
    try {
      final response = await _apiService.getPelagens();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        pelagens.value = data.map((item) => item['nome'] as String).toList();
      }
    } catch (e) {
      // Usar lista padrão em caso de erro
      pelagens.value = [
        'Branca',
        'Preta',
        'Vermelha',
        'Amarela',
        'Barrosa',
        'Malhada',
        'Pintada',
        'Parda',
        'Rosilho',
        'Outra',
      ];
    }
  }

  // Carregar todos os gados de uma propriedade
  Future<void> carregarGados(String propriedadeId) async {
    try {
      isLoading.value = true;
      propriedadeIdAtual.value = propriedadeId;

      final response = await _apiService.getGado(propriedadeId);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        gados.value = data.map((json) => Gado.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar gados: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Buscar gado por ID
  Future<Gado?> buscarGadoPorId(String id) async {
    try {
      final response = await _apiService.getGadoById(id);

      if (response.statusCode == 200) {
        return Gado.fromJson(response.data);
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao buscar gado: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Criar novo gado
  Future<bool> criarGado(Gado gado) async {
    try {
      isLoading.value = true;

      final response = await _apiService.criarGado(gado.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        await carregarGados(gado.propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Gado cadastrado com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao cadastrar gado: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Atualizar gado existente
  Future<bool> atualizarGado(Gado gado) async {
    try {
      isLoading.value = true;

      if (gado.id == null) return false;

      final response = await _apiService.atualizarGado(gado.id!, gado.toJson());

      if (response.statusCode == 200) {
        await carregarGados(gado.propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Gado atualizado com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar gado: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Deletar gado
  Future<bool> deletarGado(String id, String propriedadeId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.deletarGado(id);

      if (response.statusCode == 200 || response.statusCode == 204) {
        await carregarGados(propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Gado removido com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao deletar gado: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Métodos auxiliares
  Gado? getGadoById(String id) {
    try {
      return gados.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filtros
  List<Gado> getGadosPorSexo(String sexo) {
    return gados.where((g) => g.sexo == sexo).toList();
  }

  List<Gado> getGadosPorRaca(String raca) {
    return gados.where((g) => g.raca == raca).toList();
  }

  List<Gado> getGadosPorPasto(String pastoId) {
    return gados.where((g) => g.pastoId == pastoId).toList();
  }

  // Métodos para compatibilidade com código antigo
  void fetchGados() {
    if (propriedadeIdAtual.value.isNotEmpty) {
      carregarGados(propriedadeIdAtual.value);
    }
  }

  Future<void> addGado(Gado gado) async {
    await criarGado(gado);
  }

  Future<void> updateGado(Gado gado) async {
    await atualizarGado(gado);
  }
}
