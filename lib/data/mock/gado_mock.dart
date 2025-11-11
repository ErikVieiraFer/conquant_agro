import 'package:conquant_agro/data/models/gado.dart';

class GadoMockData {
  static final List<Gado> gados = [
    Gado(
      id: '1',
      propriedadeId: 'propriedade_1',
      idEletronico: 'RFID001',
      idUsual: '123',
      raca: 'Nelore',
      grauSangue: 87.5,
      sexo: 'Macho',
      pelagem: 'Branca',
      dataNascimento: DateTime(2022, 1, 1),
      rgnRgd: 'RGN123',
      loteEntrada: 'LOTE2022-01',
      pastoId: '1',
    ),
    Gado(
      id: '2',
      propriedadeId: 'propriedade_1',
      idEletronico: 'RFID002',
      idUsual: '456',
      raca: 'Angus',
      grauSangue: 75.0,
      sexo: 'Fêmea',
      pelagem: 'Preta',
      dataNascimento: DateTime(2022, 2, 2),
      rgnRgd: 'RGN456',
      loteEntrada: 'LOTE2022-01',
      pastoId: '1',
    ),
    Gado(
      id: '3',
      propriedadeId: 'propriedade_1',
      idEletronico: 'RFID003',
      idUsual: '789',
      raca: 'Nelore',
      grauSangue: 100.0,
      sexo: 'Macho',
      pelagem: 'Vermelha',
      dataNascimento: DateTime(2023, 3, 3),
      loteEntrada: 'LOTE2023-01',
      pastoId: '2',
    ),
  ];
}
