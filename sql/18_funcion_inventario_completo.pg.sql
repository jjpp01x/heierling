CREATE OR REPLACE FUNCTION inventario_completo()
RETURNS TABLE(
    codigo_ean    CHAR(13),
    nombre_modelo VARCHAR(200),
    marca         VARCHAR(100),
    tipo          VARCHAR(60),
    talla         NUMERIC(3,1),
    unidades      INT,
    ubicacion     VARCHAR(20)
) AS $$
BEGIN
    -- Comprobar que hay productos en el inventario
    IF NOT EXISTS (
        SELECT 1 FROM inventario
    ) THEN
        RAISE EXCEPTION 'El inventario está vacío.';
    END IF;

    -- Devolver inventario completo con ubicación deducida
    -- Regla de negocio: 1 unidad = tienda, más de 1 = almacén exterior
    RETURN QUERY
    SELECT
        cp.codigo_ean,
        cp.nombre_modelo,
        cp.marca,
        cp.tipo,
        cp.talla,
        i.unidades,
        CASE
            WHEN i.unidades = 1 THEN 'TIENDA'::VARCHAR(20)
            WHEN i.unidades = 0 THEN 'SIN STOCK'::VARCHAR(20)
            ELSE 'ALMACEN EXTERIOR'::VARCHAR(20)
        END AS ubicacion
    FROM inventario i
    JOIN catalogo_productos cp ON cp.codigo_ean = i.codigo_ean
    ORDER BY cp.marca, cp.nombre_modelo, cp.talla;

    RAISE NOTICE 'Inventario completo generado correctamente.';
END;
$$ LANGUAGE plpgsql;
