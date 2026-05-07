CREATE OR REPLACE FUNCTION alta_producto(
    p_codigo_ean    CHAR(13),
    p_nombre_modelo VARCHAR(200),
    p_marca         VARCHAR(100),
    p_tipo          VARCHAR(60),
    p_talla         NUMERIC(3,1)
)
RETURNS VOID AS $$
BEGIN
    -- Validar longitud EAN
    IF LENGTH(TRIM(p_codigo_ean)) <> 13 THEN
        RAISE EXCEPTION 'El codigo EAN debe tener exactamente 13 caracteres.';
    END IF;

    -- Validar talla en rango válido
    IF p_talla < 35 OR p_talla > 50 THEN
        RAISE EXCEPTION 'La talla % no es válida. Debe estar entre 35 y 50.', p_talla;
    END IF;

    -- Validar que el producto no existe ya
    IF EXISTS (
        SELECT 1 FROM catalogo_productos
        WHERE codigo_ean = p_codigo_ean
    ) THEN
        RAISE EXCEPTION 'Ya existe un producto con el EAN %.', p_codigo_ean;
    END IF;

    -- Validar que nombre, marca y tipo no están vacíos
    IF TRIM(p_nombre_modelo) = '' THEN
        RAISE EXCEPTION 'El nombre del modelo no puede estar vacío.';
    END IF;

    IF TRIM(p_marca) = '' THEN
        RAISE EXCEPTION 'La marca no puede estar vacía.';
    END IF;

    IF TRIM(p_tipo) = '' THEN
        RAISE EXCEPTION 'El tipo no puede estar vacío.';
    END IF;

    INSERT INTO catalogo_productos (
        codigo_ean,
        nombre_modelo,
        marca,
        tipo,
        talla
    )
    VALUES (
        p_codigo_ean,
        p_nombre_modelo,
        p_marca,
        p_tipo,
        p_talla
    );

    RAISE NOTICE 'Producto % añadido correctamente.', p_nombre_modelo;
END;
$$ LANGUAGE plpgsql;
