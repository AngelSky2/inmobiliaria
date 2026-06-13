import 'package:flutter/material.dart';
import '../models/buyer.dart';
import '../models/property.dart';
import '../services/reservation_service.dart';
import '../widgets/property_card.dart';
import 'property_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  final Buyer buyer;

  const CatalogScreen({super.key, required this.buyer});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Property>? _properties;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    final props = await ReservationService.getProperties();
    if (!mounted) return;
    setState(() {
      _properties = props;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Propiedades'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _properties!.isEmpty
              ? const Center(child: Text('No hay propiedades disponibles'))
              : RefreshIndicator(
                  onRefresh: _loadProperties,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount =
                          constraints.maxWidth > 600 ? 3 : 2;
                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _properties!.length,
                        itemBuilder: (context, index) {
                          final property = _properties![index];
                          return PropertyCard(
                            property: property,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PropertyDetailScreen(
                                    buyer: widget.buyer,
                                    property: property,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
