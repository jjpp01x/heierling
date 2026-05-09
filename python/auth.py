import hashlib
from conexion import conectar

def hash_password(password):
    # Convertir la contraseña a hash SHA-256
    return hashlib.sha256(password.encode()).hexdigest()

def validar_password(password):
    # Comprobar longitud mínima
    if len(password) < 8:
        return False, "La contraseña debe tener al menos 8 caracteres."

    # Comprobar que tiene mayúsculas
    if not any(c.isupper() for c in password):
        return False, "La contraseña debe tener al menos una mayúscula."

    # Comprobar que tiene minúsculas
    if not any(c.islower() for c in password):
        return False, "La contraseña debe tener al menos una minúscula."

    # Comprobar que tiene números
    if not any(c.isdigit() for c in password):
        return False, "La contraseña debe tener al menos un número."

    # Comprobar que tiene símbolos
    if not any(c in "!@#$%^&*()_+-=[]{}|;':\",./<>?" for c in password):
        return False, "La contraseña debe tener al menos un símbolo."

    return True, "Contraseña válida."

def login():
    # Pedir credenciales al usuario
    print("=" * 40)
    print("   Sistema de Inventario Heierling")
    print("=" * 40)
    usuario = input("Usuario: ")
    password = input("Contraseña: ")

    # Hashear la contraseña para compararla con la BD
    password_hash = hash_password(password)

    # Verificar credenciales en la base de datos
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id_usuario, usuario, rol
        FROM usuarios
        WHERE usuario = %s
        AND password = %s
        AND activo = TRUE
    """, (usuario, password_hash))

    resultado = cursor.fetchone()
    cursor.close()
    conn.close()

    # Si las credenciales son incorrectas denegar acceso
    if resultado is None:
        print("Usuario o contraseña incorrectos.")
        return None

    # Si son correctas mostrar bienvenida
    print(f"\nBienvenido {resultado[1]} — Rol: {resultado[2]}")
    return {"id": resultado[0], "usuario": resultado[1], "rol": resultado[2]}

def cambiar_password(usuario_sesion):
    # Solo el admin puede cambiar contraseñas de otros usuarios
    print("\n--- Cambiar contraseña ---")

    if usuario_sesion["rol"] == "admin":
        usuario_objetivo = input("Usuario a modificar (Enter para el tuyo): ")
        if usuario_objetivo == "":
            usuario_objetivo = usuario_sesion["usuario"]
    else:
        # Un empleado solo puede cambiar su propia contraseña
        usuario_objetivo = usuario_sesion["usuario"]

    # Pedir la contraseña actual para verificar identidad
    password_actual = input("Contraseña actual: ")
    password_hash_actual = hash_password(password_actual)

    # Verificar que la contraseña actual es correcta
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id_usuario FROM usuarios
        WHERE usuario = %s AND password = %s
    """, (usuario_objetivo, password_hash_actual))

    if cursor.fetchone() is None:
        print("Contraseña actual incorrecta.")
        cursor.close()
        conn.close()
        return

    # Pedir la nueva contraseña y validarla
    nueva_password = input("Nueva contraseña: ")
    valida, mensaje = validar_password(nueva_password)

    if not valida:
        print(f"Error: {mensaje}")
        cursor.close()
        conn.close()
        return

    # Guardar la nueva contraseña hasheada
    nuevo_hash = hash_password(nueva_password)
    cursor.execute("""
        UPDATE usuarios
        SET password = %s
        WHERE usuario = %s
    """, (nuevo_hash, usuario_objetivo))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Contraseña de {usuario_objetivo} actualizada correctamente.")
