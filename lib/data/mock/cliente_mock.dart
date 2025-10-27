import 'package:conquant_agro/data/models/cliente.dart';

class ClienteMockData {
  static final List<Cliente> clientes = [
    Cliente(
      id: '1',
      nome: 'Fazenda São João',
      cnpj: '12.345.678/0001-99',
      ativo: true,
      dataVencimento: DateTime(2026, 12, 31),
    ),
    Cliente(
      id: '2',
      nome: 'Agropecuária Santa Maria',
      cnpj: '98.765.432/0001-11',
      ativo: true,
      dataVencimento: DateTime(2025, 11, 30),
    ),
    Cliente(
      id: '3',
      nome: 'Grupo Terra Forte',
      cnpj: '45.678.912/0001-33',
      ativo: false,
      dataVencimento: DateTime(2024, 1, 1),
    ),
  ];
}
