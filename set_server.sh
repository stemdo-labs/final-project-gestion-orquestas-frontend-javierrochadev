#!/bin/bash

# Verificar si se pasó un argumento
if [ -z "$1" ]; then
  echo "Uso: $0 <proxy_pass_value>"
  exit 1
fi

# Valor del argumento
PROXY_PASS="$1"

# Archivo de configuración de Nginx
NGINX_CONFIG="./nginx.conf"

# Verificar si el archivo de configuración existe
if [ ! -f "$NGINX_CONFIG" ]; then
  echo "Archivo de configuración Nginx no encontrado en $NGINX_CONFIG"
  exit 1
fi

# Usar sed para reemplazar el valor de proxy_pass en el archivo de configuración
sed -i "s|proxy_pass http://backend-service:8080;|proxy_pass $PROXY_PASS;|g" "$NGINX_CONFIG"

# Verificar si el reemplazo fue exitoso
if [ $? -eq 0 ]; then
  echo "El archivo de configuración de Nginx fue actualizado con éxito."
else
  echo "Hubo un error al intentar actualizar el archivo de configuración."
  exit 1
fi


# Salir con éxito
exit 0
