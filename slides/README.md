# Google Slides Utilities

Colección de utilidades para Google Slides que facilitan tareas comunes de presentación.

## Utilidades disponibles

### 1. Numeración de Diapositivas

Añade numeración automática a las diapositivas en la esquina inferior derecha.

- [Documentación detallada](./slide-numbering/README.md)

### 2. Extractor de Enlaces

Extrae todos los enlaces de una presentación a una hoja de cálculo de Google.

- [Documentación detallada](./link-extractor/README.md)

## Instalación

1. Abre tu presentación de Google Slides
2. Ve a Extensiones -> Apps Script
3. Crea los siguientes archivos:
   - `code.gs` (archivo principal con los menús)
   - En una carpeta llamada `modules`:
     - `numbering.gs` (código de numeración)
     - `link-extract.gs` (código de extracción)
4. Copia el contenido de cada archivo
5. Guarda y recarga la presentación

## Uso

Después de la instalación, encontrarás dos nuevos menús en la barra de herramientas:

### Menú "Numeración"

- **Numerar diapositivas**: Añade números a todas las diapositivas
- **Eliminar numeración**: Elimina los números existentes

### Menú "📎 Enlaces"

- **Extraer enlaces a hoja de cálculo**: Crea una hoja con todos los enlaces

## Contribuciones

Las contribuciones son bienvenidas. Por favor, revisa las guías de contribución en cada subproyecto.
