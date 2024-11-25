#!/bin/bash

# Archivo JSON del cual extraer y modificar la versión
JSON_FILE="package.json"

# Comprobar si el archivo existe
if [[ ! -f "$JSON_FILE" ]]; then
    echo "El archivo $JSON_FILE no existe."
    exit 1
fi

# Extraer el valor actual de "version" usando jq o sed
CURRENT_VERSION=$(jq -r '.version' "$JSON_FILE")

# Comprobar si se ha obtenido la versión correctamente
if [[ -z "$CURRENT_VERSION" ]]; then
    echo "No se pudo encontrar la versión en el archivo $JSON_FILE."
    exit 1
fi

# Separar la versión en partes (Major, Minor, Patch)
IFS='.' read -r MAJOR MIDDLE MINOR <<< "$CURRENT_VERSION"

# Incrementar la versión
if [[ $MINOR -lt 9 ]]; then
    MINOR=$((MINOR + 1))
else
    MINOR=0
    if [[ $MIDDLE -lt 9 ]]; then
        MIDDLE=$((MIDDLE + 1))
    else
        MIDDLE=0
        if [[ $MAJOR -lt 9 ]]; then
            MAJOR=$((MAJOR + 1))
        else
            echo "¡La versión ha alcanzado su límite máximo! 9.9.9"
            exit 1
        fi
    fi
fi

# Nueva versión
NEW_VERSION="$MAJOR.$MIDDLE.$MINOR"

# Mostrar la nueva versión
echo "$NEW_VERSION"
