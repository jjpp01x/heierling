CREATE OR REPLACE FUNCTION convertir_reserva_en_venta(
    p_id_reserva  INT,
    p_precio      NUMERIC(10,2)
)
RETURNS VOID AS $$
DECLARE
    v_codigo_ean  CHAR(13);
    v_id_cliente  INT;
    v_stock       INT;
BEGIN
    -- VALIDACIÓN 1: La reserva debe existir
    IF NOT EXISTS (
        SELECT 1 FROM reservas
        WHERE id_reserva = p_id_reserva
    ) THEN
        RAISE EXCEPTION 'Reserva con ID % no encontrada.', p_id_reserva;
    END IF;

    -- VALIDACIÓN 2: El precio debe ser positivo
    IF p_precio <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser un número positivo.';
    END IF;

    -- Recuperar datos de la reserva
    SELECT codigo_ean, id_cliente
    INTO v_codigo_ean, v_id_cliente
    FROM reservas
    WHERE id_reserva = p_id_reserva;

    -- VALIDACIÓN 3: Comprobar stock disponible
    SELECT unidades INTO v_stock
    FROM inventario
    WHERE codigo_ean = v_codigo_ean;

    IF v_stock IS NULL OR v_stock <= 0 THEN
        RAISE EXCEPTION 'Sin stock disponible para el producto %.', v_codigo_ean;
    END IF;

    -- OPERACIÓN 1: Registrar la venta
    INSERT INTO registro_venta (
        id_cliente,
        codigo_ean,
        fecha,
        unidades,
        precio
    )
    VALUES (
        v_id_cliente,
        v_codigo_ean,
        CURRENT_DATE,
        1,
        p_precio
    );

    -- OPERACIÓN 2: Descontar stock del inventario
    UPDATE inventario
    SET unidades = unidades - 1
    WHERE codigo_ean = v_codigo_ean;

    -- OPERACIÓN 3: Eliminar la reserva
    DELETE FROM reservas
    WHERE id_reserva = p_id_reserva;

    -- Avisar si el stock queda en 0
    IF v_stock - 1 = 0 THEN
        RAISE NOTICE 'AVISO: El producto % ha agotado su stock.', v_codigo_ean;
    END IF;

    RAISE NOTICE 'Reserva % convertida en venta correctamente para el cliente %.',
        p_id_reserva, v_id_cliente;
END;
$$ LANGUAGE plpgsql;
