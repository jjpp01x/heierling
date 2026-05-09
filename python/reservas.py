from conexion import conectar
from auth import login

def crear_reserva():
    # Pedir datos de la reserva al usuario
    id_cliente = input("ID del cliente: ")
    ean = input("Codigo EAN del producto: ")
    fecha = input("Fecha de reserva (YYYY-MM-DD) o Enter para hoy: ")

    # Conectar a la base de datos
    conn = conectar()
    cursor = conn.cursor()

    # Si no introduce fecha se usa la fecha actual
    if fecha == "":
        cursor.execute("""
            INSERT INTO reservas (id_cliente, codigo_ean)
            VALUES (%s, %s)
        """, (id_cliente, ean))
    else:
        cursor.execute("""
            INSERT INTO reservas (id_cliente, codigo_ean, fecha_reserva)
            VALUES (%s, %s, %s)
        """, (id_cliente, ean, fecha))

    # Confirmar y cerrar conexión
    conn.commit()
    cursor.close()
    conn.close()
    print("Reserva creada correctamente.")

def reservas_cliente():
    # Pedir el ID del cliente
    id_cliente = input("ID del cliente: ")

    # Consultar reservas con JOIN para obtener datos del producto
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT r.id_reserva, cp.nombre_modelo, cp.marca,
               cp.talla, r.fecha_reserva
        FROM reservas r
        JOIN catalogo_productos cp ON cp.codigo_ean = r.codigo_ean
        WHERE r.id_cliente = %s
        ORDER BY r.fecha_reserva
    """, (id_cliente,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar reservas o aviso si no hay ninguna
    if filas:
        print("\nID | Nombre modelo | Marca | Talla | Fecha reserva")
        print("-" * 65)
        for fila in filas:
            print(f"{fila[0]:<5} {fila[1]:<25} {fila[2]:<12} {fila[3]:<8} {fila[4]}")
    else:
        print("No hay reservas para este cliente.")

def convertir_reserva_en_venta():
    # Pedir el ID de la reserva y el precio de venta
    id_reserva = input("ID de la reserva: ")
    precio = input("Precio de venta: ")

    # Llamar a la función SQL que registra la venta y elimina la reserva
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT convertir_reserva_en_venta(%s, %s)",
                   (id_reserva, precio))
    conn.commit()
    cursor.close()
    conn.close()
    print("Reserva convertida en venta correctamente.")

def cancelar_reserva():
    # Pedir el ID de la reserva a cancelar
    id_reserva = input("ID de la reserva a cancelar: ")

    # Llamar a la función SQL que elimina la reserva y devuelve el stock
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT cancelar_reserva(%s)", (id_reserva,))
    conn.commit()
    cursor.close()
    conn.close()
    print("Reserva cancelada correctamente.")

if __name__ == "__main__":
    # Verificar credenciales antes de acceder al sistema
    usuario = login()
    if usuario is None:
        exit()

    # Ambos roles pueden crear reservas, ver reservas y convertirlas en venta
    print("\n1. Crear reserva")
    print("2. Ver reservas de un cliente")
    print("3. Convertir reserva en venta")

    # Solo el admin puede cancelar reservas
    if usuario["rol"] == "admin":
        print("4. Cancelar reserva")

    opcion = input("Elige una opcion: ")

    if opcion == "1":
        crear_reserva()
    elif opcion == "2":
        reservas_cliente()
    elif opcion == "3":
        convertir_reserva_en_venta()
    elif opcion == "4" and usuario["rol"] == "admin":
        cancelar_reserva()
    else:
        print("Opcion no valida o sin permisos.")
