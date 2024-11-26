#!/bin/bash

# Archivo JSON del cual extraer la versión
JSON_FILE="package.json"

# Comprobar si el archivo existe
if [[ ! -f "$JSON_FILE" ]]; then
    echo "El archivo $JSON_FILE no existe."
    exit 1
fi

# Extraer el valor actual de "version" usando jq
CURRENT_VERSION=$(jq -r '.version' "$JSON_FILE")

# Comprobar si se ha obtenido la versión correctamente
if [[ -z "$CURRENT_VERSION" ]]; then
    echo "No se pudo encontrar la versión en el archivo $JSON_FILE."
    exit 1
fi

# Mostrar la versión extraída
echo "$CURRENT_VERSION"
