class Anuncio {
  final id;
  final idLoja;
  final idProduto;
  final categoria;
  final marca;
  final modelo;
  final descricao;
  final valor;
  final nomeLoja;
  final imagemUrl;

  Anuncio(
      {this.id,
      this.idLoja,
      this.idProduto,
      this.categoria,
      this.marca,
      this.modelo,
      this.descricao,
      this.valor,
      this.nomeLoja,
      this.imagemUrl});

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    final chave = json.keys.first;
    return Anuncio(
      id: chave,
      idLoja: json[chave]['idLoja'],
      idProduto: json[chave]['idProduto'],
      categoria: json[chave]['categoria'],
      marca: json[chave]['marca'],
      modelo: json[chave]['modelo'],
      descricao: json[chave]['descricao'],
      valor: json[chave]['valor'],
      nomeLoja: json[chave]['nomeLoja'],
      imagemUrl: json[chave]['imagemUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      id: {
        'idLoja': idLoja,
        'idProduto': idProduto,
        'categoria': categoria,
        'marca': marca,
        'modelo': modelo,
        'descricao': descricao,
        'valor': valor,
        'nomeLoja': nomeLoja,
        'imagemUrl': imagemUrl
      }
    };
  }
}
