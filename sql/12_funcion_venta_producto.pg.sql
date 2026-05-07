CREATE OR REPLACE FUNCTION venta_producto(
    p_id_cliente INT,
    p_codigo_ean CHAR(13),
    p_unidades   INT,
    p_precio     NUMERIC(10,2),
    p_fecha      DATE DEFAULT CURRENT_DATE
)
RETURNS VOID AS $$
DECLARE
    v_stock INT;
BEGIN
    -- Comprobar que el cliente existe
    IF NOT EXISTS (
        SELECT 1 FROM cliente
        WHERE id_cliente = p_id_cliente
    ) THEN
        RAISE EXCEPTION 'Cliente con ID % no encontrado.', p_id_cliente;
    END IF;

    -- Comprobar que el producto existe
    IF NOT EXISTS (
        SELECT 1 FROM catalogo_productos
        WHERE codigo_ean = p_codigo_ean
    ) THEN
        RAISE EXCEPTION 'Producto % no encontrado.', p_codigo_ean;
    END IF;

    -- Comprobar que las unidades son positivas
    IF p_unidades <= 0 THEN
        RAISE EXCEPTION 'Las unidades deben ser un número positivo.';
    END IF;

    -- Comprobar que el precio es positivo
    IF p_precio <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser un número positivo.';
    END IF;

    -- Comprobar que la fecha no es futura
    IF p_fecha > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de venta no puede ser futura.';
    END IF;

    -- Comprobar stock suficiente
    SELECT unidades INTO v_stock
    FROM inventario
    WHERE codigo_ean = p_codigo_ean;

    IF v_stock IS NULL OR v_stock < p_unidades THEN
        RAISE EXCEPTION 'Stock insuficiente: disponible=%, solicitado=%.',
            COALESCE(v_stock, 0), p_unidades;
    END IF;

    -- Registrar la venta
    INSERT INTO registro_venta (
        id_cliente,
        codigo_ean,
        fecha,
        unidades,
        precio
    )
    VALUES (
        p_id_cliente,
        p_codigo_ean,
        p_fecha,
        p_unidades,
        p_precio
    );

    -- Descontar stock del inventario
    UPDATE inventario
    SET unidades = unidades - p_unidades
    WHERE codigo_ean = p_codigo_ean;

    -- Avisar si el stock queda en 0
    IF v_stock - p_unidades = 0 THEN
        RAISE NOTICE 'AVISO: El producto % ha agotado su stock.', p_codigo_ean;
    END IF;

    RAISE NOTICE 'Venta registrada: % unidades de % al cliente %.',
        p_unidades, p_codigo_ean, p_id_cliente;
END;
$$ LANGUAGE plpgsql;
