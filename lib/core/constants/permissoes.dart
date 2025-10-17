enum Permissao {
  operacao,
  administrativo,
  gerencial,
  master;

  String get nome {
    switch (this) {
      case Permissao.operacao:
        return 'Operação';
      case Permissao.administrativo:
        return 'Administrativo';
      case Permissao.gerencial:
        return 'Gerencial';
      case Permissao.master:
        return 'Master';
    }
  }
  
  bool temAcesso(List<Permissao> permissoesNecessarias) {
    return permissoesNecessarias.contains(this) || 
           this == Permissao.master;
  }
}