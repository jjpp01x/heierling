import psycopg2
import os

def conectar():
    # El host cambia según el entorno:
    # - En Docker el contenedor de PostgreSQL se llama 'db'
    # - En local se usa 'localhost'
    host = os.getenv("POSTGRES_HOST", "localhost")
    database = os.getenv("POSTGRES_DB", "heierling")
    user = os.getenv("POSTGRES_USER", "hans")
    password = os.getenv("POSTGRES_PASSWORD", "1234")

    # Conectar a la base de datos con los parámetros del entorno
    conn = psycopg2.connect(
        host=host,
        database=database,
        user=user,
        password=password
    )
    # Devolver la conexión para que otros módulos la usen
    return conn
