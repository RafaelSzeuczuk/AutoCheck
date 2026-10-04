import 'package:flutter/material.dart';
import 'busca_informacoes_page.dart';
import 'busca_cidade_page.dart';
import 'busca_complementares_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/app_icon.png', height: 36),
            const SizedBox(width: 10),
            const Text('Busca Placa'),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 18),
          const Icon(Icons.directions_car_filled, size: 70, color: Color(0xFF1565C0)),
          const SizedBox(height: 12),
          Text('Escolha uma consulta', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Digite uma placa na próxima tela para buscar os dados do veículo.', textAlign: TextAlign.center),
          const SizedBox(height: 28),
          _botao(context, Icons.info_outline, 'Buscar informações básicas', const BuscaInformacoesPage()),
          _botao(context, Icons.location_city, 'Buscar cidade da placa', const BuscaCidadePage()),
          _botao(context, Icons.manage_search, 'Buscar informações complementares', const BuscaComplementaresPage()),
        ],
      ),
    );
  }

  Widget _botao(BuildContext context, IconData icon, String texto, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 62,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
          icon: Icon(icon, size: 30),
          label: Text(texto, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
