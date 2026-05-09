-- Tabla para almacenar los usuarios del sistema
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario  SERIAL       PRIMARY KEY,
    usuario     VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(64)  NOT NULL,
    rol         VARCHAR(20)  NOT NULL DEFAULT 'empleado',
    activo      BOOLEAN      NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_rol CHECK (rol IN ('admin', 'empleado'))
);

-- Insertar usuario admin por defecto
-- La contraseña 'admin1234' se guarda como hash SHA-256
INSERT INTO usuarios (usuario, password, rol)
VALUES (
    'admin',
    encode(sha256('He1erl!ng24'::bytea), 'hex'),
    'admin'
);

-- Insertar usuario empleado por defecto
INSERT INTO usuarios (usuario, password, rol)
VALUES (
    'empleado',
    encode(sha256('sk1B00t$24'::bytea), 'hex'),
    'empleado'
);
