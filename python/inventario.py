from conexion import conectar
from auth import login

def existencias_producto():
    # Pedir el codigo EAN del producto
    ean = input("Codigo EAN del producto: ")

    # Llamar a la función SQL que devuelve las existencias
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM existencias_producto(%s)", (ean,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar existencias o aviso si no hay stock
    if filas:
        print("\nCodigo EAN | Nombre modelo | Marca | Tipo | Talla | Unidades")
        print("-" * 70)
        for fila in filas:
            print(f"{fila[0]:<15} {fila[1]:<25} {fila[2]:<12} {fila[3]:<12} {fila[4]:<8} {fila[5]}")
    else:
        print("No se encontraron existencias para ese producto.")

def inventario_completo():
    # Consultar la vista que muestra todo el inventario con ubicacion
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM vista_inventario")
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar inventario o aviso si esta vacio
    if filas:
        print("\nCodigo EAN | Nombre modelo | Marca | Tipo | Talla | Unidades | Ubicacion")
        print("-" * 85)
        for fila in filas:
            print(f"{fila[0]:<15} {fila[1]:<25} {fila[2]:<12} {fila[3]:<12} {fila[4]:<8} {fila[5]:<10} {fila[6]}")
    else:
        print("El inventario esta vacio.")

def inventario_por_marca():
    # Pedir la marca a consultar
    marca = input("Marca a consultar: ")

    # Filtrar la vista de inventario por marca
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("""
        SELECT * FROM vista_inventario
        WHERE marca = %s
    """, (marca,))
    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar resultados o aviso si no hay productos de esa marca
    if filas:
        print(f"\nInventario de {marca}:")
        print("\nCodigo EAN | Nombre modelo | Tipo | Talla | Unidades | Ubicacion")
        print("-" * 75)
        for fila in filas:
            print(f"{fila[0]:<15} {fila[1]:<25} {fila[3]:<12} {fila[4]:<8} {fila[5]:<10} {fila[6]}")
    else:
        print(f"No hay productos de la marca {marca} en el inventario.")

if __name__ == "__main__":
    # Verificar credenciales antes de acceder al sistema
    usuario = login()
    if usuario is None:
        exit()

    # Ambos roles pueden ver el inventario
    print("\n1. Existencias de un producto")
    print("2. Inventario completo")
    print("3. Inventario por marca")

    opcion = input("Elige una opcion: ")

    if opcion == "1":
        existencias_producto()
    elif opcion == "2":
        inventario_completo()
    elif opcion == "3":
        inventario_por_marca()
    else:
        print("Opcion no valida.")
