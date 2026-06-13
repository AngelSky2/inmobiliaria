import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../main.dart';
import 'registration_screen.dart';
import 'catalog_screen.dart';
import 'my_reservations_screen.dart';

class HomeScreen extends StatefulWidget {
  final Buyer? buyer;

  const HomeScreen({super.key, this.buyer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Buyer? _currentBuyer;

  @override
  void initState() {
    super.initState();
    _currentBuyer = widget.buyer;
  }

  Future<void> _goToRegistration() async {
    final buyer = await Navigator.push<Buyer>(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
    if (buyer != null) {
      setState(() => _currentBuyer = buyer);
    }
  }

  Future<void> _goToCatalog() async {
    if (_currentBuyer == null) {
      _showNeedRegistration();
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CatalogScreen(buyer: _currentBuyer!),
      ),
    );
  }

  Future<void> _goToMyReservations() async {
    if (_currentBuyer == null) {
      _showNeedRegistration();
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyReservationsScreen(buyer: _currentBuyer!),
      ),
    );
  }

  void _showNeedRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Primero debes registrarte como comprador'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inmobiliaria'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              InmobiliariaApp.of(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => InmobiliariaApp.of(context).toggleTheme(),
            tooltip: 'Cambiar tema',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home_work,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Bienvenido a Inmobiliaria',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _currentBuyer != null
                    ? 'Hola, ${_currentBuyer!.name}'
                    : 'Regístrate para agendar visitas',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _goToRegistration,
                  icon: const Icon(Icons.person_add),
                  label: Text(
                    _currentBuyer == null
                        ? 'Registrarse'
                        : 'Cambiar Usuario',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _goToCatalog,
                  icon: const Icon(Icons.inventory_2),
                  label: const Text('Ver Catálogo'),
                ),
              ),
              if (_currentBuyer != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _goToMyReservations,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Mis Reservas'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
