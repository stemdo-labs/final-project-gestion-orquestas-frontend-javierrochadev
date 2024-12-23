#!/bin/bash

# Verificar si se pasó una contraseña como parámetro
if [ -z "$1" ]; then
  echo "Por favor, proporciona una contraseña como parámetro."
  echo "Uso: ./generate_tls_cert.sh <contraseña>"
  exit 1
fi

# Definir la contraseña que se pasa como argumento
PASSPHRASE=$1

# Definir los nombres de los archivos
KEY_FILE="tls.key"
CERT_FILE="tls.crt"

# 1. Generar la clave privada (con contraseña)
echo "Generando clave privada..."
openssl genpkey -algorithm RSA -out $KEY_FILE -aes256 -pass pass:$PASSPHRASE

# Eliminar la contraseña de la clave privada (proporcionando la contraseña original)
echo "Eliminando la contraseña de la clave privada..."
openssl rsa -in $KEY_FILE -out $KEY_FILE -passin pass:$PASSPHRASE

# Establecer permisos de lectura sobre el archivo de clave privada
chmod 644 $KEY_FILE
echo "Permisos de lectura establecidos para $KEY_FILE"

# 2. Generar la solicitud de certificado (CSR)
echo "Generando solicitud de certificado (CSR)..."
openssl req -new -key $KEY_FILE -out tls.csr -subj "/C=US/ST=State/L=City/O=Company/OU=IT/CN=localhost"

# 3. Generar el certificado autofirmado
echo "Generando certificado autofirmado..."
openssl x509 -req -in tls.csr -out $CERT_FILE -signkey $KEY_FILE -days 365

# Establecer permisos de lectura sobre el archivo de certificado
chmod 644 $CERT_FILE
echo "Permisos de lectura establecidos para $CERT_FILE"

# Limpiar el archivo CSR (no es necesario después de la firma)
rm tls.csr

echo "Certificado y clave generados correctamente."
