import 'package:conquant_agro/data/models/pasto.dart';

class PastoMockData {
  static final List<Pasto> pastos = [
    Pasto(
      id: '1',
      nome: 'Pasto 1',
      area: 100,
      idPropriedade: 'propriedade_1',
    ),
    Pasto(
      id: '2',
      nome: 'Pasto 2',
      area: 150,
      idPropriedade: 'propriedade_1',
    ),
    Pasto(
      id: '3',
      nome: 'Pasto 3',
      area: 120,
      idPropriedade: 'propriedade_1',
    ),
  ];
}
