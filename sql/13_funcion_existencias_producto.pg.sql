CREATE OR REPLACE FUNCTION existencias_producto(
    p_codigo_ean CHAR(13)
)
RETURNS TABLE(
    codigo_ean    CHAR(13),
    nombre_modelo VARCHAR(200),
    marca         VARCHAR(100),
    tipo          VARCHAR(60),
    talla         NUMERIC(3,1),
    unidades      INT
) AS $$
BEGIN
    -- Comprobar que el producto existe
    IF NOT EXISTS (
        SELECT 1 FROM catalogo_productos
        WHERE catalogo_productos.codigo_ean = p_codigo_ean
    ) THEN
        RAISE EXCEPTION 'Producto % no encontrado.', p_codigo_ean;
    END IF;

    -- Comprobar que tiene registro en inventario
    IF NOT EXISTS (
        SELECT 1 FROM inventario
        WHERE inventario.codigo_ean = p_codigo_ean
    ) THEN
        RAISE EXCEPTION 'El producto % no tiene unidades en inventario.', p_codigo_ean;
    END IF;

    -- Devolver existencias con datos completos del producto
    RETURN QUERY
    SELECT
        cp.codigo_ean,
        cp.nombre_modelo,
        cp.marca,
        cp.tipo,
        cp.talla,
        i.unidades
    FROM catalogo_productos cp
    JOIN inventario i ON i.codigo_ean = cp.codigo_ean
    WHERE cp.codigo_ean = p_codigo_ean;

    -- Avisar si el stock es bajo (tiene 1 unidad)
    IF (SELECT i.unidades FROM inventario i
   	 WHERE i.codigo_ean = p_codigo_ean) < 1 THEN
   	 RAISE NOTICE 'AVISO. El producto % tiene 1 unidad en stock.', p_codigo_ean;
    END IF;
END;
$$ LANGUAGE plpgsql;
