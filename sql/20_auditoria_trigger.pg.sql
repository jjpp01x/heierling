CREATE TABLE IF NOT EXISTS log_operaciones (
    id_log      SERIAL       PRIMARY KEY,
    tabla       VARCHAR(50)  NOT NULL,
    operacion   VARCHAR(10)  NOT NULL,
    codigo_ean  CHAR(13),
    unidades_antes INT,
    unidades_despues INT,
    fecha       TIMESTAMP    NOT NULL DEFAULT NOW(),
    usuario     VARCHAR(50)  NOT NULL DEFAULT CURRENT_USER
);

-- Función que ejecuta el trigger
CREATE OR REPLACE FUNCTION fn_auditoria_inventario()
RETURNS TRIGGER AS $$
BEGIN
    -- Si es una inserción
    IF TG_OP = 'INSERT' THEN
        INSERT INTO log_operaciones (tabla, operacion, codigo_ean, unidades_antes, unidades_despues)
        VALUES ('inventario', 'INSERT', NEW.codigo_ean, 0, NEW.unidades);

    -- Si es una actualización
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO log_operaciones (tabla, operacion, codigo_ean, unidades_antes, unidades_despues)
        VALUES ('inventario', 'UPDATE', NEW.codigo_ean, OLD.unidades, NEW.unidades);

    -- Si es una eliminación
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO log_operaciones (tabla, operacion, codigo_ean, unidades_antes, unidades_despues)
        VALUES ('inventario', 'DELETE', OLD.codigo_ean, OLD.unidades, 0);
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Asociar el trigger a la tabla inventario
CREATE OR REPLACE TRIGGER tr_auditoria_inventario
AFTER INSERT OR UPDATE OR DELETE ON inventario
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_inventario();
