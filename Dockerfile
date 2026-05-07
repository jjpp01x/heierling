# Usar imagen oficial de Python
FROM python:3.11-slim

# Crear directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar los archivos Python al contenedor
COPY python/ .

# Instalar psycopg2 para conectar con PostgreSQL
RUN pip install psycopg2-binary

# Comando por defecto al arrancar el contenedor
CMD ["python3", "-u", "productos.py"]
