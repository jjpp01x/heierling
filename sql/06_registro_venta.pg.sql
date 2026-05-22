-- Tabla que almacena el historial de ventas realizadas a clientes, con unidades vendidas y precio unitario.
CREATE TABLE registro_venta (
    id_venta    SERIAL        PRIMARY KEY,
    id_cliente  INT           NOT NULL,
    codigo_ean  VARCHAR(13)   NOT NULL,
    fecha       DATE          NOT NULL DEFAULT CURRENT_DATE,
    unidades    INT           NOT NULL,
    precio      NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (codigo_ean) REFERENCES catalogo_productos(codigo_ean),
    CONSTRAINT chk_unidades  CHECK (unidades > 0),
    CONSTRAINT chk_precio    CHECK (precio > 0)
);
