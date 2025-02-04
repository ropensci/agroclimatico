# Contribuir a agroclimatico

Este documento es una guía para proponer un cambio en agroclimatico. 

## Requerimientos técnicos

Si deseas constribuir al código de agroclimatico necesitaras instalar las dependencias de sistema y de paquetes. 
Para instalar los paquetes de R necesarios para el desarrollo de agroclimatico es útil utilizar `devtools::install_deps()`.

agroclimatico además utiliza el paquete `sf` para la manipulación de los mapas. Este paquete requiere de una serie de dependencias de sistema, por favor revisa 
las [instrucciones de instalación de sf](https://r-spatial.github.io/sf/#installing) específicas al sistema operativo de tu computadora para instalarlo.


## Arreglar los errores de escritura

Puedes corregir errores de escritura, ortografía o gramaticales en la documentación directamente usando la interfaz web de GitHub, siempre y cuando los cambios se hagan en el archivo _source_. 

Esto generalmente significa que necesitarás editar [comentarios de roxygen2](https://roxygen2.r-lib.org/articles/roxygen2.html) en un archivo `.R`, no en un archivo `.Rd`. Puedes encontrar el archivo `.R` que genera el `.Rd` leyendo el comentario en la primera línea.

## Cambios más grandes

Si quieres hacer un cambio mayor, es una buena idea presentar primero un problema y asegurarse de que alguien del equipo esté de acuerdo en que es necesario. 
Si encontraste un error, por favor, crea un issue que ilustre el error con un ejemplo mínimo ([reprex](https://www.tidyverse.org/help/#reprex), esto también te ayudará a escribir un unit test, si es necesario).

### Proceso de Pull requests

* Crea un fork del paquete y clonalo en tu computadora. Si nunca hicistes esto, te recomendamos que uses `usethis::create_from_github("AgRoMeteorologiaINTA/agroclimatico", fork = TRUE)`.

* Instala todas las dependencias de desarrollo con `devtools::install_dev_deps()`, y luego asegúrate de que el paquete pase el chequeo R CMD ejecutando `devtools::check()`. 
    Si el chequeo R CMD no pasa completamente, es una buena idea pedir ayuda antes de continuar. 
* Crea una nueva rama Git para tu pull request (PR). Recomendamos usar `usethis::pr_init("breve descripción del cambio")`.

* Haz tus cambios, crea un commit con git, y luego crea un PR ejecutando `usethis::pr_push()`, y siguiendo las indicaciones de tu navegador.
    El título de tu PR debería describir brevemente el cambio.
    El cuerpo de tu PR debe contener "Arreglo #número-de-issue".

* Para los cambios de cara al usuario, añade una descripción en la parte superior de `NEWS.md` (es decir, justo debajo del primer encabezado). Sigue el estilo descripto en <https://style.tidyverse.org/news.html>.

### Estilo de código

* El nuevo código debe seguir la [guía de estilo] tidyverse (https://style.tidyverse.org). 
    Puedes usar el paquete [styler](https://CRAN.R-project.org/package=styler) para aplicar estos estilos, pero por favor no cambies el estilo de código que no tiene nada que ver con tu PR.  

* Usamos [roxygen2](https://cran.r-project.org/package=roxygen2), con [sintaxis Markdown](https://cran.r-project.org/web/packages/roxygen2/vignettes/rd-formatting.html), para la documentación.  

* Usamos [testthat](https://cran.r-project.org/package=testthat) para hacer unit tests. 
   Las contribuciones con tests incluidos son más fáciles de aceptar.

## Código de Conducta

Este proyecto incluye un [Código de Conducta](https://www.contributor-covenant.org/es/version/2/0/code_of_conduct/code_of_conduct.md). Al contribuir en este paquete, aceptás complir con este código.
