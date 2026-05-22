-- Tabla que almacena los proveedores que suministran productos a la tienda.
CREATE TABLE proveedor (
    cif            VARCHAR(30)   NOT NULL,
    nombre_empresa VARCHAR(150) NOT NULL,
    telefono       VARCHAR(20)  NOT NULL,
    email          VARCHAR(100) NOT NULL,
    PRIMARY KEY(cif)
);
