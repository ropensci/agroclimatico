# agroclimatico 1.1.0 

## 05/12/2024

El paquete pasá la revisión de rOpenSci, cambia la versión a 1.1.0 

## 26/11/2024- [Revisión para rOpenSci, 2](https://github.com/ropensci/software-review/issues/599)

* Mejora en ejemplos de: `decil()`, `anomalia_porcentual()`, `olas()`.

* Mejoras en la documentación de: `pdsi()`, `spi_indice()`.

## 29/07/2024- [Revisión para rOpenSci, 2](https://github.com/ropensci/software-review/issues/599)

* Mejora ejemplos en: `ith()`, `spi_indice()`, `pdsi()`, `umbrales()`

* Resuelve bug en `olas()` cuando la serie no está completa

* Agrega argumento `remplaza.na` a la función `olas()` para remplazar `NA`s e incluirlos en la ola.

## 29/05/2024 - [Revisión para rOpenSci](https://github.com/ropensci/software-review/issues/599)

* Mejora la documentación de casi todas las funciones:
  * Ahora hay menos errores de tipeo
  * Hay más ejemplos con datos reales
  * Referencias a papers y fuentes de información

* Agrega datos de una segunda estación meteorológica  para calculos por grupo y
datos mensuales para mapas.

* Ahora `mapear()` recibe el data.frame de datos como primer argumento

* Arregla error en `compeltar_serie()` para que acepte tanto "dia" como "1 dia"

## 04/12/2023

* Cambia el nombre del paquete a agroclimatico

## 30/11/2023

* Cambia el nombre del paquete de agromet a agroclimr
* Cambia el nombre de las funciones `spi()` y `spei()` a `spi_indice()` y `spei_indice()`
