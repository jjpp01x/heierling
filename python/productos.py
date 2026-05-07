from conexion import conectar

def alta_producto():
    # Pedir datos del nuevo producto al usuario
    ean = input("Codigo EAN: ")
    nombre = input("Nombre del modelo: ")
    marca = input("Marca: ")
    tipo = input("Tipo: ")
    talla = input("Talla: ")

    # Llamar a la función SQL que valida e inserta el producto
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT alta_producto(%s, %s, %s, %s, %s)",
                   (ean, nombre, marca, tipo, talla))

    # Confirmar y cerrar conexión
    conn.commit()
    cursor.close()
    conn.close()
    print("Producto añadido correctamente.")

def baja_producto():
    # Pedir el EAN del producto a dar de baja
    ean = input("Codigo EAN del producto a dar de baja: ")

    # Llamar a la función SQL que comprueba reservas y stock antes de borrar
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT baja_producto(%s)", (ean,))

    # Confirmar y cerrar conexión
    conn.commit()
    cursor.close()
    conn.close()
    print("Producto dado de baja correctamente.")

def renombrar_producto():
    # Pedir el EAN y el nuevo nombre
    ean = input("Codigo EAN del producto: ")
    nuevo_nombre = input("Nuevo nombre: ")

    # Llamar a la función SQL que valida que el nombre es distinto al actual
    conn = conectar()
    cursor = conn.cursor()
    cursor.execute("SELECT renombrar_producto(%s, %s)", (ean, nuevo_nombre))

    # Confirmar y cerrar conexión
    conn.commit()
    cursor.close()
    conn.close()
    print("Producto renombrado correctamente.")

def buscar_producto():
    # Pedir la marca a buscar o Enter para ver todo el catálogo
    marca = input("Marca a buscar (Enter para todas): ")

    conn = conectar()
    cursor = conn.cursor()

    # Si no introduce marca se muestran todos los productos
    if marca == "":
        cursor.execute("""
            SELECT codigo_ean, nombre_modelo, marca, tipo, talla
            FROM catalogo_productos
            ORDER BY marca, nombre_modelo
        """)
    else:
        # Filtrar por marca si se introduce una
        cursor.execute("""
            SELECT codigo_ean, nombre_modelo, marca, tipo, talla
            FROM catalogo_productos
            WHERE marca = %s
            ORDER BY nombre_modelo
        """, (marca,))

    filas = cursor.fetchall()
    cursor.close()
    conn.close()

    # Mostrar resultados o aviso si no hay productos
    if filas:
        print("\nCodigo EAN | Nombre modelo | Marca | Tipo | Talla")
        print("-" * 70)
        for fila in filas:
            print(f"{fila[0]:<15} {fila[1]:<25} {fila[2]:<12} {fila[3]:<12} {fila[4]}")
    else:
        print("No se encontraron productos.")

if __name__ == "__main__":
    print("1. Alta de producto")
    print("2. Baja de producto")
    print("3. Renombrar producto")
    print("4. Buscar producto")
    opcion = input("Elige una opcion: ")

    if opcion == "1":
        alta_producto()
    elif opcion == "2":
        baja_producto()
    elif opcion == "3":
        renombrar_producto()
    elif opcion == "4":
        buscar_producto()
    else:
        print("Opcion no valida.")
