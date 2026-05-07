CREATE TABLE catalogo_productos (
    codigo_ean     CHAR(13)     NOT NULL,
    nombre_modelo  VARCHAR(200) NOT NULL,
    marca          VARCHAR(100) NOT NULL,
    tipo           VARCHAR(60)  NOT NULL,
    talla          NUMERIC(3,1) NOT NULL,
    PRIMARY KEY (codigo_ean)
);
