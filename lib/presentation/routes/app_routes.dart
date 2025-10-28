abstract class AppRoutes {
  static const login = '/login';
  static const home = '/home';

  // Administrativo
  static const fluxoCaixa = '/fluxo-caixa';
  static const despesas = '/despesas';
  static const notasFiscais = '/notas-fiscais';
  static const conciliacao = '/conciliacao';
  static const extratoBancario = '/extrato-bancario';
  static const almoxarifado = '/almoxarifado';
  static const auditoria = '/auditoria';
  static const relatorios = '/relatorios';
  static const despesaForm = '/despesa-form';
  static const transacaoForm = '/transacao-form';
  static const notaFiscalForm = '/nota-fiscal-form';

  // Configurações
  static const usuarios = '/usuarios';
  static const propriedades = '/propriedades';
  static const clientes = '/clientes';
  static const usuarioForm = '/usuario-form';
  static const propriedadeForm = '/propriedade-form';
  static const clienteForm = '/cliente-form';

  // Manejo
  static const gados = '/gados';
  static const pastos = '/pastos';
  static const movimentacoes = '/movimentacoes';
  static const cruzamentos = '/cruzamentos';
  static const categoriasHistorico = '/categorias-historico';
  static const gadoForm = '/gado-form';
  static const pastoForm = '/pasto-form';
  static const movimentacaoForm = '/movimentacao-form';
  static const categoriaHistoricoForm = '/categoria-historico-form';
  static const movimentacoesGado = '/movimentacoes-gado';
  static const movimentacaoGadoForm = '/movimentacao-gado-form';

  // Pesagem
  static const pesagem = '/pesagem';
  static const pesagensGrupos = '/pesagens-grupos';
  static const historicoPesagens = '/historico-pesagens';
  static const dashboardProducao = '/dashboard-producao';
  static const pesagemGrupoForm = '/pesagem-grupo-form';
  static const pesagemForm = '/pesagem-form';

  // Zoosanitário
  static const aplicacoes = '/aplicacoes';
  static const medicamentos = '/medicamentos';
  static const aplicacaoForm = '/aplicacao-form';
}