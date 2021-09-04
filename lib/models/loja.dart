class Loja {
  final id;
  final nome;
  final email;
  final imagemUrl;
  final telefone;
  final endereco;
  final descricao;
  bool vazia;

  Loja(
      {this.id,
      this.nome,
      this.email,
      this.imagemUrl,
      this.telefone,
      this.endereco,
      this.descricao,
      this.vazia = false});

  bool estaVazia() {
    return vazia;
  }

  factory Loja.fromJson(Map<String, dynamic> json) {
    final chave = json.keys.first;
    return Loja(
      id: chave,
      nome: json[chave]['nome'],
      email: json[chave]['email'],
      imagemUrl: json[chave]['imagemUrl'],
      telefone: json[chave]['telefone'],
      endereco: json[chave]['endereco'],
      descricao: json[chave]['descricao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      id: {
        'nome': nome,
        'email': email,
        'imagemUrl': imagemUrl,
        'telefone': telefone,
        'endereco': endereco,
        'descricao': descricao,
      }
    };
  }
}
