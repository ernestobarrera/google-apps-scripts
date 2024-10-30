function onOpen() {
  var ui = SlidesApp.getUi();
  ui.createMenu("📎 Enlaces")
    .addItem("Extraer enlaces a hoja de cálculo", "extractLinksFromSlides")
    .addToUi();
}

function extractLinksFromSlides() {
  // Abre la presentación activa y obtiene su nombre
  var presentation = SlidesApp.getActivePresentation();
  var presentationName = presentation.getName();
  var slides = presentation.getSlides();

  // Crea una hoja de cálculo incluyendo el nombre de la presentación en el título
  var spreadsheet = SpreadsheetApp.create("Enlaces de " + presentationName);
  var sheet = spreadsheet.getActiveSheet();

  // Añade encabezados
  sheet
    .getRange(1, 1, 1, 4)
    .setValues([["Diapositiva", "Texto", "URL", "Tipo de elemento"]]);

  var row = 2; // Comenzamos en la fila 2 después de los encabezados
  var linksFound = false; // Para rastrear si se encontraron enlaces
  var visibleSlideNumber = 1; // Contador para diapositivas visibles

  // Itera sobre cada diapositiva
  slides.forEach((slide, index) => {
    // Solo procesa diapositivas no ocultas
    if (!slide.isSkipped()) {
      var elements = slide.getPageElements();

      // Itera sobre cada elemento de la diapositiva
      elements.forEach((element) => {
        try {
          var elementType = element.getPageElementType();

          // Maneja diferentes tipos de elementos
          switch (elementType) {
            case SlidesApp.PageElementType.SHAPE:
              var shape = element.asShape();
              if (shape.getText()) {
                var result = processTextRangeForLinks(
                  shape.getText(),
                  visibleSlideNumber,
                  "Forma",
                  sheet,
                  row
                );
                row = result.newRow;
                if (result.foundLinks) linksFound = true;
              }
              break;

            case SlidesApp.PageElementType.TEXT_BOX:
              var textBox = element.asTextBox();
              if (textBox.getText()) {
                var result = processTextRangeForLinks(
                  textBox.getText(),
                  visibleSlideNumber,
                  "Cuadro de texto",
                  sheet,
                  row
                );
                row = result.newRow;
                if (result.foundLinks) linksFound = true;
              }
              break;

            case SlidesApp.PageElementType.TABLE:
              var table = element.asTable();
              var result = processTable(table, visibleSlideNumber, sheet, row);
              row = result.newRow;
              if (result.foundLinks) linksFound = true;
              break;
          }
        } catch (error) {
          Logger.log("Error procesando elemento: " + error.toString());
        }
      });

      visibleSlideNumber++; // Incrementa solo para diapositivas visibles
    }
  });

  if (!linksFound) {
    // Si no se encontraron enlaces, añade un mensaje en la hoja
    sheet
      .getRange(2, 1, 1, 4)
      .setValues([
        ["No se encontraron enlaces en las diapositivas visibles", "", "", ""],
      ]);
  }

  // Ajusta el ancho de las columnas automáticamente
  sheet.autoResizeColumns(1, 4);

  // Obtiene la URL de la hoja de cálculo
  var spreadsheetUrl = spreadsheet.getUrl();

  // Crea el contenido HTML para el diálogo, ahora más compacto y sin necesidad de scroll
  var html = `
    <!DOCTYPE html>
    <html>
      <head>
        <base target="_blank">
        <style>
          body { 
            font-family: Arial, sans-serif; 
            margin: 12px;
            line-height: 1.4;
          }
          .container {
            display: flex;
            flex-direction: column;
            gap: 8px;
          }
          .info {
            margin: 0;
            font-size: 14px;
          }
          .stats {
            color: #666;
            font-size: 12px;
            margin: 0;
          }
          .button { 
            display: inline-block;
            background-color: #4285f4;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            text-align: center;
          }
          .button:hover {
            background-color: #357abd;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <p class="info">Se ha creado una hoja de cálculo con los enlaces encontrados.</p>
          <p class="stats">Diapositivas procesadas: ${
            visibleSlideNumber - 1
          }</p>
          <a href="${spreadsheetUrl}" class="button">Abrir hoja de cálculo</a>
        </div>
      </body>
    </html>
  `;

  var htmlOutput = SlidesApp.getUi().showModalDialog(
    HtmlService.createHtmlOutput(html).setWidth(350).setHeight(120), // Altura reducida para evitar scroll
    "✅ Proceso completado"
  );
}

function processTextRangeForLinks(
  textRange,
  slideNumber,
  elementType,
  sheet,
  row
) {
  var foundLinks = false;

  try {
    // Obtiene todos los runs de texto
    var runs = textRange.getRuns();

    // Procesa cada run
    runs.forEach(function (run) {
      try {
        var link = run.getTextStyle().getLink();
        if (link) {
          var linkText = run.asString().trim();
          if (linkText) {
            sheet
              .getRange(row, 1, 1, 4)
              .setValues([[slideNumber, linkText, link.getUrl(), elementType]]);
            row++;
            foundLinks = true;
          }
        }
      } catch (error) {
        Logger.log("Error procesando run de texto: " + error.toString());
      }
    });
  } catch (error) {
    Logger.log("Error procesando texto: " + error.toString());
  }

  return { newRow: row, foundLinks: foundLinks };
}

function processTable(table, slideNumber, sheet, row) {
  var foundLinks = false;
  var numRows = table.getNumRows();
  var numCols = table.getNumColumns();

  // Itera sobre cada celda de la tabla
  for (var i = 0; i < numRows; i++) {
    for (var j = 0; j < numCols; j++) {
      try {
        var cell = table.getCell(i, j);
        if (cell.getText()) {
          var result = processTextRangeForLinks(
            cell.getText(),
            slideNumber,
            "Celda de tabla",
            sheet,
            row
          );
          row = result.newRow;
          if (result.foundLinks) foundLinks = true;
        }
      } catch (error) {
        Logger.log("Error procesando celda de tabla: " + error.toString());
      }
    }
  }

  return { newRow: row, foundLinks: foundLinks };
}
