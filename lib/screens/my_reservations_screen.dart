import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../models/property.dart';
import '../models/agent.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import 'reservation_screen.dart';

class MyReservationsScreen extends StatefulWidget {
  final Buyer buyer;

  const MyReservationsScreen({super.key, required this.buyer});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  List<Reservation>? _reservations;
  List<Property>? _properties;
  List<Agent>? _agents;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final reservations =
        await ReservationService.getReservationsByBuyer(widget.buyer.id);
    final properties = await ReservationService.getProperties();
    final agents = await ReservationService.getAgents();

    reservations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (!mounted) return;
    setState(() {
      _reservations = reservations;
      _properties = properties;
      _agents = agents;
      _loading = false;
    });
  }

  Property? _findProperty(String id) =>
      _properties?.cast<Property?>().firstWhere(
            (p) => p!.id == id,
            orElse: () => null,
          );

  Agent? _findAgent(String id) =>
      _agents?.cast<Agent?>().firstWhere(
            (a) => a!.id == id,
            orElse: () => null,
          );

  Color _statusColor(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.confirmed:
        return Colors.green;
      case ReservationStatus.cancelled:
        return Colors.red;
      case ReservationStatus.completed:
        return Colors.blue;
    }
  }

  Future<void> _cancelReservation(Reservation reservation) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: const Text('¿Estás seguro de cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ReservationService.cancelReservation(reservation.id);
      _loadData();
    }
  }

  Future<void> _modifyReservation(Reservation reservation) async {
    final property = _findProperty(reservation.propertyId);
    if (property == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReservationScreen(
          buyer: widget.buyer,
          property: property,
          existingReservation: reservation,
        ),
      ),
    );

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _reservations!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(height: 16),
                      Text('No tienes reservas',
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _reservations!.length,
                    itemBuilder: (context, index) {
                      final reservation = _reservations![index];
                      final property =
                          _findProperty(reservation.propertyId);
                      final agent = _findAgent(reservation.agentId);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      property?.title ?? 'Propiedad',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _statusColor(reservation.status)
                                          .withValues(alpha: 0.2),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      reservation.status.label,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: _statusColor(
                                            reservation.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _detailRow(
                                  theme,
                                  'Fecha',
                                  reservation.date
                                      .toIso8601String()
                                      .split('T')
                                      .first),
                              _detailRow(
                                  theme, 'Horario', reservation.time),
                              _detailRow(
                                  theme, 'Agente', agent?.name ?? 'N/A'),
                              if (reservation.status ==
                                  ReservationStatus.confirmed) ...[
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () => _cancelReservation(
                                          reservation),
                                      icon: const Icon(Icons.cancel,
                                          size: 18),
                                      label: const Text('Cancelar'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton.tonalIcon(
                                      onPressed: () => _modifyReservation(
                                          reservation),
                                      icon: const Icon(Icons.edit,
                                          size: 18),
                                      label: const Text('Modificar'),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
