-- ─────────────────────────────────────────────────────────────
-- PROVEEDORES
-- ─────────────────────────────────────────────────────────────
INSERT INTO proveedor (cif, nombre_empresa, telefono, email)
VALUES
    ('A12345678', 'Salomon S.L.',      '976100200', 'pedidos@salomon.es'),
    ('B87654321', 'Atomic S.A.',      '932200100', 'info@atomic.es'),
    ('C11223344', 'K2 S.L.','911300400', 'ventas@k2.es');

-- ─────────────────────────────────────────────────────────────
-- PRODUCTOS
-- ─────────────────────────────────────────────────────────────
SELECT alta_producto('8410000000001', 'Dobermann SP 130',  'Nordica',   'Alpino',    42.0);
SELECT alta_producto('8410000000002', 'Dobermann SP 130',  'Nordica',   'Alpino',    43.0);
SELECT alta_producto('8410000000003', 'Dobermann SP 130',  'Nordica',   'Alpino',    44.0);
SELECT alta_producto('8410000000004', 'Hero World Cup ZB', 'Rossignol', 'Alpino',    42.0);
SELECT alta_producto('8410000000005', 'Hero World Cup ZB', 'Rossignol', 'Alpino',    43.0);
SELECT alta_producto('8410000000006', 'Hawx Ultra 130',    'Atomic',    'Freeride',  42.0);
SELECT alta_producto('8410000000007', 'Hawx Ultra 130',    'Atomic',    'Freeride',  44.0);

-- ─────────────────────────────────────────────────────────────
-- CLIENTES
-- ─────────────────────────────────────────────────────────────
INSERT INTO cliente (nombre, direccion, email)
VALUES
    ('Carlos Pérez',   'Calle Mayor 12, Zaragoza',   'carlos@email.com'),
    ('Laura Martínez', 'Av. Libertad 5, Madrid',     'laura@email.com'),
    ('Pedro Sánchez',  'Paseo Gracia 30, Barcelona', 'pedro@email.com');

-- ─────────────────────────────────────────────────────────────
-- COMPRAS
-- ─────────────────────────────────────────────────────────────
SELECT compra_producto('A12345678', '8410000000001', 10, 289.99, '2025-01-10');
SELECT compra_producto('A12345678', '8410000000002', 10, 289.99, '2025-01-10');
SELECT compra_producto('A12345678', '8410000000003',  5, 289.99, '2025-01-10');
SELECT compra_producto('B87654321', '8410000000004',  8, 310.00, '2025-02-15');
SELECT compra_producto('B87654321', '8410000000005',  8, 310.00, '2025-02-15');
SELECT compra_producto('C11223344', '8410000000006',  6, 350.00, '2025-03-20');
SELECT compra_producto('C11223344', '8410000000007',  6, 350.00, '2025-03-20');

-- ─────────────────────────────────────────────────────────────
-- VENTAS
-- ─────────────────────────────────────────────────────────────
SELECT venta_producto(1, '8410000000001', 2, 399.00, '2025-04-01');
SELECT venta_producto(2, '8410000000004', 1, 420.00, '2025-04-05');
SELECT venta_producto(3, '8410000000006', 1, 480.00, '2025-04-10');

-- ─────────────────────────────────────────────────────────────
-- RESERVAS
-- ─────────────────────────────────────────────────────────────
INSERT INTO reservas (id_cliente, codigo_ean, fecha_reserva)
VALUES
    (1, '8410000000002', '2025-04-15'),
    (2, '8410000000005', '2025-04-16'),
    (3, '8410000000007', '2025-04-17');

-- ─────────────────────────────────────────────────────────────
-- PRUEBAS DE CONSULTA
-- ─────────────────────────────────────────────────────────────
SELECT * FROM existencias_producto('8410000000001');
SELECT * FROM compras_anuales(2025);
SELECT * FROM ventas_anuales(2025);
