# Heierling — Sistema Gestor de Inventario

Sistema de gestión de inventario para una tienda de botas de esquí a medida.
Desarrollado como trabajo práctico para el módulo de Information Engineering (CEAC4010)
del BSc (Hons) in Applied Computing en CESTE Escuela Internacional de Negocios.

## Descripción del negocio

Heierling es una tienda especializada en botas de esquí a medida que opera con
tres espacios de almacenamiento:
- **Almacén exterior**: stock principal de todos los modelos
- **Tienda**: un ejemplar de cada modelo y talla para exposición y venta
- **Reservas**: botas separadas para clientes que han solicitado guardarlas

## Tecnologías utilizadas

- PostgreSQL 16
- Python 3.11
- psycopg2
- Docker y Docker Compose

## Estructura del proyecto

heierling/
├── Dockerfile
├── docker-compose.yml
├── .env.example
├── sql/
│   ├── 01_proveedor.pg.sql
│   ├── 02_catalogo_productos.pg.sql
│   ├── 03_inventario.pg.sql
│   ├── 04_cliente.pg.sql
│   ├── 05_registro_compra.pg.sql
│   ├── 06_registro_venta.pg.sql
│   ├── 07_reservas.pg.sql
│   ├── 08_funcion_alta_producto.pg.sql
│   ├── 09_funcion_baja_producto.pg.sql
│   ├── 10_funcion_renombrar_producto.pg.sql
│   ├── 11_funcion_compra_producto.pg.sql
│   ├── 12_funcion_venta_producto.pg.sql
│   ├── 13_funcion_existencias_producto.pg.sql
│   ├── 14_funcion_compras_anuales.pg.sql
│   ├── 15_funcion_ventas_anuales.pg.sql
│   ├── 16_datos_prueba.pg.sql
│   ├── 17_funcion_cancelar_reserva.pg.sql
│   ├── 18_funcion_inventario_completo.pg.sql
│   ├── 19_funcion_convertir_reserva_venta.pg.sql
│   ├── 20_auditoria_trigger.pg.sql
│   ├── 21_vista_inventario.pg.sql
│   ├── 22_indices.pg.sql
│   └── 23_usuarios.pg.sql
└── python/
├── conexion.py
├── auth.py
├── productos.py
├── inventario.py
├── compras.py
├── ventas.py
├── reservas.py
└── usuarios.py

## Instalación y ejecución con Docker

### Requisitos
- Docker
- Docker Compose

### Pasos

1. Clonar el repositorio
```bash
git clone https://github.com/jjpp01x/heierling.git
cd heierling
```

2. Crear el archivo .env con las credenciales
```bash
cp .env.example .env
```

3. Editar el .env con tus credenciales

POSTGRES_HOST=db
POSTGRES_DB=heierling
POSTGRES_USER=hans
POSTGRES_PASSWORD=tu_contraseña

4. Arrancar los contenedores
```bash
docker compose up
```

La base de datos se inicializa automáticamente con todas las tablas,
funciones, trigger, vista, índices y usuarios.

## Uso

Cada módulo Python se ejecuta de forma independiente:

```bash
# Gestión de productos
docker exec -it heierling_app python3 productos.py

# Gestión de inventario
docker exec -it heierling_app python3 inventario.py

# Registro de compras
docker exec -it heierling_app python3 compras.py

# Registro de ventas
docker exec -it heierling_app python3 ventas.py

# Gestión de reservas
docker exec -it heierling_app python3 reservas.py

# Gestión de usuarios
docker exec -it heierling_app python3 usuarios.py
```

## Credenciales por defecto

| Usuario | Contraseña | Rol |
|---------|------------|-----|
| admin | He1erl!ng24 | admin |
| empleado | Sk1B00t$24 | empleado |

## Roles y permisos

| Función | Admin | Empleado |
|---------|-------|----------|
| Alta de producto | ✓ | ✗ |
| Baja de producto | ✓ | ✗ |
| Renombrar producto | ✓ | ✗ |
| Buscar producto | ✓ | ✓ |
| Registrar compra | ✓ | ✗ |
| Compras anuales | ✓ | ✗ |
| Historial compras proveedor | ✓ | ✓ |
| Registrar venta | ✓ | ✓ |
| Ventas anuales | ✓ | ✗ |
| Historial ventas cliente | ✓ | ✓ |
| Existencias producto | ✓ | ✓ |
| Inventario completo | ✓ | ✓ |
| Inventario por marca | ✓ | ✓ |
| Crear reserva | ✓ | ✓ |
| Ver reservas cliente | ✓ | ✓ |
| Convertir reserva en venta | ✓ | ✓ |
| Cancelar reserva | ✓ | ✗ |
| Gestión de usuarios | ✓ | ✗ |

## Base de datos

### Tablas
- `proveedor` — empresas suministradoras
- `catalogo_productos` — catálogo con EAN, marca, tipo y talla
- `inventario` — unidades disponibles por producto
- `cliente` — clientes de la tienda
- `registro_compra` — entradas de stock
- `registro_venta` — salidas de stock
- `reservas` — botas separadas para clientes
- `usuarios` — usuarios del sistema con contraseñas hasheadas

### Funciones (10)
Alta, baja y renombrado de productos, compra, venta, existencias,
compras anuales, ventas anuales, cancelar reserva y convertir reserva en venta.

### Seguridad
- Autenticación con login obligatorio en todos los módulos
- Contraseñas hasheadas con SHA-256
- Control de acceso por rol (admin/empleado)
- Validación de contraseñas seguras (mayúsculas, minúsculas, números y símbolos)
- Usuarios activables y desactivables sin borrar historial

### Extras
- Trigger de auditoría sobre la tabla inventario
- Vista `vista_inventario` con ubicación deducida
- 12 índices para optimizar consultas frecuentes
