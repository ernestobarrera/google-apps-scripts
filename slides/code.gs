function onOpen() {
  var ui = SlidesApp.getUi();

  // Menú de numeración
  ui.createMenu("Numeración")
    .addItem("Numerar diapositivas", "numerarDiapositivas")
    .addItem("Eliminar numeración", "limpiarNumeracion")
    .addToUi();

  // Menú de enlaces
  ui.createMenu("📎 Enlaces")
    .addItem("Extraer enlaces a hoja de cálculo", "extractLinksFromSlides")
    .addToUi();
}
