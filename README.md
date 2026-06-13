# Inmobiliaria — App de Reserva de Visitas

Aplicación móvil desarrollada en **Flutter** que permite a un comprador reservar una visita para conocer una propiedad disponible. Los datos de las propiedades se obtienen desde una API REST externa y se almacenan en caché local en formato JSON para su uso sin conexión.

---

## Funcionalidades

- Registro de comprador
- Catálogo de propiedades con imágenes desde API
- Vista detalle de propiedad (fotos, stats, ubicación, características, agente)
- Selección de fecha y horario para la visita
- Asignación de agente inmobiliario
- Confirmación de reserva
- Consulta de reservas realizadas
- Modificación y cancelación de reservas
- Tema oscuro / claro

---

## Arquitectura

```
lib/
├── main.dart                    # Punto de entrada, tema oscuro/claro
├── models/                      # Modelos de datos
│   ├── buyer.dart               # Comprador
│   ├── property.dart            # Propiedad (mapeo desde API + JSON local)
│   ├── agent.dart               # Agente inmobiliario
│   └── reservation.dart         # Reserva de visita
├── screens/                     # Pantallas
│   ├── home_screen.dart         # Inicio
│   ├── registration_screen.dart # Registro de comprador
│   ├── catalog_screen.dart      # Catálogo de propiedades
│   ├── property_detail_screen.dart # Detalle de propiedad
│   ├── reservation_screen.dart  # Agendar / modificar visita
│   ├── confirmation_screen.dart # Confirmación de reserva
│   └── my_reservations_screen.dart # Mis reservas
├── services/                    # Servicios
│   ├── json_service.dart        # Lectura/escritura de archivos JSON
│   ├── api_service.dart         # Consumo de API REST
│   ├── property_repository.dart # Repositorio con fallback: API → caché → assets
│   └── reservation_service.dart # Lógica de negocio de reservas
└── widgets/
    └── property_card.dart       # Tarjeta reutilizable de propiedad
```

### Flujo de datos

1. Al abrir el catálogo, se intenta obtener propiedades desde la **API REST**
2. Si la API responde correctamente, se **guarda en caché local** (JSON)
3. Si no hay internet, se lee desde la **caché local**
4. Si no hay caché, se cargan los datos de respaldo incluidos en `assets/data/`

---

## Tecnologías usadas

| Tecnología           | Propósito                          |
|----------------------|------------------------------------|
| Flutter / Dart       | Framework de desarrollo móvil      |
| Material Design 3    | Sistema de diseño UI               |
| path_provider        | Acceso al sistema de archivos      |
| http                 | Peticiones HTTP a la API           |
| JSON (dart:convert)  | Serialización y persistencia local |

---

## Requisitos

- Flutter SDK 3.12.1 o superior
- Dart 3.12.1 o superior
- Conexión a internet (solo para la carga inicial de propiedades)

---

## Instalación y ejecución

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd inmobiliaria

# 2. Obtener dependencias
flutter pub get

# 3. Ejecutar en modo debug
flutter run

# 4. (Opcional) Build para producción
flutter build apk          # Android
flutter build ios          # iOS
flutter build linux        # Linux
flutter build windows      # Windows
```

---

## Uso

1. **Registrarse** como comprador (nombre, correo, teléfono)
2. Navegar por el **catálogo** de propiedades
3. Tocar una propiedad para ver su **detalle** completo
4. Presionar **"Agendar Visita"**
5. Seleccionar **fecha** y **horario** disponibles
6. Elegir un **agente inmobiliario**
7. **Confirmar** la reserva
8. Consultar, **modificar** o **cancelar** reservas desde "Mis Reservas"

---

## API

La aplicación consume una API REST pública de propiedades inmobiliarias. Los endpoints consultados devuelven datos en formato JSON con información como precio, ubicación, imágenes, características y datos del agente.

Si la API no está disponible, la aplicación funciona con datos en caché o con datos de respaldo incluidos en el proyecto.

---

## Datos de prueba

El archivo `assets/data/properties.json` contiene propiedades de respaldo con la misma estructura que la API, permitiendo probar la app sin conexión.

```

```
