import 'package:conquant_agro/data/models/pesagem_grupo.dart';

class PesagemGrupoMockData {
  static final List<PesagemGrupo> pesagensGrupos = [
    PesagemGrupo(
      id: '1',
      nome: 'Lote 2025/1',
      data: DateTime(2025, 10, 1),
    ),
    PesagemGrupo(
      id: '2',
      nome: 'Bezerros desmamados',
      data: DateTime(2025, 9, 15),
    ),
    PesagemGrupo(
      id: '3',
      nome: 'Novilhas para I.A.',
      data: DateTime(2025, 10, 20),
    ),
  ];
}
