CREATE TABLE inventario (
    codigo_ean  CHAR(13) NOT NULL,
    unidades    INT      NOT NULL DEFAULT 0,
    PRIMARY KEY (codigo_ean),
    FOREIGN KEY (codigo_ean) REFERENCES catalogo_productos(codigo_ean)
);
