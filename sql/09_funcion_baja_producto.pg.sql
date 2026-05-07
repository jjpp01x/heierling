CREATE OR REPLACE FUNCTION baja_producto(
    p_codigo_ean CHAR(13)
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM catalogo_productos
        WHERE codigo_ean = p_codigo_ean
    ) THEN
        RAISE EXCEPTION 'Producto % no encontrado.', p_codigo_ean;
    END IF;

    DELETE FROM inventario
    WHERE codigo_ean = p_codigo_ean;

    DELETE FROM catalogo_productos
    WHERE codigo_ean = p_codigo_ean;
END;
$$ LANGUAGE plpgsql;
