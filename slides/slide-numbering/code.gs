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
    
    // Obtener las dimensiones de la página
    const pagina = presentacion.getPageHeight();
    const ancho = presentacion.getPageWidth();
    const alto = presentacion.getPageHeight();
    
    // Calcular posición para esquina inferior derecha
    // Restamos un margen pequeño para que no quede pegado al borde
    const posX = ancho - 50;  // 50 pixels desde el borde derecho
    const posY = alto - 40;   // 40 pixels desde el borde inferior
    
    let numero = 1;
    
    // Primero eliminar números existentes
    limpiarNumeracion();
    
    // Agregar nuevos números
    diapositivas.forEach(diapositiva => {
      if (!diapositiva.isSkipped()) {
        const forma = diapositiva.insertShape(SlidesApp.ShapeType.TEXT_BOX, posX, posY, 30, 30);
        const texto = forma.getText();
        texto.setText(numero.toString());
        texto.getTextStyle()
          .setFontSize(14)
          .setForegroundColor('#FFFFFF');
          
        // Centrar el número en el cuadro
        forma.setContentAlignment(SlidesApp.ContentAlignment.MIDDLE);
        
        // Hacer transparente el fondo y borde
        forma.getFill().setTransparent();
        forma.getBorder().setTransparent();
        
        numero++;
      }
    });
    
    SlidesApp.getUi().alert('Completado', `Se numeraron ${numero - 1} diapositivas.\nDimensiones: ${ancho}x${alto}`, SlidesApp.getUi().ButtonSet.OK);
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