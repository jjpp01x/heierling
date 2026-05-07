CREATE OR REPLACE FUNCTION compras_anuales(
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

    -- Comprobar que hay compras registradas ese año
    IF NOT EXISTS (
        SELECT 1 FROM registro_compra
        WHERE EXTRACT(YEAR FROM fecha) = p_anio
    ) THEN
        RAISE EXCEPTION 'No hay compras registradas en el año %.', p_anio;
    END IF;

    -- Devolver resumen de compras del año
    RETURN QUERY
    SELECT
        cp.codigo_ean,
        cp.nombre_modelo,
        cp.marca,
        SUM(rc.unidades)::BIGINT      AS total_unidades,
        SUM(rc.unidades * rc.precio)  AS importe_total
    FROM registro_compra rc
    JOIN catalogo_productos cp ON cp.codigo_ean = rc.codigo_ean
    WHERE EXTRACT(YEAR FROM rc.fecha) = p_anio
    GROUP BY cp.codigo_ean, cp.nombre_modelo, cp.marca
    ORDER BY importe_total DESC;

    RAISE NOTICE 'Informe de compras del año % generado correctamente.', p_anio;
END;
$$ LANGUAGE plpgsql;
