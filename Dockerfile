
# Etapa 1: Construcción de la aplicación Vue.js
FROM node:18 AS build

# Establecer la variable de entorno para solucionar problemas de OpenSSL
ENV NODE_OPTIONS=--openssl-legacy-provider

# Definir el directorio de trabajo en el contenedor
WORKDIR /app

# Copiar los archivos package.json y package-lock.json (o yarn.lock si usas Yarn)
COPY package*.json ./

# Instalar las dependencias del proyecto
RUN npm install

# Copiar todo el código fuente de la aplicación
COPY . .

# Construir la aplicación para producción
RUN npm run build

# Etapa 2: Servir la aplicación con Nginx
FROM nginx:alpine

# Copiar el archivo de configuración de NGINX al contenedor
COPY nginx.conf /etc/nginx/nginx.conf

# Copiar los archivos generados en la etapa de build al directorio que usa Nginx para servir
COPY --from=build /app/dist /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80

# Comando por defecto para ejecutar Nginx
CMD ["nginx", "-g", "daemon off;"]
