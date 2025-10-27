import 'package:conquant_agro/data/mock/auditoria_mock.dart';
import 'package:conquant_agro/data/models/log.dart';
import 'package:get/get.dart';

class AuditoriaController extends GetxController {
  final RxList<Log> logs = <Log>[].obs;

  @override
  void onInit() {
    super.onInit();
    carregarLogs();
  }

  void carregarLogs() {
    logs.value = AuditoriaMockData.logs.map((log) => Log(
      id: log['id'] as String,
      dataHora: DateTime.parse(log['data_hora'] as String),
      usuarioId: log['usuario_id'] as String,
      tabela: log['tabela'] as String,
      registroId: log['registro_id'] as String,
      acao: log['acao'] as String,
      valorAnterior: log['valor_anterior'] as Map<String, dynamic>?,
      valorNovo: log['valor_novo'] as Map<String, dynamic>?,
    )).toList();
  }
}
