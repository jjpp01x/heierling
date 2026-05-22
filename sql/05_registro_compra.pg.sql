-- Tabla que almacena el historial de compras realizadas a proveedores, con unidades adquiridas y precio unitario.
CREATE TABLE registro_compra (
    id_compra   SERIAL        PRIMARY KEY,
    cif         VARCHAR(9)    NOT NULL,
    codigo_ean  VARCHAR(13)   NOT NULL,
    fecha       DATE          NOT NULL DEFAULT CURRENT_DATE,
    unidades    INT           NOT NULL,
    precio      NUMERIC(10,2) NOT NULL,
    FOREIGN KEY (cif)        REFERENCES proveedor(cif),
    FOREIGN KEY (codigo_ean) REFERENCES catalogo_productos(codigo_ean),
    CONSTRAINT chk_unidades  CHECK (unidades > 0),
    CONSTRAINT chk_precio    CHECK (precio > 0)
);
