import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../models/property.dart';
import 'reservation_screen.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Buyer buyer;
  final Property property;

  const PropertyDetailScreen({
    super.key,
    required this.buyer,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(property.typeLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageHeader(theme),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(theme),
                  const SizedBox(height: 12),
                  _buildStatsRow(theme),
                  const SizedBox(height: 16),
                  _buildLocationSection(theme),
                  const SizedBox(height: 16),
                  _buildTagsSection(theme),
                  const SizedBox(height: 16),
                  _buildDescriptionSection(theme),
                  const SizedBox(height: 16),
                  _buildFeaturesSection(theme),
                  if (property.agentName != null) ...[
                    const SizedBox(height: 16),
                    _buildAgentSection(theme),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReservationScreen(
                            buyer: buyer,
                            property: property,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Agendar Visita'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(ThemeData theme) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: property.images.isNotEmpty
          ? PageView.builder(
              itemCount: property.images.length,
              itemBuilder: (context, index) => Image.network(
                property.images[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stack) =>
                    _imagePlaceholder(theme),
              ),
            )
          : _imagePlaceholder(theme),
    );
  }

  Widget _imagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Center(
        child: Icon(
          Icons.home,
          size: 64,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildTitleRow(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          property.title,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${property.price.toStringAsFixed(0)} ${property.currency}',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Row(
      children: [
        _statChip(theme, Icons.bed, '${property.bedrooms}', 'Dorm.'),
        const SizedBox(width: 12),
        _statChip(theme, Icons.bathtub, '${property.bathrooms}', 'Baños'),
        if (property.parking != null) ...[
          const SizedBox(width: 12),
          _statChip(
              theme, Icons.directions_car, '${property.parking}', 'Estac.'),
        ],
        const SizedBox(width: 12),
        _statChip(
          theme,
          Icons.square_foot,
          property.area.toStringAsFixed(0),
          'm²',
        ),
        if (property.landArea != null) ...[
          const SizedBox(width: 12),
          _statChip(
            theme,
            Icons.terrain,
            property.landArea!.toStringAsFixed(0),
            'terreno',
          ),
        ],
      ],
    );
  }

  Widget _statChip(
      ThemeData theme, IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            value,
            style: theme.textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 2),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }

  Widget _buildLocationSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Ubicación',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(property.address, style: theme.textTheme.bodyMedium),
            if (property.locationText.isNotEmpty)
              Text(property.locationText,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
            if (property.coordText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(property.coordText,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection(ThemeData theme) {
    if (property.tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: property.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            tag,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme) {
    if (property.description.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Descripción',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(property.description, style: theme.textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildFeaturesSection(ThemeData theme) {
    final features = <Widget>[];

    void addFeature(IconData icon, String label, bool? value) {
      if (value == null) return;
      features.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                value ? Icons.check_circle : Icons.cancel,
                size: 20,
                color: value ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(label, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    addFeature(Icons.pets, 'Acepta mascotas', property.petsAllowed);
    addFeature(Icons.pool, 'Alberca', property.hasPool);
    addFeature(Icons.star, 'Exclusiva', property.exclusive);
    addFeature(Icons.videocam, 'Video', property.hasVideo);
    addFeature(
        Icons.view_in_ar, 'Recorrido virtual', property.hasVirtualTour);

    if (property.operationType != null) {
      features.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(Icons.sell, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('Operación: ${property.operationType}',
                  style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    if (features.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Características',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...features,
      ],
    );
  }

  Widget _buildAgentSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              backgroundImage: property.agentPhoto != null
                  ? NetworkImage(property.agentPhoto!)
                  : null,
              child: property.agentPhoto == null
                  ? Icon(Icons.person,
                      color: theme.colorScheme.onPrimaryContainer)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Agente',
                      style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                  Text(property.agentName!,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  if (property.officeName != null)
                    Text(property.officeName!,
                        style: theme.textTheme.bodySmall),
                  if (property.agentPhone != null)
                    Text(property.agentPhone!,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
