import 'package:conquant_agro/data/models/propriedade.dart';

class PropriedadeMockData {
  static final List<Propriedade> propriedades = [
    Propriedade(
      id: '1',
      nome: 'Fazenda Principal',
      cnpj: '11.111.111/0001-11',
      endereco: 'Zona Rural, s/n',
    ),
    Propriedade(
      id: '2',
      nome: 'Retiro',
      cnpj: '22.222.222/0001-22',
      endereco: 'Estrada do Retiro, km 10',
      bloqueado: true,
    ),
  ];
}
