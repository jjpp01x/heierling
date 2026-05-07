CREATE OR REPLACE VIEW vista_inventario AS
SELECT
    cp.codigo_ean,
    cp.nombre_modelo,
    cp.marca,
    cp.tipo,
    cp.talla,
    i.unidades,
    CASE
        WHEN i.unidades = 0 THEN 'SIN STOCK'
        WHEN i.unidades = 1 THEN 'TIENDA'
        ELSE 'ALMACEN EXTERIOR'
    END AS ubicacion
FROM inventario i
JOIN catalogo_productos cp ON cp.codigo_ean = i.codigo_ean
ORDER BY cp.marca, cp.nombre_modelo, cp.talla;
