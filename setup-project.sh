#!/bin/bash

# Definir colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}íº€ Creando estructura de Google Apps Scripts${NC}"

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
    echo -e "${GREEN}âœ“ Creado $dir${NC}"
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
    SlidesApp.getUi().alert('Error', 'No se pudo completar la numeraciÃ³n: ' + e.toString(), SlidesApp.getUi().ButtonSet.OK);
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
    .createMenu('NumeraciÃ³n')
    .addItem('Numerar diapositivas', 'numerarDiapositivas')
    .addItem('Eliminar numeraciÃ³n', 'limpiarNumeracion')
    .addToUi();
}
EOF

# Crear README principal
cat > README.md << 'EOF'
# Google Apps Scripts Collection

ColecciÃ³n de scripts Ãºtiles para Google Workspace (Google Apps)

## Estructura
- í³Š sheets/: Scripts para Google Sheets
- í³‘ slides/: Scripts para Google Slides
- í³ docs/: Scripts para Google Docs
- í´– automation/: Scripts de automatizaciÃ³n
- í¾¨ formatting/: Scripts de formato
- í´„ integration/: Scripts de integraciÃ³n
- í» ï¸ utilities/: Scripts de utilidades

## Uso
Cada carpeta contiene sus propios scripts con instrucciones detalladas de uso.

## Licencia
MIT
EOF

# Crear README del proyecto de numeraciÃ³n
cat > slides/slide-numbering/README.md << 'EOF'
# Slide Numbering Script

Script para Google Slides que aÃ±ade numeraciÃ³n automÃ¡tica a las diapositivas.

## CaracterÃ­sticas
- âœ¨ NumeraciÃ³n automÃ¡tica en esquina inferior derecha
- í¾¯ Posicionamiento inteligente basado en dimensiones
- âš¡ MenÃº personalizado en Google Slides
- í¾¨ NÃºmeros en blanco para fondos oscuros
- í´„ RenumeraciÃ³n con un clic
- í±» Salta diapositivas ocultas
- í·¹ FunciÃ³n de limpieza de nÃºmeros existentes

## InstalaciÃ³n
1. Abre tu presentaciÃ³n de Google Slides
2. Ve a Extensiones -> Apps Script
3. Pega el contenido de `code.gs`
4. Guarda el proyecto
5. Recarga tu presentaciÃ³n

## Uso
Una vez instalado, encontrarÃ¡s un nuevo menÃº "NumeraciÃ³n" con dos opciones:
- **Numerar diapositivas**: AÃ±ade o actualiza la numeraciÃ³n
- **Eliminar numeraciÃ³n**: Elimina todos los nÃºmeros existentes
EOF

# Crear .gitignore
cat > .gitignore << 'EOF'
.DS_Store
node_modules/
*.log
.idea/
EOF

echo -e "${GREEN}âœ… Estructura de proyecto creada con Ã©xito!${NC}"
