CREATE OR REPLACE FUNCTION renombrar_producto(
    p_codigo_ean    CHAR(13),
    p_nuevo_nombre  VARCHAR(200)
)
RETURNS VOID AS $$
DECLARE
    v_nombre_anterior VARCHAR(200);
BEGIN
    -- Comprobar que el producto existe
    IF NOT EXISTS (
        SELECT 1 FROM catalogo_productos
        WHERE codigo_ean = p_codigo_ean
    ) THEN
        RAISE EXCEPTION 'Producto % no encontrado.', p_codigo_ean;
    END IF;

    -- Comprobar que el nuevo nombre no está vacío
    IF TRIM(p_nuevo_nombre) = '' THEN
        RAISE EXCEPTION 'El nuevo nombre no puede estar vacío.';
    END IF;

    -- Guardar el nombre anterior para el mensaje de confirmación
    SELECT nombre_modelo INTO v_nombre_anterior
    FROM catalogo_productos
    WHERE codigo_ean = p_codigo_ean;

    -- Comprobar que el nuevo nombre es distinto al actual
    IF v_nombre_anterior = p_nuevo_nombre THEN
        RAISE EXCEPTION 'El nuevo nombre es igual al actual.';
    END IF;

    -- Actualizar el nombre
    UPDATE catalogo_productos
    SET nombre_modelo = p_nuevo_nombre
    WHERE codigo_ean = p_codigo_ean;

    RAISE NOTICE 'Producto renombrado de "%" a "%".',
        v_nombre_anterior, p_nuevo_nombre;
END;
$$ LANGUAGE plpgsql;

