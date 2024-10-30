# Slide Links Extractor

Script para Google Slides que extrae todos los enlaces de una presentación a una hoja de cálculo de Google.

## Características

- 📊 Exportación automática a Google Sheets
- 🔍 Detecta enlaces en:
  - Cuadros de texto
  - Formas
  - Tablas
- 📝 Información detallada de cada enlace:
  - Número de diapositiva
  - Texto del enlace
  - URL completa
  - Tipo de elemento que contiene el enlace
- 👻 Ignora diapositivas ocultas
- 📎 Menú personalizado en Google Slides
- 🔄 Procesamiento rápido y eficiente
- 📋 Formato automático de la hoja de resultados

## Instalación

1. Abre tu presentación de Google Slides
2. Ve a Extensiones -> Apps Script
3. Pega el contenido del script
4. Guarda el proyecto
5. Recarga tu presentación

## Uso

Una vez instalado, encontrarás un nuevo menú "📎 Enlaces" en la barra de herramientas con la opción:

- **Extraer enlaces a hoja de cálculo**: Analiza la presentación y crea una nueva hoja de cálculo con todos los enlaces encontrados

## Resultados

El script genera una hoja de cálculo que incluye:

| Columna          | Descripción                                           |
| ---------------- | ----------------------------------------------------- |
| Diapositiva      | Número de la diapositiva donde se encuentra el enlace |
| Texto            | Texto visible del enlace                              |
| URL              | Dirección web completa del enlace                     |
| Tipo de elemento | Forma, Cuadro de texto o Celda de tabla               |

## Notas

- La hoja de cálculo generada incluye el nombre de la presentación original para fácil referencia
- Solo se procesan las diapositivas visibles (no ocultas)
- Si no se encuentran enlaces, se mostrará un mensaje indicándolo
- Las columnas se ajustan automáticamente al contenido
- Se muestra un diálogo compacto con el resultado y acceso directo a la hoja generada

## Limitaciones

- Solo procesa enlaces en elementos de texto, formas y tablas
- No detecta enlaces en imágenes o elementos incrustados
- Requiere permisos para crear hojas de cálculo en Google Drive

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue para discutir cambios mayores antes de enviar un pull request.
