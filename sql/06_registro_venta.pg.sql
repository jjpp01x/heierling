CREATE TABLE registro_venta (
    id_venta    SERIAL        PRIMARY KEY,
    id_cliente  INT           NOT NULL,
    codigo_ean  VARCHAR(13)   NOT NULL,
    fecha       DATE          NOT NULL DEFAULT CURRENT_DATE,
    unidades    INT           NOT NULL CHECK (unidades > 0),
    precio      NUMERIC(10,2) NOT NULL CHECK (precio > 0),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (codigo_ean) REFERENCES catalogo_productos(codigo_ean)
);
