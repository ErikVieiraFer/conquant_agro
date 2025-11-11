import 'package:get/get.dart';
import '../../core/services/api_service.dart';
import '../../data/models/almoxarifado.dart';
import '../../data/models/almoxarifado_entrada.dart';
import '../../data/models/almoxarifado_saida.dart';

class AlmoxarifadoController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Almoxarifado> materiais = <Almoxarifado>[].obs;
  final RxList<AlmoxarifadoEntrada> entradas = <AlmoxarifadoEntrada>[].obs;
  final RxList<AlmoxarifadoSaida> saidas = <AlmoxarifadoSaida>[].obs;
  final RxBool isLoading = false.obs;
  final RxString propriedadeIdAtual = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Carregar propriedade_id do usuário logado (pode vir de um AuthController ou similar)
    // Por enquanto, vou deixar como string vazia, mas na integração real deve ser definido
    propriedadeIdAtual.value = ''; // TODO: Obter do contexto/auth
  }

  // Carregar todos os materiais do almoxarifado
  Future<void> carregarMateriais(String propriedadeId) async {
    try {
      isLoading.value = true;
      propriedadeIdAtual.value = propriedadeId;

      final response = await _apiService.getAlmoxarifado(propriedadeId);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        materiais.value = data.map((json) => Almoxarifado.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar materiais: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Criar novo material
  Future<bool> criarMaterial(Almoxarifado material) async {
    try {
      isLoading.value = true;

      final response = await _apiService.criarAlmoxarifado(material.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        await carregarMateriais(material.propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Material cadastrado com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao criar material: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Atualizar material existente
  Future<bool> atualizarMaterial(Almoxarifado material) async {
    try {
      isLoading.value = true;

      if (material.id == null) return false;

      final response = await _apiService.atualizarAlmoxarifado(
        material.id!,
        material.toJson(),
      );

      if (response.statusCode == 200) {
        await carregarMateriais(material.propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Material atualizado com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao atualizar material: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Deletar material
  Future<bool> deletarMaterial(String id, String propriedadeId) async {
    try {
      isLoading.value = true;

      final response = await _apiService.deletarAlmoxarifado(id);

      if (response.statusCode == 200 || response.statusCode == 204) {
        await carregarMateriais(propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Material removido com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao deletar material: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Carregar entradas de um material específico
  Future<void> carregarEntradas(String propriedadeId, {String? almoxarifadoId}) async {
    try {
      isLoading.value = true;

      final response = await _apiService.getAlmoxarifadoEntradas(
        propriedadeId,
        almoxarifadoId: almoxarifadoId,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        entradas.value = data.map((json) => AlmoxarifadoEntrada.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar entradas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Registrar entrada de material
  Future<bool> registrarEntrada(AlmoxarifadoEntrada entrada) async {
    try {
      isLoading.value = true;

      final response = await _apiService.criarAlmoxarifadoEntrada(entrada.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Recarregar materiais para atualizar estoque
        await carregarMateriais(entrada.propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Entrada registrada com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao registrar entrada: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Carregar saídas de um material específico
  Future<void> carregarSaidas(String propriedadeId, {String? almoxarifadoId}) async {
    try {
      isLoading.value = true;

      final response = await _apiService.getAlmoxarifadoSaidas(
        propriedadeId,
        almoxarifadoId: almoxarifadoId,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        saidas.value = data.map((json) => AlmoxarifadoSaida.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao carregar saídas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Registrar saída de material (PEPS/UEPS é calculado pelo back-end)
  Future<bool> registrarSaida(AlmoxarifadoSaida saida) async {
    try {
      isLoading.value = true;

      final response = await _apiService.criarAlmoxarifadoSaida(saida.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Recarregar materiais para atualizar estoque
        await carregarMateriais(saida.propriedadeId);
        Get.snackbar(
          'Sucesso',
          'Saída registrada com sucesso',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Erro ao registrar saída: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Cálculo de valor total do estoque
  double get valorTotalEstoque {
    return materiais.fold(0.0, (sum, material) {
      return sum + (material.estoqueDisponivel * material.custoMedio);
    });
  }

  // Buscar material por ID
  Almoxarifado? getMaterialById(String id) {
    try {
      return materiais.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}
