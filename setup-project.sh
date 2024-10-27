#!/bin/bash

# Definir colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}� Creando estructura de Google Apps Scripts${NC}"

# Crear directorios principales
DIRS=(
    "slides/slide-numbering/images"
    "sheets"
    "docs"
    "automation"
    "formatting"
    "integration"
    "utilities"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    echo -e "${GREEN}✓ Creado $dir${NC}"
done

# Crear primer script (slide-numbering)
cat > slides/slide-numbering/code.gs << 'EOF'
/**
 * Google Slides Numbering Script
 * @author Ernesto Barrera
 * @version 1.0.0
 * @lastUpdate 2024-02-27
 */

function numerarDiapositivas() {
  try {
    const presentacion = SlidesApp.getActivePresentation();
    const diapositivas = presentacion.getSlides();
    
    const ancho = presentacion.getPageWidth();
    const alto = presentacion.getPageHeight();
    
    const posX = ancho - 50;
    const posY = alto - 40;
    
    let numero = 1;
    
    limpiarNumeracion();
    
    diapositivas.forEach(diapositiva => {
      if (!diapositiva.isSkipped()) {
        const forma = diapositiva.insertShape(SlidesApp.ShapeType.TEXT_BOX, posX, posY, 30, 30);
        const texto = forma.getText();
        texto.setText(numero.toString());
        texto.getTextStyle()
          .setFontSize(14)
          .setForegroundColor('#FFFFFF');
          
        forma.setContentAlignment(SlidesApp.ContentAlignment.MIDDLE);
        forma.getFill().setTransparent();
        forma.getBorder().setTransparent();
        
        numero++;
      }
    });
    
    SlidesApp.getUi().alert('Completado', `Se numeraron ${numero - 1} diapositivas.`, SlidesApp.getUi().ButtonSet.OK);
  } catch(e) {
    SlidesApp.getUi().alert('Error', 'No se pudo completar la numeración: ' + e.toString(), SlidesApp.getUi().ButtonSet.OK);
  }
}

function limpiarNumeracion() {
  const presentacion = SlidesApp.getActivePresentation();
  const diapositivas = presentacion.getSlides();
  
  diapositivas.forEach(diapositiva => {
    const elementos = diapositiva.getPageElements();
    elementos.forEach(elemento => {
      if (elemento.getPageElementType() === SlidesApp.PageElementType.SHAPE) {
        const forma = elemento.asShape();
        const texto = forma.getText().asString().trim();
        if (/^\d+$/.test(texto)) {
          elemento.remove();
        }
      }
    });
  });
}

function onOpen() {
  SlidesApp.getUi()
    .createMenu('Numeración')
    .addItem('Numerar diapositivas', 'numerarDiapositivas')
    .addItem('Eliminar numeración', 'limpiarNumeracion')
    .addToUi();
}
EOF

# Crear README principal
cat > README.md << 'EOF'
# Google Apps Scripts Collection

Colección de scripts útiles para Google Workspace (Google Apps)

## Estructura
- � sheets/: Scripts para Google Sheets
- � slides/: Scripts para Google Slides
- � docs/: Scripts para Google Docs
- � automation/: Scripts de automatización
- � formatting/: Scripts de formato
- � integration/: Scripts de integración
- �️ utilities/: Scripts de utilidades

## Uso
Cada carpeta contiene sus propios scripts con instrucciones detalladas de uso.

## Licencia
MIT
EOF

# Crear README del proyecto de numeración
cat > slides/slide-numbering/README.md << 'EOF'
# Slide Numbering Script

Script para Google Slides que añade numeración automática a las diapositivas.

## Características
- ✨ Numeración automática en esquina inferior derecha
- � Posicionamiento inteligente basado en dimensiones
- ⚡ Menú personalizado en Google Slides
- � Números en blanco para fondos oscuros
- � Renumeración con un clic
- � Salta diapositivas ocultas
- � Función de limpieza de números existentes

## Instalación
1. Abre tu presentación de Google Slides
2. Ve a Extensiones -> Apps Script
3. Pega el contenido de `code.gs`
4. Guarda el proyecto
5. Recarga tu presentación

## Uso
Una vez instalado, encontrarás un nuevo menú "Numeración" con dos opciones:
- **Numerar diapositivas**: Añade o actualiza la numeración
- **Eliminar numeración**: Elimina todos los números existentes
EOF

# Crear .gitignore
cat > .gitignore << 'EOF'
.DS_Store
node_modules/
*.log
.idea/
EOF

echo -e "${GREEN}✅ Estructura de proyecto creada con éxito!${NC}"
