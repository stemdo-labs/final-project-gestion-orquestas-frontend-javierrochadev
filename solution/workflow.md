# Documentación del Workflow CI/CD Pipeline

Este flujo de trabajo automatiza el ciclo de vida de la integración continua (CI) y el despliegue continuo (CD) para una aplicación. Este pipeline realiza las tareas necesarias para extraer y actualizar versiones, construir y desplegar la aplicación, y gestionar su despliegue a través de los entornos de frontend.

## Activación del Workflow

Este flujo de trabajo se activa de dos maneras:

- **Push a la rama `main`**: Cada vez que se realiza un push a la rama principal (`main`).
- **workflow_dispatch**: Permite la activación manual del flujo de trabajo.

## Descripción de los Jobs

### Job: `deploy`

Este job es responsable de extraer y actualizar la versión de la aplicación, realizando tareas como la extracción de la versión actual, su incremento y la actualización de los archivos correspondientes.

#### Pasos del Job

1. **Set up Node.js**:
   - Configura la versión de Node.js en el entorno de ejecución, en este caso, la versión `20`.

2. **Check out repository**:
   - Realiza un `checkout` del código fuente del repositorio para acceder a los archivos de la aplicación.

3. **Set up script permissions**:
   - Asigna permisos de ejecución a los scripts `extract_version.sh` y `upload_version.sh`.

4. **Extract and increment version**:
   - Ejecuta el script `extract_version.sh` para extraer la versión actual y realizar su incremento. El valor resultante de la nueva versión se almacena en la variable de entorno `NEW_VERSION` y se guarda en la salida del job.

5. **Upload version into file**:
   - Ejecuta el script `upload_version.sh` para cargar la nueva versión extraída en los archivos correspondientes.

### Job: `call_frontend_ci`

Este job se encarga de invocar el flujo de trabajo de CI para el frontend, pasando la nueva versión de la aplicación generada en el job anterior.

- **Dependencia**: Este job depende del job `deploy` para asegurarse de que la nueva versión se haya extraído y actualizado correctamente (por medio de `needs: deploy`).
- **Acción**: Llama al workflow de CI para el frontend definido en el archivo `frontend-CI.yaml`.

#### Parámetros del Job

- **`image_name`**: El nombre de la imagen Docker del frontend.
- **`image_tag`**: La etiqueta de la imagen Docker, que es la nueva versión extraída en el job `deploy`.

### Job: `call_frontend_cd`

Este job invoca el flujo de trabajo de CD para el frontend, utilizando la nueva versión y otros parámetros necesarios para el despliegue de la aplicación en el entorno de Kubernetes.

- **Dependencias**: Este job depende de los jobs `deploy` y `call_frontend_ci` (por medio de `needs: deploy` y `needs: call_frontend_ci`).
- **Acción**: Llama al workflow de CD para el frontend definido en el archivo `frontend-CD.yaml`.

#### Parámetros del Job

- **`image_name`**: El nombre de la imagen Docker del frontend.
- **`chart_name`**: El nombre del chart de Helm para el despliegue.
- **`image_tag`**: La etiqueta de la imagen Docker, que es la nueva versión generada en el job `deploy`.

## Uso de Secrets

El flujo de trabajo hace uso de varios secretos para la autenticación y configuración en servicios como Azure, ACR, Kubernetes y Harbor. A continuación se listan los secretos utilizados:

- **Para `deploy`**: No se utilizan secretos directamente.
- **Para `call_frontend_ci` y `call_frontend_cd`**: Los siguientes secretos son requeridos:
  - **Credenciales de Azure**: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`.
  - **Kubernetes**: `RESOURCE_GROUP_NAME`, `AKS_NAME`.
  - **Harbor**: `HARBOR_USER`, `HARBOR_PASS`, `HARBOR_IP`.
  - **ACR**: `ACR_NAME`, `ACR_SECRET_NAME`

Estos secretos permiten la conexión a los servicios necesarios para el flujo de trabajo, como Azure Container Registry (ACR), Azure Kubernetes Service (AKS), y el registro Harbor.

---

Este flujo de trabajo es útil para gestionar y automatizar las tareas de CI/CD en un entorno de desarrollo y producción, incluyendo la actualización de versiones y el despliegue de las aplicaciones frontend mediante Helm y Kubernetes.
