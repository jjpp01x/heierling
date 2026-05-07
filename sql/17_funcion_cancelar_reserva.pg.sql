CREATE OR REPLACE FUNCTION cancelar_reserva(
    p_id_reserva INT
)
RETURNS VOID AS $$
DECLARE
    v_codigo_ean CHAR(13);
    v_id_cliente INT;
BEGIN
    -- Comprobar que la reserva existe
    IF NOT EXISTS (
        SELECT 1 FROM reservas
        WHERE id_reserva = p_id_reserva
    ) THEN
        RAISE EXCEPTION 'Reserva con ID % no encontrada.', p_id_reserva;
    END IF;

    -- Guardar datos de la reserva antes de eliminarla
    SELECT codigo_ean, id_cliente
    INTO v_codigo_ean, v_id_cliente
    FROM reservas
    WHERE id_reserva = p_id_reserva;

    -- Eliminar la reserva
    DELETE FROM reservas
    WHERE id_reserva = p_id_reserva;

    -- Devolver las unidades al inventario
    UPDATE inventario
    SET unidades = unidades + 1
    WHERE codigo_ean = v_codigo_ean;

    RAISE NOTICE 'Reserva % cancelada. Unidades de % devueltas al inventario.',
        p_id_reserva, v_codigo_ean;
END;
$$ LANGUAGE plpgsql;
