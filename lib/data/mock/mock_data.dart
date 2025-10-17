import '../models/usuario.dart';
import '../models/propriedade.dart';
import '../../core/constants/permissoes.dart';

class MockData {
  // ============================================
  // PROPRIEDADES E USUÁRIOS
  // ============================================
  
  static final propriedade1 = Propriedade(
    id: 'prop1',
    nome: 'Fazenda Santa Helena',
    cnpj: '12.345.678/0001-99',
    endereco: 'Zona Rural, São João da Boa Vista - SP',
  );

  static final propriedade2 = Propriedade(
    id: 'prop2',
    nome: 'Fazenda Boa Esperança',
    cnpj: '98.765.432/0001-11',
    endereco: 'Estrada Municipal, Poços de Caldas - MG',
  );

  static List<Propriedade> get propriedades => [propriedade1, propriedade2];

  static final usuarioMaster = Usuario(
    id: 'user1',
    nome: 'João Silva',
    email: 'joao@conquant.com.br',
    permissao: Permissao.master,
    propriedadeId: 'prop1',
  );

  static final usuarioGerencial = Usuario(
    id: 'user2',
    nome: 'Maria Santos',
    email: 'maria@conquant.com.br',
    permissao: Permissao.gerencial,
    propriedadeId: 'prop1',
  );

  static final usuarioOperacao = Usuario(
    id: 'user3',
    nome: 'Pedro Oliveira',
    email: 'pedro@conquant.com.br',
    permissao: Permissao.operacao,
    propriedadeId: 'prop1',
  );

  static List<Usuario> get usuarios => [
    usuarioMaster,
    usuarioGerencial,
    usuarioOperacao,
  ];

  // ============================================
  // NATUREZAS DE DESPESA
  // ============================================
  
  static final naturezas = [
    {'id': 'nat1', 'nome': 'Salários', 'categoria': 'Pessoal'},
    {'id': 'nat2', 'nome': 'Combustível', 'categoria': 'Operacional'},
    {'id': 'nat3', 'nome': 'Energia Elétrica', 'categoria': 'Operacional'},
    {'id': 'nat4', 'nome': 'Medicamentos', 'categoria': 'Sanidade'},
    {'id': 'nat5', 'nome': 'Ração', 'categoria': 'Alimentação'},
    {'id': 'nat6', 'nome': 'Manutenção', 'categoria': 'Operacional'},
    {'id': 'nat7', 'nome': 'Impostos', 'categoria': 'Tributário'},
  ];

  // ============================================
  // TRANSAÇÕES BANCÁRIAS (EXTRATO)
  // ============================================
  
  static final transacoes = [
    {
      'id': 'trans1',
      'data': '2025-10-08',
      'descricao': 'VENDA DE GADO - FRIGORÍFICO XYZ',
      'valor': 45000.00,
      'tipo': 'RECEITA',
      'conciliado': false,
    },
    {
      'id': 'trans2',
      'data': '2025-10-07',
      'descricao': 'TRANSFERÊNCIA PIX - SUPERMERCADO',
      'valor': -850.50,
      'tipo': 'DESPESA',
      'conciliado': false,
    },
    {
      'id': 'trans3',
      'data': '2025-10-06',
      'descricao': 'COMPRA MASTER CRÉDITO - AGROPECUÁRIA',
      'valor': -3200.00,
      'tipo': 'DESPESA',
      'conciliado': false,
    },
    {
      'id': 'trans4',
      'data': '2025-10-05',
      'descricao': 'SALÁRIO FUNCIONÁRIOS',
      'valor': -12500.00,
      'tipo': 'DESPESA',
      'conciliado': true,
    },
    {
      'id': 'trans5',
      'data': '2025-10-04',
      'descricao': 'ENERGIA ELÉTRICA - CPFL',
      'valor': -1847.92,
      'tipo': 'DESPESA',
      'conciliado': true,
    },
    {
      'id': 'trans6',
      'data': '2025-10-03',
      'descricao': 'COMBUSTÍVEL - POSTO BR',
      'valor': -450.00,
      'tipo': 'DESPESA',
      'conciliado': false,
    },
    {
      'id': 'trans7',
      'data': '2025-10-02',
      'descricao': 'VENDA LEITE - LATICÍNIO ABC',
      'valor': 8500.00,
      'tipo': 'RECEITA',
      'conciliado': true,
    },
    {
      'id': 'trans8',
      'data': '2025-10-01',
      'descricao': 'COMPRA RAÇÃO - AGROCENTER',
      'valor': -5200.00,
      'tipo': 'DESPESA',
      'conciliado': false,
    },
    {
      'id': 'trans9',
      'data': '2025-09-30',
      'descricao': 'MANUTENÇÃO TRATOR',
      'valor': -2100.00,
      'tipo': 'DESPESA',
      'conciliado': true,
    },
    {
      'id': 'trans10',
      'data': '2025-09-29',
      'descricao': 'VENDA BEZERROS',
      'valor': 18000.00,
      'tipo': 'RECEITA',
      'conciliado': false,
    },
  ];

