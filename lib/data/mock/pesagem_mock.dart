import 'package:conquant_agro/data/models/pesagem.dart';

class PesagemMockData {
  static final List<Pesagem> pesagens = [
    Pesagem(
      id: '1',
      gadoId: '1',
      peso: 500,
      data: DateTime(2025, 10, 1),
    ),
    Pesagem(
      id: '2',
      gadoId: '2',
      peso: 450,
      data: DateTime(2025, 10, 1),
    ),
    Pesagem(
      id: '3',
      gadoId: '3',
      peso: 120,
      data: DateTime(2025, 9, 15),
    ),
    Pesagem(
      id: '4',
      gadoId: '4',
      peso: 130,
      data: DateTime(2025, 9, 15),
    ),
    Pesagem(
      id: '5',
      gadoId: '5',
      peso: 350,
      data: DateTime(2025, 10, 20),
    ),
    Pesagem(
      id: '6',
      gadoId: '6',
      peso: 360,
      data: DateTime(2025, 10, 20),
    ),
  ];
}
