class AuditoriaMockData {
  static final List<Map<String, dynamic>> logs = [
    {
      'id': '1',
      'data_hora': '2025-10-25T10:00:00Z',
      'usuario_id': '1',
      'tabela': 'GADOS',
      'registro_id': '123',
      'acao': 'UPDATE',
      'valor_anterior': {'categoria_atual': 'Vaca'},
      'valor_novo': {'categoria_atual': 'Vaca prenha'}
    },
    {
      'id': '2',
      'data_hora': '2025-10-25T11:30:00Z',
      'usuario_id': '2',
      'tabela': 'DESPESAS',
      'registro_id': '456',
      'acao': 'INSERT',
      'valor_anterior': null,
      'valor_novo': {'descricao': 'Compra de sal mineral', 'valor': 500.00}
    },
    {
      'id': '3',
      'data_hora': '2025-10-25T14:00:00Z',
      'usuario_id': '1',
      'tabela': 'PASTOS',
      'registro_id': '789',
      'acao': 'UPDATE',
      'valor_anterior': {'status': 'Disponível'},
      'valor_novo': {'status': 'Em uso'}
    },
    {
      'id': '4',
      'data_hora': '2025-10-26T09:00:00Z',
      'usuario_id': '3',
      'tabela': 'USUARIOS',
      'registro_id': '101',
      'acao': 'DELETE',
      'valor_anterior': {'nome': 'Funcionário Antigo', 'ativo': true},
      'valor_novo': null
    },
  ];
}
