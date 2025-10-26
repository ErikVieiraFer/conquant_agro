import '../../core/constants/permissoes.dart';
import '../models/usuario.dart';

class AuthRepository {
  Future<Usuario?> login(String email, String senha) async {
    // Lógica de autenticação com a API
    await Future.delayed(const Duration(seconds: 1));
    // Exemplo de retorno mockado
    if (email == 'test@test.com' && senha == '123456') {
      return Usuario(id: '1', nome: 'Test User', email: email, permissao: Permissao.master, propriedadeId: '1');
    } else {
      return null;
    }
  }
}