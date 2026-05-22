-- Tabla que almacena las reservas activas de botas apartadas por clientes pendientes de conversión en venta.
CREATE TABLE reservas (
    id_reserva    SERIAL        PRIMARY KEY,
    id_cliente    INT           NOT NULL,
    codigo_ean    VARCHAR(13)   NOT NULL,
    fecha_reserva DATE          NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (codigo_ean) REFERENCES catalogo_productos(codigo_ean)
);
