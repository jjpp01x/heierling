from conexion import conectar
from auth import login

def compra_producto():
    # Pedir datos de la compra al usuario
    cif = input("CIF del proveedor: ")
    ean = input("Codigo EAN del producto: ")
    unidades = input("Unidades: ")
    precio = input("Precio unitario: ")
    fecha = input("Fecha (YYYY-MM-DD) o Enter para hoy: ")

    # Conectar a la base de datos
    conn = conectar()
    cursor = conn.cursor()

    # Si no introduce fecha se usa la fecha actual
    if fecha == "":
        cursor.execute("SELECT compra_producto(%s, %s, %s, %s)",
                       (cif, ean, unidades, precio))
    else:
        cursor.execute("SELECT compra_producto(%s, %s, %s, %s, %s)",
                       (cif, ean, unidades, precio, fecha))

    # Confirmar y cerrar conexión
    conn.commit()
    cursor.close()
    conn.close()
    print("Compra registrada correctamente.")

def compras_anuales():
    # Pedir el año a consultar
    anio = input("Año a consultar: ")

    # Llamar a la función SQL que agrupa compras por producto
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM compras_anuales(%s)", (anio,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar resultados o aviso si no hay compras ese año
    if filas:
        print(f"\nCompras del año {anio}:")
        print("\nCodigo EAN | Nombre modelo | Marca | Unidades | Importe total")
        print("-" * 75)
        for fila in filas:
            print(f"{fila[0]:<15} {fila[1]:<25} {fila[2]:<12} {fila[3]:<10} {fila[4]}")
    else:
        print(f"No hay compras registradas en {anio}.")

def historial_compras_proveedor():
    # Pedir el CIF del proveedor
    cif = input("CIF del proveedor: ")

    # Consultar con JOIN para obtener datos completos de cada compra
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT rc.id_compra, cp.nombre_modelo, cp.marca,
               rc.unidades, rc.precio, rc.fecha
        FROM registro_compra rc
        JOIN catalogo_productos cp ON cp.codigo_ean = rc.codigo_ean
        WHERE rc.cif = %s
        ORDER BY rc.fecha DESC
    """, (cif,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar historial o aviso si no hay compras de ese proveedor
    if filas:
        print(f"\nHistorial de compras del proveedor {cif}:")
        print("\nID | Nombre modelo | Marca | Unidades | Precio | Fecha")
        print("-" * 75)
        for fila in filas:
            print(f"{fila[0]:<5} {fila[1]:<25} {fila[2]:<12} {fila[3]:<10} {fila[4]:<10} {fila[5]}")
    else:
        print(f"No hay compras registradas para el proveedor {cif}.")

if __name__ == "__main__":
    # Verificar credenciales antes de acceder al sistema
    usuario = login()
    if usuario is None:
        exit()

    # Solo el admin puede registrar compras y ver informes anuales
    print("\n1. Historial de compras por proveedor")
    if usuario["rol"] == "admin":
        print("2. Registrar compra")
        print("3. Compras anuales")

    opcion = input("Elige una opcion: ")

    if opcion == "1":
        historial_compras_proveedor()
    elif opcion == "2" and usuario["rol"] == "admin":
        compra_producto()
    elif opcion == "3" and usuario["rol"] == "admin":
        compras_anuales()
    else:
        print("Opcion no valida o sin permisos.")
