-- Tabla que almacena los datos de los clientes de la tienda.
CREATE TABLE cliente (
    id_cliente  SERIAL       PRIMARY KEY,
    nombre      VARCHAR(150) NOT NULL,
    direccion   VARCHAR(250) NOT NULL,
    email       VARCHAR(100) NOT NULL
);
