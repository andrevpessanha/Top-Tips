class Produto {
  final id;
  final categoria;
  final marca;
  final modelo;
  final imagemUrl;

  Produto({this.id, this.categoria, this.marca, this.modelo, this.imagemUrl});

  factory Produto.fromJson(Map<String, dynamic> json) {
    final chave = json.keys.first;
    return Produto(
      id: chave,
      categoria: json[chave]['categoria'],
      marca: json[chave]['marca'],
      modelo: json[chave]['modelo'],
      imagemUrl: json[chave]['imagemUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      id: {
        'categoria': categoria,
        'marca': marca,
        'modelo': modelo,
        'imagemUrl': imagemUrl
      }
    };
  }
}
