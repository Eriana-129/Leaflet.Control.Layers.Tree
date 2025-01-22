# USO
Dado que Rstudio es un software y lenguaje de programación, que permite manejar grandes cantidades de datos, visualizarlos y modificarlos, es también una herramienta muy importante para el web-mapping y uno de los paquetes más populares es leaflet, sin embargo, el manejo de capas suele ser un problema ya que leaflet base no tiene un árbol de capas, por lo anterior, jjimenezshaw creó el plugin Leaflet.Control.Layers.Tree, disponible en: https://github.com/jjimenezshaw/Leaflet.Control.Layers.Tree

No obstante, este plugin tiene instrucciones de uso más que nada para html y aunque es bastante explicito en su uso, la adaptación a Rstudio no es tan clara, por lo que pongo a disposición de los usuarios un código de ejemplo de Rstudio con la incorporación del plugin de jjimenezshaw. Se destaca que no he modificado en ningun momento los archivos css y js originales, sin embargo, jjimenezshaw informa que para realizar los cambios pertinentes que necesitemos, como usar símbolos diferentes para el colapso de las capas, se hagan sobre el archivo js. De manera personal, lo que recomiendo es que si se desean hacer cambios estéticos, sean sobre el css, como dar un fondo de color diferente al control de capas, tipo de letra, color de la letra, etc. 

De manera general, los pasos a seguir en Rstudio son los siguientes:

1.  Cargar los paquetes necesarios (leaflet y htmltools), yo cargué también tibble pero porque cree desde el código las coordenadas de mi df.
2.  Agregarmos nuestro df y agrupamos según la categoría que queramos nuestros datos
3.  Descargamos los archivos css y jss desde el perfil de jjimenezshaw (este paso solo se hace una vez, y se debe de tomar en cuenta que se descargan tal y como jjimenezshaw los creo, así que si desean hacer cambios, esta parte del código comentenla y hagan sus cambios ya sea en el css o js y guardenlos en la carpeta que tengan establecida dentro del wd)
4.  Creamos la dependencia del plugin. En este paso yo he puesto en XXXXX la ruta de mis archivos, pero recuerden que es el working directory y solo es poner la carpeta en donde están los archivos css y js, no les cambien el nombre a esos archivos.
5.  Después registramos el plugin
6.  Luego creamos el mapa. Es muy importante no usar el AddLayersControl de leaflet base, ya que entra en conflicto con el plugin que vamos a usar. 
7.  Dentro de esa creación, agregamos el árbol de capas de acuerdo con las instrucciones de jjimenezshaw
8.  jjimenezshaw indica que debemos de usar L.control.layers.tree(baseTree, overlaysTree, options).addTo(map);, en este caso se ha usado algo muy similar que es L.control.layers.tree(baseTree, overlaysTree, options).addTo(this);
9.  Cargamos el mapa final

Pueden usar carácteres unicode para agregar emojis, esto se hace dentro del árbol de capas. 
