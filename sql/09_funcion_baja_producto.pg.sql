CREATE OR REPLACE FUNCTION baja_producto(p_codigo_ean CHAR(13))
RETURNS VOID AS $$
DECLARE
    v_stock INT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM catalogo_productos
        WHERE codigo_ean = p_codigo_ean) THEN
        RAISE EXCEPTION 'Producto % no encontrado.', p_codigo_ean;
    END IF;
    IF EXISTS (SELECT 1 FROM reservas
        WHERE codigo_ean = p_codigo_ean) THEN
        RAISE EXCEPTION 'El producto % tiene reservas activas.', p_codigo_ean;
    END IF;
    SELECT unidades INTO v_stock FROM inventario
    WHERE codigo_ean = p_codigo_ean;
    IF v_stock > 0 THEN
        RAISE EXCEPTION 'El producto % tiene % unidades en inventario.',
            p_codigo_ean, v_stock;
    END IF;
    IF EXISTS (SELECT 1 FROM registro_compra WHERE codigo_ean = p_codigo_ean)
    OR EXISTS (SELECT 1 FROM registro_venta WHERE codigo_ean = p_codigo_ean) THEN
        RAISE NOTICE 'Producto % con historial. Se mantiene como inactivo.',
            p_codigo_ean;
        RETURN;
    END IF;
    DELETE FROM inventario WHERE codigo_ean = p_codigo_ean;
    DELETE FROM catalogo_productos WHERE codigo_ean = p_codigo_ean;
    RAISE NOTICE 'Producto % eliminado correctamente.', p_codigo_ean;
END;
$$ LANGUAGE plpgsql;
