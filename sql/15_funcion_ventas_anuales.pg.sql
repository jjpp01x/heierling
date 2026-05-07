CREATE OR REPLACE FUNCTION ventas_anuales(
    p_anio INT
)
RETURNS TABLE(
    codigo_ean     CHAR(13),
    nombre_modelo  VARCHAR(200),
    marca          VARCHAR(100),
    total_unidades BIGINT,
    importe_total  NUMERIC
) AS $$
BEGIN
    -- Comprobar que el año es válido
    IF p_anio < 2000 OR p_anio > EXTRACT(YEAR FROM CURRENT_DATE) THEN
        RAISE EXCEPTION 'El año % no es válido.', p_anio;
    END IF;

    -- Comprobar que hay ventas registradas ese año
    IF NOT EXISTS (
        SELECT 1 FROM registro_venta
        WHERE EXTRACT(YEAR FROM fecha) = p_anio
    ) THEN
        RAISE EXCEPTION 'No hay ventas registradas en el año %.', p_anio;
    END IF;

    -- Devolver resumen de ventas del año
    RETURN QUERY
    SELECT
        cp.codigo_ean,
        cp.nombre_modelo,
        cp.marca,
        SUM(rv.unidades)::BIGINT      AS total_unidades,
        SUM(rv.unidades * rv.precio)  AS importe_total
    FROM registro_venta rv
    JOIN catalogo_productos cp ON cp.codigo_ean = rv.codigo_ean
    WHERE EXTRACT(YEAR FROM rv.fecha) = p_anio
    GROUP BY cp.codigo_ean, cp.nombre_modelo, cp.marca
    ORDER BY importe_total DESC;

    RAISE NOTICE 'Informe de ventas del año % generado correctamente.', p_anio;
END;
$$ LANGUAGE plpgsql;