  // ============================================
  // DESPESAS
  // ============================================
  
  static final despesas = [
    {
      'id': 'desp1',
      'data': '2025-10-07',
      'descricao': 'Compra supermercado funcionários',
      'valor': -850.50,
      'natureza': 'Operacional',
      'finalidade': 'CUSTO',
      'conciliado': false,
    },
    {
      'id': 'desp2',
      'data': '2025-10-05',
      'descricao': 'Pagamento salários outubro',
      'valor': -12500.00,
      'natureza': 'Salários',
      'finalidade': 'CUSTO',
      'conciliado': true,
    },
    {
      'id': 'desp3',
      'data': '2025-10-04',
      'descricao': 'Conta de energia fazenda',
      'valor': -1847.92,
      'natureza': 'Energia Elétrica',
      'finalidade': 'CUSTO',
      'conciliado': true,
    },
    {
      'id': 'desp4',
      'data': '2025-10-03',
      'descricao': 'Abastecimento trator e caminhão',
      'valor': -450.00,
      'natureza': 'Combustível',
      'finalidade': 'CUSTO',
      'conciliado': false,
    },
    {
      'id': 'desp5',
      'data': '2025-10-01',
      'descricao': 'Ração 500kg para confinamento',
      'valor': -5200.00,
      'natureza': 'Ração',
      'finalidade': 'ALMOXARIFADO',
      'conciliado': false,
    },
    {
      'id': 'desp6',
      'data': '2025-09-30',
      'descricao': 'Reparo sistema hidráulico trator',
      'valor': -2100.00,
      'natureza': 'Manutenção',
      'finalidade': 'CUSTO',
      'conciliado': true,
    },
    {
      'id': 'desp7',
      'data': '2025-09-28',
      'descricao': 'Medicamentos zoosanitário',
      'valor': -1350.00,
      'natureza': 'Medicamentos',
      'finalidade': 'ALMOXARIFADO',
      'conciliado': false,
    },
    {
      'id': 'desp8',
      'data': '2025-09-25',
      'descricao': 'Impostos municipais',
      'valor': -3200.00,
      'natureza': 'Impostos',
      'finalidade': 'FLUXO_CAIXA',
      'conciliado': true,
    },
  ];

  // ============================================
  // NOTAS FISCAIS
  // ============================================
  
  static final notasFiscais = [
    {
      'id': 'nf1',
      'tipo': 'ENTRADA',
      'numero': '000123',
      'serie': '1',
      'data_emissao': '2025-10-08',
      'valor_total': 45000.00,
      'emitente': 'Fazenda Santa Helena',
      'destinatario': 'Frigorífico XYZ LTDA',
      'cnpj_destinatario': '11.222.333/0001-44',
      'chave_acesso': '35251011222333000144550010001230001234567890',
    },
    {
      'id': 'nf2',
      'tipo': 'SAIDA',
      'numero': '004567',
      'serie': '1',
      'data_emissao': '2025-10-01',
      'valor_total': 5200.00,
      'emitente': 'Agrocenter Nutrição Animal',
      'destinatario': 'Fazenda Santa Helena',
      'cnpj_destinatario': '12.345.678/0001-99',
      'chave_acesso': '35251055666777000188550010045670001234567891',
    },
    {
      'id': 'nf3',
      'tipo': 'ENTRADA',
      'numero': '000089',
      'serie': '1',
      'data_emissao': '2025-09-29',
      'valor_total': 18000.00,
      'emitente': 'Fazenda Santa Helena',
      'destinatario': 'Leilão Pecuária Brasil',
      'cnpj_destinatario': '88.999.111/0001-22',
      'chave_acesso': '35251088999111000122550010000890001234567892',
    },
    {
      'id': 'nf4',
      'tipo': 'SAIDA',
      'numero': '012345',
      'serie': '2',
      'data_emissao': '2025-09-28',
      'valor_total': 1350.00,
      'emitente': 'VetMais Produtos Veterinários',
      'destinatario': 'Fazenda Santa Helena',
      'cnpj_destinatario': '12.345.678/0001-99',
      'chave_acesso': '35251044555666000199550020123450001234567893',
    },
    {
      'id': 'nf5',
      'tipo': 'ENTRADA',
      'numero': '000078',
      'serie': '1',
      'data_emissao': '2025-10-02',
      'valor_total': 8500.00,
      'emitente': 'Fazenda Santa Helena',
      'destinatario': 'Laticínio ABC LTDA',
      'cnpj_destinatario': '22.333.444/0001-55',
      'chave_acesso': '35251022333444000155550010000780001234567894',
    },
  ];

  // ============================================
  // ALMOXARIFADO - MATERIAIS
  // ============================================
  
