
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.example.com', // Placeholder
            connectTimeout: const Duration(milliseconds: 5000),
            receiveTimeout: const Duration(milliseconds: 3000),
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException {
      // Tratar erros de Dio aqui
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException {
      rethrow;
    }
  }

  // Endpoints de Conciliação
  Future<Response> getConciliacao(String propriedadeId, int mes, int ano) {
    return get('/api/conciliacao/$propriedadeId/$mes/$ano');
  }

  Future<Response> criarConciliacao(Map<String, dynamic> data) {
    return post('/api/conciliacao', data: data);
  }

  Future<Response> atualizarConciliacao(String id, Map<String, dynamic> data) {
    return put('/api/conciliacao/$id', data: data);
  }

  // Endpoints de Extrato, Despesas e Notas Fiscais
  Future<Response> getExtrato(String propriedadeId, {required int mes, required int ano}) {
    return get('/api/extrato/$propriedadeId', queryParameters: {'mes': mes, 'ano': ano});
  }

  Future<Response> getDespesas(String propriedadeId, {required int mes, required int ano}) {
    return get('/api/despesas/$propriedadeId', queryParameters: {'mes': mes, 'ano': ano});
  }

  Future<Response> getNotasFiscais(String propriedadeId, {required int mes, required int ano}) {
    return get('/api/notas-fiscais/$propriedadeId', queryParameters: {'mes': mes, 'ano': ano});
  }

  // Endpoints de Vínculos
  Future<Response> criarVinculo(Map<String, dynamic> data) {
    return post('/api/vinculos', data: data);
  }

  Future<Response> deletarVinculo(String id) {
    return delete('/api/vinculos/$id');
  }

  Future<Response> getVinculos(String conciliacaoId) {
    return get('/api/vinculos/$conciliacaoId');
  }

  // Endpoint de Status de Nota Fiscal
  Future<Response> atualizarStatusNotaFiscal(String id, int status) {
    return put('/api/notas-fiscais/$id/status', data: {'status': status});
  }

  // Endpoints de Almoxarifado
  Future<Response> getAlmoxarifado(String propriedadeId) async {
    try {
      return await get('/api/almoxarifado/$propriedadeId');
    } on DioException {
      // Em caso de erro (ex: API offline), retorna dados mockados
      final mockData = [
        {
          'id': '1',
          'propriedade_id': propriedadeId,
          'nome': 'Sal Mineral 60',
          'descricao': 'Sal mineral para bovinos de corte em fase de cria',
          'unidade': 'Saca 25kg',
          'sistema': 'PEPS',
          'estoque_disponivel': 50.0,
          'custo_medio': 85.50,
        },
        {
          'id': '2',
          'propriedade_id': propriedadeId,
          'nome': 'Ração Crescimento',
          'descricao': 'Ração para bezerros em fase de crescimento',
          'unidade': 'Saca 40kg',
          'sistema': 'PEPS',
          'estoque_disponivel': 120.0,
          'custo_medio': 110.00,
        },
        {
          'id': '3',
          'propriedade_id': propriedadeId,
          'nome': 'Vacina Febre Aftosa',
          'descricao': 'Dose de 2ml por animal',
          'unidade': 'Frasco 50ml',
          'sistema': 'PEPS',
          'estoque_disponivel': 15.0,
          'custo_medio': 45.75,
        },
      ];
      return Response(
        data: mockData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/almoxarifado/$propriedadeId'),
      );
    }
  }

  Future<Response> criarAlmoxarifado(Map<String, dynamic> data) {
    return post('/api/almoxarifado', data: data);
  }

  Future<Response> atualizarAlmoxarifado(String id, Map<String, dynamic> data) {
    return put('/api/almoxarifado/$id', data: data);
  }

  Future<Response> deletarAlmoxarifado(String id) {
    return delete('/api/almoxarifado/$id');
  }

  // Endpoints de Entradas
  Future<Response> getAlmoxarifadoEntradas(String propriedadeId, {String? almoxarifadoId}) {
    return get('/api/almoxarifado-entradas/$propriedadeId',
        queryParameters: almoxarifadoId != null ? {'almoxarifado_id': almoxarifadoId} : null);
  }

  Future<Response> criarAlmoxarifadoEntrada(Map<String, dynamic> data) {
    return post('/api/almoxarifado-entradas', data: data);
  }

  Future<Response> atualizarAlmoxarifadoEntrada(String id, Map<String, dynamic> data) {
    return put('/api/almoxarifado-entradas/$id', data: data);
  }

  // Endpoints de Saídas
  Future<Response> getAlmoxarifadoSaidas(String propriedadeId, {String? almoxarifadoId}) {
    return get('/api/almoxarifado-saidas/$propriedadeId',
        queryParameters: almoxarifadoId != null ? {'almoxarifado_id': almoxarifadoId} : null);
  }

  Future<Response> criarAlmoxarifadoSaida(Map<String, dynamic> data) {
    return post('/api/almoxarifado-saidas', data: data);
  }

  // Endpoints de Gado
  Future<Response> getGado(String propriedadeId) async {
    try {
      return await get('/api/gado/$propriedadeId');
    } on DioException {
      final mockData = [
        {
          'id': 'g1',
          'propriedade_id': propriedadeId,
          'id_usual': '101',
          'raca': 'Nelore',
          'sexo': 'Fêmea',
          'pelagem': 'Branca',
          'data_nascimento': DateTime.now().subtract(const Duration(days: 365 * 2)).toIso8601String(),
        },
        {
          'id': 'g2',
          'propriedade_id': propriedadeId,
          'id_usual': '102',
          'raca': 'Angus',
          'sexo': 'Macho',
          'pelagem': 'Preta',
          'data_nascimento': DateTime.now().subtract(const Duration(days: 365 * 1)).toIso8601String(),
        },
      ];
      return Response(
        data: mockData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/gado/$propriedadeId'),
      );
    }
  }

  Future<Response> getGadoById(String id) {
    return get('/api/gado/$id');
  }

  Future<Response> criarGado(Map<String, dynamic> data) {
    return post('/api/gado', data: data);
  }

  Future<Response> atualizarGado(String id, Map<String, dynamic> data) {
    return put('/api/gado/$id', data: data);
  }

  Future<Response> deletarGado(String id) {
    return delete('/api/gado/$id');
  }

  // Endpoints auxiliares para Gado
  Future<Response> getRacas() async {
    try {
      return await get('/api/racas');
    } on DioException {
      final mockData = [
        {'nome': 'Nelore'},
        {'nome': 'Angus'},
        {'nome': 'Brahman'},
        {'nome': 'Girolando'},
        {'nome': 'Holandês'},
      ];
      return Response(
        data: mockData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/racas'),
      );
    }
  }

  Future<Response> getPelagens() async {
    try {
      return await get('/api/pelagens');
    } on DioException {
      final mockData = [
        {'nome': 'Branca'},
        {'nome': 'Preta'},
        {'nome': 'Amarela'},
        {'nome': 'Vermelha'},
        {'nome': 'Pampa'},
      ];
      return Response(
        data: mockData,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/pelagens'),
      );
    }
  }
}
