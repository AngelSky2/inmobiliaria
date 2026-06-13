class Property {
  final String id;
  final String title;
  final String description;
  final String address;
  final double price;
  final String currency;
  final int bedrooms;
  final int bathrooms;
  final double area;
  final double? landArea;
  final String type;
  final List<String> images;
  final bool available;
  final String? city;
  final String? state;
  final String? country;
  final String? agentName;
  final String? agentPhoto;
  final String? agentPhone;
  final String? agentEmail;
  final String? officeName;
  final double? latitude;
  final double? longitude;
  final int? parking;
  final bool? petsAllowed;
  final bool? hasPool;
  final bool? exclusive;
  final bool? hasVideo;
  final bool? hasVirtualTour;
  final String? operationType;
  final List<String> tags;

  Property({
    required this.id,
    required this.title,
    this.description = '',
    this.address = '',
    required this.price,
    this.currency = 'USD',
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.area = 0,
    this.landArea,
    required this.type,
    this.images = const [],
    this.available = true,
    this.city,
    this.state,
    this.country,
    this.agentName,
    this.agentPhoto,
    this.agentPhone,
    this.agentEmail,
    this.officeName,
    this.latitude,
    this.longitude,
    this.parking,
    this.petsAllowed,
    this.hasPool,
    this.exclusive,
    this.hasVideo,
    this.hasVirtualTour,
    this.operationType,
    this.tags = const [],
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      address: json['address'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int? ?? 0,
      area: (json['area'] as num?)?.toDouble() ?? 0,
      type: json['type'] as String,
      images: List<String>.from(json['images'] as List? ?? []),
      available: json['available'] as bool? ?? true,
    );
  }

  factory Property.fromApi(Map<String, dynamic> json) {
    final fotos = json['fotos'] as Map<String, dynamic>?;
    final thumbs = fotos?['propiedadThumbnail'] as List? ?? [];
    final precios = json['precios'] as Map<String, dynamic>?;
    final contrato = precios?['contrato'] as Map<String, dynamic>?;
    final precio = contrato?['precio'] ?? json['precio'];
    final moneda =
        contrato?['moneda'] as String? ?? json['moneda'] as String? ?? 'USD';

    final tagsList = json['etiquetas'] as List?;
    final tags = tagsList
            ?.map((e) => (e as Map<String, dynamic>)['label'] as String? ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        [];

    String type;
    switch (json['tipoPropiedad'] as String? ?? '') {
      case 'casa':
      case 'casa-en-condominio':
        type = 'house';
        break;
      case 'departamento':
      case 'penthouse':
        type = 'apartment';
        break;
      case 'terreno':
      case 'quinta':
      case 'rural':
      case 'rancho':
        type = 'land';
        break;
      default:
        type = 'other';
    }

    return Property(
      id: json['id']?.toString() ?? '',
      title: json['encabezado'] as String? ?? 'Propiedad',
      description: json['metaTags']?['fotos'] as String? ?? '',
      address: json['calle'] as String? ?? '',
      price: (precio as num?)?.toDouble() ?? 0,
      currency: moneda,
      bedrooms: json['recamaras'] as int? ?? 0,
      bathrooms: json['banos'] as int? ?? 0,
      area: (json['m2C'] as num?)?.toDouble() ?? 0,
      landArea: (json['m2T'] as num?)?.toDouble(),
      type: type,
      images: thumbs.map((e) => e.toString()).toList(),
      available: true,
      city: json['municipio'] as String?,
      state: json['estado'] as String?,
      country: json['pais'] as String?,
      agentName: json['asesorNombre'] as String?,
      agentPhoto: json['asesorThumbnail'] as String?,
      agentPhone: json['telefono'] as String?,
      agentEmail: json['email'] as String?,
      officeName: json['nombreAfiliado'] as String?,
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lon'] as num?)?.toDouble(),
      parking: json['estacionamientos'] as int?,
      petsAllowed: json['mascotas'] as bool?,
      hasPool: json['alberca'] as bool?,
      exclusive: json['exclusiva'] as bool?,
      hasVideo: json['conVideo'] as bool?,
      hasVirtualTour: json['recorridoVirtual'] as bool?,
      operationType: json['tipoOperacion'] as String?,
      tags: tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'price': price,
      'currency': currency,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'area': area,
      'type': type,
      'images': images,
      'available': available,
    };
  }

  String get typeLabel {
    switch (type) {
      case 'house':
        return 'Casa';
      case 'apartment':
        return 'Departamento';
      case 'land':
        return 'Terreno';
      case 'penthouse':
        return 'Penthouse';
      default:
        return type;
    }
  }

  String get locationText {
    return [city, state].where((e) => e != null).join(', ');
  }

  String get coordText {
    if (latitude == null || longitude == null) return '';
    return '${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}';
  }
}