  static final materiaisAlmoxarifado = [
    {
      'id': 'mat1',
      'nome': 'Ração 18% Proteína',
      'descricao': 'Ração para gado de corte',
      'unidade': 'kg',
      'estoque_disponivel': 450.0,
      'sistema': 'PEPS',
      'custo_medio': 10.40,
    },
    {
      'id': 'mat2',
      'nome': 'Sal Mineral Completo',
      'descricao': 'Suplemento mineral bovino',
      'unidade': 'kg',
      'estoque_disponivel': 120.0,
      'sistema': 'PEPS',
      'custo_medio': 8.50,
    },
    {
      'id': 'mat3',
      'nome': 'Ivermectina 1%',
      'descricao': 'Antiparasitário injetável',
      'unidade': 'ml',
      'estoque_disponivel': 500.0,
      'sistema': 'PEPS',
      'custo_medio': 0.85,
    },
    {
      'id': 'mat4',
      'nome': 'Vacina Febre Aftosa',
      'descricao': 'Vacina obrigatória',
      'unidade': 'doses',
      'estoque_disponivel': 150.0,
      'sistema': 'PEPS',
      'custo_medio': 4.20,
    },
    {
      'id': 'mat5',
      'nome': 'Arame Farpado',
      'descricao': 'Para cerca',
      'unidade': 'metros',
      'estoque_disponivel': 800.0,
      'sistema': 'UEPS',
      'custo_medio': 2.10,
    },
  ];

  // ============================================
  // RAÇÕES
  // ============================================
  
  static final racoes = [
    {
      'id': 'rac1',
      'nome': 'Ração Confinamento Alto Rendimento',
      'descricao': 'Para gado em fase de terminação',
      'custo_kg': 1.85,
      'composicao': [
        {'ingrediente': 'Milho moído', 'quantidade': 60.0, 'unidade': '%'},
        {'ingrediente': 'Farelo de soja', 'quantidade': 25.0, 'unidade': '%'},
        {'ingrediente': 'Sal mineral', 'quantidade': 5.0, 'unidade': '%'},
        {'ingrediente': 'Ureia', 'quantidade': 2.0, 'unidade': '%'},
        {'ingrediente': 'Aditivos', 'quantidade': 8.0, 'unidade': '%'},
      ],
    },
    {
      'id': 'rac2',
      'nome': 'Ração Crescimento',
      'descricao': 'Para bezerros desmamados',
      'custo_kg': 1.45,
      'composicao': [
        {'ingrediente': 'Milho moído', 'quantidade': 50.0, 'unidade': '%'},
        {'ingrediente': 'Farelo de soja', 'quantidade': 30.0, 'unidade': '%'},
        {'ingrediente': 'Sal mineral', 'quantidade': 8.0, 'unidade': '%'},
        {'ingrediente': 'Calcário', 'quantidade': 5.0, 'unidade': '%'},
        {'ingrediente': 'Premix vitamínico', 'quantidade': 7.0, 'unidade': '%'},
      ],
    },
  ];

  // ============================================
  // DASHBOARD - DADOS AGREGADOS
  // ============================================
  
  static final dashboardFinanceiro = {
    'receitas_mes': 71500.00,
    'despesas_mes': -27398.42,
    'saldo_mes': 44101.58,
    'receitas_mes_anterior': 65000.00,
    'despesas_mes_anterior': -24500.00,
    'grafico_mensal': [
      {'mes': 'Abr', 'receitas': 52000, 'despesas': 21000},
      {'mes': 'Mai', 'receitas': 48000, 'despesas': 23500},
      {'mes': 'Jun', 'receitas': 61000, 'despesas': 22000},
      {'mes': 'Jul', 'receitas': 59000, 'despesas': 25000},
      {'mes': 'Ago', 'receitas': 65000, 'despesas': 24500},
      {'mes': 'Set', 'receitas': 71500, 'despesas': 27398},
    ],
  };

  static final dashboardCustos = {
    'custo_total_mes': 27398.42,
    'custo_por_arroba': 185.50,
    'custo_por_animal_dia': 12.30,
    'categorias': [
      {'nome': 'Alimentação', 'valor': 5200.00, 'percentual': 19.0},
      {'nome': 'Pessoal', 'valor': 12500.00, 'percentual': 45.6},
      {'nome': 'Operacional', 'valor': 5347.92, 'percentual': 19.5},
      {'nome': 'Sanidade', 'valor': 1350.00, 'percentual': 4.9},
      {'nome': 'Manutenção', 'valor': 2100.00, 'percentual': 7.7},
      {'nome': 'Tributário', 'valor': 3200.00, 'percentual': 11.7},
    ],
  };

  // ============================================
  // MÉTODOS DE AUTENTICAÇÃO
  // ============================================
  
  static bool validarLogin(String email, String senha) {
    return (email == 'admin@conquant.com.br' && senha == '123456') ||
           usuarios.any((u) => u.email == email && senha == '123456');
  }

  static Usuario? getUsuarioPorEmail(String email) {
    if (email == 'admin@conquant.com.br') return usuarioMaster;
    try {
      return usuarios.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }
}