CREATE TABLE registro_compra (
    id_compra   SERIAL        PRIMARY KEY,
    cif         VARCHAR(9)    NOT NULL,
    codigo_ean  VARCHAR(13)   NOT NULL,
    fecha       DATE          NOT NULL DEFAULT CURRENT_DATE,
    unidades    INT           NOT NULL CHECK (unidades > 0),
    precio      NUMERIC(10,2) NOT NULL CHECK (precio > 0),
    FOREIGN KEY (cif)        REFERENCES proveedor(cif),
    FOREIGN KEY (codigo_ean) REFERENCES catalogo_productos(codigo_ean)
);
