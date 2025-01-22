# Cargamos los paquetes necesarios para trabajar con mapas interactivos. 
# Load the necessary packages to work with interactive maps.
library(leaflet)
library(htmltools)
library(tibble)

# Creamos un objeto tibble con datos de ejemplo para el mapa.
# We create a tibble object with example data for the map.
df <- tibble(
  lat = c(-37.50, -37.51, -37.52, -37.53, -37.54, -37.55, -37.56, -37.57, -37.58, -37.59),
  lng = c(-72.66, -72.65, -72.67, -72.68, -72.69, -72.70, -72.71, -72.72, -72.73, -72.74),
  name = c(
    "Incendio 1", "Incendio 2", "Derrame 1", "Derrame 2",
    "Conservación 1", "Conservación 2", "Residuo 1", "Residuo 2",
    "Prado 1", "Prado 2"
  ),
  grouping = c(
    "groups.quimico.incendios", "groups.quimico.incendios", 
    "groups.quimico.derrames", "groups.quimico.derrames", 
    "groups.sanitario.conservacion", "groups.sanitario.conservacion",
    "groups.sanitario.residuos", "groups.sanitario.residuos",
    "groups.sanitario.prados", "groups.sanitario.prados"
  )
)

# Descargar los archivos necesarios del plugin Leaflet.Control.Layers.Tree de jjimenezshaw (esto se realiza solo una vez).
# Download the required files for the Leaflet.Control.Layers.Tree plugin made by jjimenezshaw (this is done only once).

urlf <- 'https://github.com/jjimenezshaw/Leaflet.Control.Layers.Tree/blob/master/'
download.file(sprintf(urlf, 'leaflet.groupedlayercontrol.min.js'), 'L.Control.Layers.Tree.js', mode = "wb")
download.file(sprintf(urlf, 'leaflet.groupedlayercontrol.min.css'), 'L.Control.Layers.Tree.css', mode = "wb")

# Si ya tienes los archivos css y js descargados y cuentas con la experiencia necesaria para hacer cambios a tu gusto, no es necesario descargar estos archivos una y otra vez.
# If you already have the CSS and JS files downloaded and have the experience to make changes as needed in the css and js, it's not necessary to download these files repeatedly.


# Crear la dependencia del plugin
# Create the plugin dependency
ctrlGrouped <- htmltools::htmlDependency(
  name = 'ctrlGrouped',
  version = "1.0.0",
  src = c(file = normalizePath('XXXXX')),  # Ruta donde se encuentran los archivos CSS y JS / Route where the CSS and JS files are located
  script = "L.Control.Layers.Tree.js",
  stylesheet = "L.Control.Layers.Tree.css"
)

# Función para registrar el plugin
# Function to register the plugin
registerPlugin <- function(map, plugin) {
  map$dependencies <- c(map$dependencies, list(plugin))
  map
}

# Crear el mapa con los controles agrupados
# Create the map with grouped controls
m <- leaflet() %>%
  addTiles() %>%
  registerPlugin(ctrlGrouped) %>%
  fitBounds(min(df$lng), min(df$lat), max(df$lng), max(df$lat)) %>%
  htmlwidgets::onRender("
        function(el, x, data) {
          // Crear grupos de capas
          // Create layer groups
          var groups = {
            quimico: {
              incendios: new L.LayerGroup(),
              derrames: new L.LayerGroup()
            },
            sanitario: {
              conservacion: new L.LayerGroup(),
              residuos: new L.LayerGroup(),
              prados: new L.LayerGroup()
            }
          };

          // Añadir marcadores a los grupos correspondientes
          // Add markers to the corresponding groups
          for (var i = 0; i < data.lng.length; i++) {
            var label = JSON.stringify(data.name[i]);
            var mygroup = data.grouping[i];
            var marker = L.marker([data.lat[i], data.lng[i]]).bindPopup(label).addTo(eval(mygroup));
          }

          // Definir la estructura jerárquica de las capas
          // Define the hierarchical structure of base layers
          var baseTree = {
            label: 'Mapas Base &#127758', // you can use unicode to add emojis
            collapsed: true,
            children: [
              { 
                label: 'OpenStreetMap', 
                layer: L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png') 
              },
              { 
                label: 'Esri World Imagery', 
                layer: L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}') 
              },
              { 
                label: 'CartoDB Positron Only Labels', 
                layer: L.tileLayer('https://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}.png') 
              }
            ]
          };


          // Definir los subgrupos de superposiciones (overlays)
          // Define overlay subgroups
          var overlaysTree = {
            label: 'Capas &#9776', // you can use unicode to add emojis
            children: [
              {
                label: 'Químico Tecnológicos &#128293', // you can use unicode to add emojis
                collapsed: true,
                selectAllCheckbox: true,
                children: [
                  { label: 'Incendios forestales', layer: groups.quimico.incendios},
                  { label: 'Derrames', layer: groups.quimico.derrames}
                ]
              },
              {
                label: 'Sanitario Ecológico &#127795', // you can use unicode to add emojis
                collapsed: true,
                selectAllCheckbox: true,
                children: [
                  { label: 'Suelo de conservación', layer: groups.sanitario.conservacion },
                  { label: 'Residuos sólidos', layer: groups.sanitario.residuos },
                  { label: 'Prados de la montaña', layer: groups.sanitario.prados }
                ]
              }
            ]
          };

          // Configurar las opciones del control de capas
          // Set layer control options
          var options = {
            groupCheckboxes: true
          };
          
          // Crear y agregar el control de capas al mapa
          // Create and add the layer control to the map
          L.control.layers.tree(baseTree, overlaysTree, options).addTo(this);
        }
      ", data = df)

# Mostrar el mapa
# Show the map
m

