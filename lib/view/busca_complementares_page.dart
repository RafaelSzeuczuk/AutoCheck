import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../service/giphy_service.dart';
import '../service/vehicle_service.dart';
import 'gif_page.dart';

class BuscaComplementaresPage extends StatefulWidget {
  const BuscaComplementaresPage({super.key});

  @override
  State<BuscaComplementaresPage> createState() =>
      _BuscaComplementaresPageState();
}

class _BuscaComplementaresPageState extends State<BuscaComplementaresPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _apiService = VehicleService();
  final _giphyService = GiphyService();

  Vehicle? _veiculo;
  Map<String, dynamic>? _gif;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _normalizar(String valor) {
    return valor.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  String? _validar(String? valor) {
    final placa = _normalizar(valor ?? '');

    if (placa.isEmpty) return 'Digite uma placa.';
    if (!RegExp(r'^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$').hasMatch(placa)) {
      return 'Use ABC1234 ou ABC1D23.';
    }

    return null;
  }

  Future<void> _buscar() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _carregando = true;
      _erro = null;
      _veiculo = null;
      _gif = null;
    });

    try {
      final resultado = await _apiService.getVehicle(
        _normalizar(_controller.text),
      );

      Map<String, dynamic>? resultadoGif;
      try {
        resultadoGif = await _giphyService.getGif(
          '${resultado.tipoVeiculo} ${resultado.marca}'
        );
      } catch (_) {}

      if (!mounted) return;//checa se o widget ainda está na árvore de widgets antes de chamar setState
      setState(() {
        _veiculo = resultado;
        _gif = resultadoGif;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.toString().replaceFirst('Exception: ', '');
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/app_icon.png', height: 32),
            const SizedBox(width: 8),
            const Text('Complementares'),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                textCapitalization: TextCapitalization.characters,
                maxLength: 7,
                validator: _validar,
                onFieldSubmitted: (_) => _buscar(),
                decoration: const InputDecoration(
                  labelText: 'Digite a placa',
                  hintText: 'ABC1D23',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _carregando ? null : _buscar,
                child: Text(
                  _carregando ? 'Buscando...' : 'Buscar complementares',
                ),
              ),
            ),
            if (_carregando)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            if (_erro != null) _mensagem(_erro!),
            if (_veiculo != null) _resultado(_veiculo!),
          ],
        ),
      ),
    );
  }

  Widget _resultado(Vehicle veiculo) {
    final dados = <String, String>{
      'Subsegmento': veiculo.value('sub_segmento'),
      'Grupo': veiculo.value('grupo'),
      'Combustível': veiculo.value('combustivel'),
      'Nacionalidade': veiculo.value('nacionalidade'),
      'Espécie': veiculo.value('especie'),
      'Tipo de veículo': veiculo.value('tipo_veiculo'),
      'UF da placa': veiculo.value('uf_placa'),
      'Potência': veiculo.value('potencia'),
      'Capacidade de carga': veiculo.value('capacidade_carga'),
      'Quantidade de passageiros': veiculo.value('quantidade_passageiro'),
      'Cilindradas': veiculo.value('cilindradas'),
      'Capacidade máxima de tração': veiculo.value('cap_maxima_tracao'),
      'Peso bruto total': veiculo.value('peso_bruto_total'),
    };

    final imagens = _gif?['images'] as Map<String, dynamic>?;
    final fixa = imagens?['fixed_height'] as Map<String, dynamic>?;
    final url = fixa?['url'] as String?;

    return Column(
      children: [
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informações complementares',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                ...dados.entries.map((item) => _linha(item.key, item.value)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _gifCard(url),
      ],
    );
  }

  Widget _gifCard(String? url) {
    if (url == null || url.isEmpty || _gif == null) {
      return const Card(
        child: ListTile(title: Text('Nenhuma animação encontrada.')),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GifPage(_gif!)),
          );
        },
        child: Image.network(
          url,
          height: 190,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _linha(String nome, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 3, child: Text(valor)),
        ],
      ),
    );
  }

  Widget _mensagem(String texto) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        texto,
        style: TextStyle(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}
