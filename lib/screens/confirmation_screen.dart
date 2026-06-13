import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../models/property.dart';
import '../models/agent.dart';
import '../models/reservation.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final Reservation reservation;
  final Property property;
  final Agent agent;
  final Buyer buyer;

  const ConfirmationScreen({
    super.key,
    required this.reservation,
    required this.property,
    required this.agent,
    required this.buyer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva Confirmada'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                '¡Reserva Confirmada!',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(theme, 'Propiedad', property.title),
                      const Divider(),
                      _infoRow(theme, 'Dirección', property.address),
                      if (property.latitude != null && property.longitude != null) ...[
                        const Divider(),
                        _infoRow(
                          theme,
                          'Coordenadas',
                          '${property.latitude!.toStringAsFixed(5)}, ${property.longitude!.toStringAsFixed(5)}',
                        ),
                      ],
                      const Divider(),
                      _infoRow(
                          theme,
                          'Fecha',
                          reservation.date
                              .toIso8601String()
                              .split('T')
                              .first),
                      const Divider(),
                      _infoRow(theme, 'Horario', reservation.time),
                      const Divider(),
                      _infoRow(theme, 'Agente', agent.name),
                      const Divider(),
                      _infoRow(theme, 'Comprador', buyer.name),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(buyer: buyer),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Volver al Inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
