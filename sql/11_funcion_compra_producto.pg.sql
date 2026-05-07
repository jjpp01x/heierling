CREATE OR REPLACE FUNCTION compra_producto(
    p_cif        VARCHAR(9),
    p_codigo_ean CHAR(13),
    p_unidades   INT,
    p_precio     NUMERIC(10,2),
    p_fecha      DATE DEFAULT CURRENT_DATE
)
RETURNS VOID AS $$
BEGIN
    -- Comprobar que el proveedor existe
    IF NOT EXISTS (
        SELECT 1 FROM proveedor
        WHERE cif = p_cif
    ) THEN
        RAISE EXCEPTION 'Proveedor con CIF % no encontrado.', p_cif;
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
        RAISE EXCEPTION 'La fecha de compra no puede ser futura.';
    END IF;

    -- Registrar la compra
    INSERT INTO registro_compra (
        cif,
        codigo_ean,
        fecha,
        unidades,
        precio
    )
    VALUES (
        p_cif,
        p_codigo_ean,
        p_fecha,
        p_unidades,
        p_precio
    );

    -- Actualizar inventario con UPSERT
    INSERT INTO inventario (codigo_ean, unidades)
    VALUES (p_codigo_ean, p_unidades)
    ON CONFLICT (codigo_ean)
    DO UPDATE SET unidades = inventario.unidades + p_unidades;

    RAISE NOTICE 'Compra registrada: % unidades de % a %.€/ud.',
        p_unidades, p_codigo_ean, p_precio;
END;
$$ LANGUAGE plpgsql;
