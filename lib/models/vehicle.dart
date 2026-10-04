class Vehicle {
  final Map<String, dynamic> data;

  const Vehicle(this.data);

  String value(String key) {
    final value = data[key];
    if (value == null || value.toString().trim().isEmpty) {
      return 'Não informado';
    }
    return value.toString();
  }

  String get placaModeloAntigo => value('placa_modelo_antigo');
  String get placaModeloNovo => value('placa_modelo_novo');
  String get municipio => value('municipio');
  String get uf => value('uf');
  String get marca => value('marca');
  String get anoFabricacao => value('ano_fabricacao');
  String get anoModelo => value('ano_modelo');
  String get modelo => value('modelo');
  String get segmento => value('segmento');
  String get subSegmento => value('sub_segmento');
  String get grupo => value('grupo');
  String get combustivel => value('combustivel');
  String get nacionalidade => value('nacionalidade');
  String get especie => value('especie');
  String get tipoVeiculo => value('tipo_veiculo');
  String get ufPlaca => value('uf_placa');
  String get potencia => value('potencia');
  String get capacidadeCarga => value('capacidade_carga');
  String get quantidadePassageiro => value('quantidade_passageiro');
  String get cilindradas => value('cilindradas');
  String get capacidadeMaximaTracao => value('cap_maxima_tracao');
  String get pesoBrutoTotal => value('peso_bruto_total');
  String get chassi => value('chassi');
  String get motor => value('motor');
  String get id => value('id');
  String get criadoEm => value('created_at');
  String get atualizadoEm => value('updated_at');
}
