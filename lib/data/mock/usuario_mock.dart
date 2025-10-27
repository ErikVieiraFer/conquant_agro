import 'package:conquant_agro/core/constants/permissoes.dart';
import 'package:conquant_agro/data/models/usuario.dart';

class UsuarioMockData {
  static final List<Usuario> usuarios = [
    Usuario(
      id: '1',
      nome: 'Administrador',
      email: 'admin@conquant.com.br',
      permissao: Permissao.master,
      propriedadeId: '1',
    ),
    Usuario(
      id: '2',
      nome: 'Gerente da Fazenda',
      email: 'gerente@fazenda.com',
      permissao: Permissao.gerencial,
      propriedadeId: '1',
    ),
    Usuario(
      id: '3',
      nome: 'Operador de Campo',
      email: 'operador@fazenda.com',
      permissao: Permissao.operacao,
      propriedadeId: '1',
      ativo: false,
    ),
  ];
}
