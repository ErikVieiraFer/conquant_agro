import 'package:conquant_agro/data/models/gado.dart';

class GadoMockData {
  static final List<Gado> gados = [
    Gado(
      id: '1',
      brinco: '123',
      raca: 'Nelore',
      dataNascimento: DateTime(2022, 1, 1),
      pastoId: '1',
      idPropriedade: 'propriedade_1',
    ),
    Gado(
      id: '2',
      brinco: '456',
      raca: 'Angus',
      dataNascimento: DateTime(2022, 2, 2),
      pastoId: '1',
      idPropriedade: 'propriedade_1',
    ),
    Gado(
      id: '3',
      brinco: '789',
      raca: 'Nelore',
      dataNascimento: DateTime(2023, 3, 3),
      pastoId: '2',
      idPropriedade: 'propriedade_1',
    ),
  ];
}
