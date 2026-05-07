from conexion import conectar

def venta_producto():
    # Pedir datos de la venta al usuario
    id_cliente = input("ID del cliente: ")
    ean = input("Codigo EAN del producto: ")
    unidades = input("Unidades: ")
    precio = input("Precio unitario: ")
    fecha = input("Fecha (YYYY-MM-DD) o Enter para hoy: ")

    # Conectar a la base de datos
    conn = conectar()
    cursor = conn.cursor()

    # Si no introduce fecha se usa la fecha actual
    if fecha == "":
        cursor.execute("SELECT venta_producto(%s, %s, %s, %s)",
                       (id_cliente, ean, unidades, precio))
    else:
        cursor.execute("SELECT venta_producto(%s, %s, %s, %s, %s)",
                       (id_cliente, ean, unidades, precio, fecha))

    # Confirmar y cerrar conexión
    conn.commit()
    cursor.close()
    conn.close()
    print("Venta registrada correctamente.")

def ventas_anuales():
    # Pedir el año a consultar
    anio = input("Año a consultar: ")

    # Llamar a la función SQL que agrupa ventas por producto
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM ventas_anuales(%s)", (anio,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar resultados o aviso si no hay ventas ese año
    if filas:
        print(f"\nVentas del año {anio}:")
        print("\nCodigo EAN | Nombre modelo | Marca | Unidades | Importe total")
        print("-" * 75)
        for fila in filas:
            print(f"{fila[0]:<15} {fila[1]:<25} {fila[2]:<12} {fila[3]:<10} {fila[4]}")
    else:
        print(f"No hay ventas registradas en {anio}.")

def historial_ventas_cliente():
    # Pedir el ID del cliente
    id_cliente = input("ID del cliente: ")

    # Consultar con JOIN para obtener datos completos de cada venta
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT rv.id_venta, cp.nombre_modelo, cp.marca,
               rv.unidades, rv.precio, rv.fecha
        FROM registro_venta rv
        JOIN catalogo_productos cp ON cp.codigo_ean = rv.codigo_ean
        WHERE rv.id_cliente = %s
        ORDER BY rv.fecha DESC
    """, (id_cliente,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar historial o aviso si no hay ventas de ese cliente
    if filas:
        print(f"\nHistorial de ventas del cliente {id_cliente}:")
        print("\nID | Nombre modelo | Marca | Unidades | Precio | Fecha")
        print("-" * 75)
        for fila in filas:
            print(f"{fila[0]:<5} {fila[1]:<25} {fila[2]:<12} {fila[3]:<10} {fila[4]:<10} {fila[5]}")
    else:
        print(f"No hay ventas registradas para el cliente {id_cliente}.")

if __name__ == "__main__":
    print("1. Registrar venta")
    print("2. Ventas anuales")
    print("3. Historial de ventas por cliente")
    opcion = input("Elige una opcion: ")

    if opcion == "1":
        venta_producto()
    elif opcion == "2":
        ventas_anuales()
    elif opcion == "3":
        historial_ventas_cliente()
    else:
        print("Opcion no valida.")
