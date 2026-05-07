-- Índices para optimizar las consultas más frecuentes

-- registro_compra: búsquedas por producto y por fecha
CREATE INDEX IF NOT EXISTS idx_compra_codigo_ean
    ON registro_compra(codigo_ean);

CREATE INDEX IF NOT EXISTS idx_compra_fecha
    ON registro_compra(fecha);

CREATE INDEX IF NOT EXISTS idx_compra_cif
    ON registro_compra(cif);

-- registro_venta: búsquedas por producto, cliente y fecha
CREATE INDEX IF NOT EXISTS idx_venta_codigo_ean
    ON registro_venta(codigo_ean);

CREATE INDEX IF NOT EXISTS idx_venta_fecha
    ON registro_venta(fecha);

CREATE INDEX IF NOT EXISTS idx_venta_id_cliente
    ON registro_venta(id_cliente);

-- reservas: búsquedas por cliente y producto
CREATE INDEX IF NOT EXISTS idx_reservas_id_cliente
    ON reservas(id_cliente);

CREATE INDEX IF NOT EXISTS idx_reservas_codigo_ean
    ON reservas(codigo_ean);

-- catalogo_productos: búsquedas por marca y tipo
CREATE INDEX IF NOT EXISTS idx_catalogo_marca
    ON catalogo_productos(marca);

CREATE INDEX IF NOT EXISTS idx_catalogo_tipo
    ON catalogo_productos(tipo);

-- log_operaciones: búsquedas por fecha y usuario
CREATE INDEX IF NOT EXISTS idx_log_fecha
    ON log_operaciones(fecha);

CREATE INDEX IF NOT EXISTS idx_log_usuario
    ON log_operaciones(usuario);
