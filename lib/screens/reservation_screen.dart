import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../models/property.dart';
import '../models/agent.dart';
import '../models/reservation.dart';
import '../services/reservation_service.dart';
import 'confirmation_screen.dart';

class ReservationScreen extends StatefulWidget {
  final Buyer buyer;
  final Property property;
  final Reservation? existingReservation;

  const ReservationScreen({
    super.key,
    required this.buyer,
    required this.property,
    this.existingReservation,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  Agent? _selectedAgent;
  List<Agent>? _agents;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.existingReservation != null) {
      final r = widget.existingReservation!;
      _selectedDate = r.date;
      final parts = r.time.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    final agents = await ReservationService.getAgents();
    setState(() {
      _agents = agents;
      if (widget.existingReservation != null) {
        _selectedAgent =
            agents.cast<Agent?>().firstWhere(
              (a) => a!.id == widget.existingReservation!.agentId,
              orElse: () => agents.isNotEmpty ? agents[0] : null,
            );
      } else {
        _selectedAgent = agents.isNotEmpty ? agents[0] : null;
      }
      _loading = false;
    });
  }

  String get _formattedDate {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${_selectedDate.day} de ${months[_selectedDate.month - 1]} del ${_selectedDate.year}';
  }

  String get _formattedTime {
    final hour = _selectedTime.hour.toString().padLeft(2, '0');
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _miniStat(ThemeData theme, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(label,
            style: theme.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  Future<void> _confirmReservation() async {
    if (_selectedAgent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un agente inmobiliario'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final isModify = widget.existingReservation != null;

    Reservation reservation;
    if (isModify) {
      reservation = widget.existingReservation!.copyWith(
        date: _selectedDate,
        time: _formattedTime,
        agentId: _selectedAgent!.id,
      );
      await ReservationService.updateReservation(reservation);
    } else {
      reservation = Reservation(
        id: ReservationService.generateId(),
        buyerId: widget.buyer.id,
        propertyId: widget.property.id,
        agentId: _selectedAgent!.id,
        date: _selectedDate,
        time: _formattedTime,
      );
      await ReservationService.createReservation(reservation);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmationScreen(
            reservation: reservation,
            property: widget.property,
            agent: _selectedAgent!,
            buyer: widget.buyer,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingReservation != null
            ? 'Modificar Visita'
            : 'Agendar Visita'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.home,
                                size: 48, color: theme.colorScheme.primary),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.property.title,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.property.address,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme
                                            .colorScheme.onSurfaceVariant),
                                  ),
                                  if (widget.property.locationText.isNotEmpty)
                                    Text(
                                      widget.property.locationText,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: theme.colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  if (widget.property.coordText.isNotEmpty)
                                    Text(
                                      widget.property.coordText,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: theme
                                            .colorScheme.onSurfaceVariant,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  Text(
                                    '\$${widget.property.price.toStringAsFixed(0)}',
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _miniStat(theme, Icons.bed,
                                '${widget.property.bedrooms}'),
                            const SizedBox(width: 16),
                            _miniStat(theme, Icons.bathtub,
                                '${widget.property.bathrooms}'),
                            if (widget.property.parking != null) ...[
                              const SizedBox(width: 16),
                              _miniStat(theme, Icons.directions_car,
                                  '${widget.property.parking}'),
                            ],
                            const SizedBox(width: 16),
                            _miniStat(theme, Icons.square_foot,
                                widget.property.area.toStringAsFixed(0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Selecciona la fecha',
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(_formattedDate),
                      trailing: const Icon(Icons.edit),
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Selecciona el horario',
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(_formattedTime),
                      trailing: const Icon(Icons.edit),
                      onTap: _pickTime,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Asignar agente inmobiliario',
                      style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Agent>(
                    initialValue: _selectedAgent,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    items: _agents!.map((agent) {
                      return DropdownMenuItem(
                        value: agent,
                        child: Text(agent.name),
                      );
                    }).toList(),
                    onChanged: (agent) =>
                        setState(() => _selectedAgent = agent),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _confirmReservation,
                    icon: const Icon(Icons.check_circle),
                    label: Text(widget.existingReservation != null
                        ? 'Guardar Cambios'
                        : 'Confirmar Reserva'),
                  ),
                ],
              ),
            ),
    );
  }
}
