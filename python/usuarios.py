from conexion import conectar
from auth import login, hash_password, validar_password

def listar_usuarios():
    # Consultar todos los usuarios del sistema
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id_usuario, usuario, rol, activo
        FROM usuarios
        ORDER BY rol, usuario
    """)
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar usuarios o aviso si no hay ninguno
    if filas:
        print("\nID | Usuario | Rol | Activo")
        print("-" * 45)
        for fila in filas:
            activo = "Sí" if fila[3] else "No"
            print(f"{fila[0]:<5} {fila[1]:<20} {fila[2]:<12} {activo}")
    else:
        print("No hay usuarios registrados.")

def crear_usuario():
    # Pedir datos del nuevo usuario
    usuario = input("Nombre de usuario: ")
    password = input("Contraseña: ")
    rol = input("Rol (admin/empleado): ")

    # Validar que el rol es correcto
    if rol not in ["admin", "empleado"]:
        print("Rol no válido. Debe ser admin o empleado.")
        return

    # Validar que la contraseña cumple los requisitos
    valida, mensaje = validar_password(password)
    if not valida:
        print(f"Error: {mensaje}")
        return

    # Insertar el nuevo usuario con la contraseña hasheada
    conn = conectar()
    cursor = conn.cursor()

    # Comprobar que el usuario no existe ya
    cursor.execute("SELECT 1 FROM usuarios WHERE usuario = %s", (usuario,))
    if cursor.fetchone():
        print(f"El usuario {usuario} ya existe.")
        cursor.close()
        conn.close()
        return

    cursor.execute("""
        INSERT INTO usuarios (usuario, password, rol)
        VALUES (%s, %s, %s)
    """, (usuario, hash_password(password), rol))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Usuario {usuario} creado correctamente con rol {rol}.")

def desactivar_usuario():
    # Pedir el usuario a desactivar
    usuario = input("Usuario a desactivar: ")

    # No se puede desactivar a uno mismo
    conn = conectar()
    cursor = conn.cursor()

    # Comprobar que el usuario existe
    cursor.execute("SELECT activo FROM usuarios WHERE usuario = %s", (usuario,))
    resultado = cursor.fetchone()

    if resultado is None:
        print(f"El usuario {usuario} no existe.")
        cursor.close()
        conn.close()
        return

    if not resultado[0]:
        print(f"El usuario {usuario} ya está desactivado.")
        cursor.close()
        conn.close()
        return

    # Desactivar el usuario
    cursor.execute("""
        UPDATE usuarios SET activo = FALSE
        WHERE usuario = %s
    """, (usuario,))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Usuario {usuario} desactivado correctamente.")

def activar_usuario():
    # Pedir el usuario a activar
    usuario = input("Usuario a activar: ")

    conn = conectar()
    cursor = conn.cursor()

    # Comprobar que el usuario existe
    cursor.execute("SELECT activo FROM usuarios WHERE usuario = %s", (usuario,))
    resultado = cursor.fetchone()

    if resultado is None:
        print(f"El usuario {usuario} no existe.")
        cursor.close()
        conn.close()
        return

    if resultado[0]:
        print(f"El usuario {usuario} ya está activo.")
        cursor.close()
        conn.close()
        return

    # Activar el usuario
    cursor.execute("""
        UPDATE usuarios SET activo = TRUE
        WHERE usuario = %s
    """, (usuario,))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Usuario {usuario} activado correctamente.")

def cambiar_rol():
    # Pedir el usuario y el nuevo rol
    usuario = input("Usuario a modificar: ")
    nuevo_rol = input("Nuevo rol (admin/empleado): ")

    # Validar que el rol es correcto
    if nuevo_rol not in ["admin", "empleado"]:
        print("Rol no válido. Debe ser admin o empleado.")
        return

    conn = conectar()
    cursor = conn.cursor()

    # Comprobar que el usuario existe
    cursor.execute("SELECT 1 FROM usuarios WHERE usuario = %s", (usuario,))
    if cursor.fetchone() is None:
        print(f"El usuario {usuario} no existe.")
        cursor.close()
        conn.close()
        return

    # Actualizar el rol
    cursor.execute("""
        UPDATE usuarios SET rol = %s
        WHERE usuario = %s
    """, (nuevo_rol, usuario))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Rol de {usuario} cambiado a {nuevo_rol} correctamente.")

def cambiar_password_admin():
    # El admin puede cambiar la contraseña de cualquier usuario
    usuario = input("Usuario a modificar: ")
    nueva_password = input("Nueva contraseña: ")

    # Validar que la contraseña cumple los requisitos
    valida, mensaje = validar_password(nueva_password)
    if not valida:
        print(f"Error: {mensaje}")
        return

    conn = conectar()
    cursor = conn.cursor()

    # Comprobar que el usuario existe
    cursor.execute("SELECT 1 FROM usuarios WHERE usuario = %s", (usuario,))
    if cursor.fetchone() is None:
        print(f"El usuario {usuario} no existe.")
        cursor.close()
        conn.close()
        return

    # Actualizar la contraseña hasheada
    cursor.execute("""
        UPDATE usuarios SET password = %s
        WHERE usuario = %s
    """, (hash_password(nueva_password), usuario))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Contraseña de {usuario} actualizada correctamente.")

if __name__ == "__main__":
    # Verificar credenciales antes de acceder al sistema
    usuario = login()
    if usuario is None:
        exit()

    # Solo el admin puede gestionar usuarios
    if usuario["rol"] != "admin":
        print("No tienes permisos para acceder a la gestión de usuarios.")
        exit()

    print("\n1. Listar usuarios")
    print("2. Crear usuario")
    print("3. Desactivar usuario")
    print("4. Activar usuario")
    print("5. Cambiar rol")
    print("6. Cambiar contraseña")

    opcion = input("Elige una opcion: ")

    if opcion == "1":
        listar_usuarios()
    elif opcion == "2":
        crear_usuario()
    elif opcion == "3":
        desactivar_usuario()
    elif opcion == "4":
        activar_usuario()
    elif opcion == "5":
        cambiar_rol()
    elif opcion == "6":
        cambiar_password_admin()
    else:
        print("Opcion no valida.")
