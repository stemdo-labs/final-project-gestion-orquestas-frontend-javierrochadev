#!/bin/bash

# Comprobar si se pasó un argumento (nueva versión)
if [[ -z "$1" ]]; then
    echo "Por favor, proporcione la nueva versión como argumento."
    exit 1
fi

# Nueva versión proporcionada como argumento
NEW_VERSION="$1"

# Archivo JSON donde se actualizará la versión
JSON_FILE="package.json"

# Comprobar si el archivo existe
if [[ ! -f "$JSON_FILE" ]]; then
    echo "El archivo $JSON_FILE no existe."
    exit 1
fi

# Actualizar el archivo JSON con la nueva versión usando jq
jq --arg new_version "$NEW_VERSION" '.version = $new_version' "$JSON_FILE" > temp.json && mv temp.json "$JSON_FILE"

# Verificar si la actualización fue exitosa
if [[ $? -eq 0 ]]; then
    echo "El archivo JSON se ha actualizado con la nueva versión: $NEW_VERSION"
else
    echo "Hubo un error al actualizar el archivo JSON."
    exit 1
fi
