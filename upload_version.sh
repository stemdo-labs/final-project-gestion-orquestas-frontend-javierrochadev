#!/bin/bash

# Comprobar si se pasó el argumento de la nueva versión (ejemplo: 1.2.3)
if [[ -z "$1" ]]; then
    echo "Por favor, proporcione la nueva versión como argumento (formato Major.Minor.Patch)."
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

# Validar que la nueva versión esté en formato Major.Minor.Patch
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: La nueva versión '$NEW_VERSION' no es válida. Debe tener el formato Major.Minor.Patch (números separados por puntos)."
    exit 1
fi

# Separar la versión en partes (Major.Minor.Patch)
IFS='.' read -r MAJOR MINOR PATCH <<< "$NEW_VERSION"

# Incrementar la versión
if [[ $PATCH -lt 9 ]]; then
    PATCH=$((PATCH + 1))  # Incrementar Patch
elif [[ $MINOR -lt 9 ]]; then
    PATCH=0
    MINOR=$((MINOR + 1))  # Incrementar Minor
else
    PATCH=0
    MINOR=0
    MAJOR=$((MAJOR + 1))  # Incrementar Major
fi

# Nueva versión después de incrementar
NEW_VERSION_INCREMENTED="$MAJOR.$MINOR.$PATCH"

# Actualizar el archivo JSON con la nueva versión usando jq
jq --arg new_version "$NEW_VERSION_INCREMENTED" '.version = $new_version' "$JSON_FILE" > temp.json && mv temp.json "$JSON_FILE"

# Verificar si la actualización fue exitosa
if [[ $? -eq 0 ]]; then
    echo "El archivo JSON se ha actualizado con la nueva versión: $NEW_VERSION_INCREMENTED"
else
    echo "Hubo un error al actualizar el archivo JSON."
    exit 1
fi
