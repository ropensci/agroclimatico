#' Calcula el SPI
#'
#' Calcula el Índice Estandarizado de Precipitación para distintas escalas. Las
#' funciones `spi_indice` y `spei_indice` usan internamente a la función [SPEI::spi]
#' pero tienen la ventaja de devolver el resultado como un data.frame que se
#' puede usar de manera directa para el análisis de datos con dplyr.
#'
#' @details
#' La función `spi_indice` toma valores de precipitación mientras que `spei_indice` toma
#' valores del balance entre precipitación y evapotranspiración potencial.
#' Internamente hacen lo mismo; la única diferencia es la distribución teórica
#' usada por defecto para ajustar los datos.
#'
#'
#' @param fecha vector de fechas.
#' @param precipitacion vector de precipitacion.
#' @param balance balance entre precipitación y evapotranspiración potencial.
#' @param escalas vector numérico con las escalas requeridas. La unidad de la escala
#' está dada por el vector de fechas. Si `escalas = 6` y los datos son mensuales
#' entonces el cálculo del indice se hará en escalas de 6 meses.
#' @param distribucion distribución usada para ajustar los datos.
#' @param referencia serie de precipitación para usar de referencia en el ajuste
#' a la distribución teórica. Puede ser:
#' * vector lógico o numérico que se usará para filtrar los datos de entrada.
#' * un data frame con columna `fecha` y `precipitacion`. La función
#' `spi_referencia()` es un simple wrapper a `data.frame()` que le pone el nombre
#'  correcto a las variables.
#' @param ... argumentos pasados a [SPEI::spi]
#'
#' @return
#' Un data.frame con columnas
#' * `fecha` (fecha)
#' * `escala` (numérico) definidas en el argumento de entrada
#' * `spi` o `spei` (numérico)
#'
#' @references
#' Vicente-Serrano, S. M., Beguería, S. and López-Moreno, J. I.: A multiscalar
#' drought index sensitive to global warming: The standardized precipitation
#' evapotranspiration index, J. Clim., 23(7), \doi{10.1175/2009JCLI2909.1}, 2010.
#'
#' R Package [SPEI: Calculation of the Standardized Precipitation-Evapotranspiration Index](https://cran.r-project.org/package=SPEI)
##
#' @examples
#'
#' library(dplyr)
#' data(NH0358)
#'
#' datos_mensuales <- NH0358 %>%
#'   group_by(fecha = lubridate::round_date(fecha, "month")) %>%
#'   reframe(precip = mean(precip, na.rm = TRUE),
#'           etp = mean(etp, na.rm = TRUE))
#'
#' # Para escalas de 1 a 12 meses
#' datos_mensuales %>%
#'   reframe(spi_indice(fecha, precip, escalas = 1:12)) %>%
#'   slice_head(n = 10)
#'
#' # Si tenemos nuevos datos y hay que calcular el spi nuevamente pero sin que
#' # cambien los valores previos, hay que usar `referencia`, por ejemplo usando
#' # los datos desde el comienzo de la seria hasta 2016
#'
#' # Usando un vector lógico
#' datos_mensuales %>%
#'   reframe(spi_indice(fecha, precip, escalas = 1:12,
#'                      referencia = data.table::year(fecha) < 2016)) %>%
#'   slice_head(n = 10)
#'
#' # O un data.frame
#' datos_2016 <- datos_mensuales %>%
#'  filter(data.table::year(fecha) < 2016)
#'
#' datos_mensuales %>%
#' reframe(spi_indice(fecha, precip, escalas = 1:12,
#'                    referencia = spi_referencia(datos_2016$fecha, datos_2016$precip))) %>%
#'   slice_head(n = 10)
#'
#'
#' @export
#' @importFrom data.table .BY :=
spi_indice <- function(fecha, precipitacion, escalas, referencia = rep(TRUE, length(fecha)),
                    distribucion = "Gamma", ...) {
  . <- pp <- escala <- month <- spi <- NULL

  # Le da formato a los datos y calculando las medias móviles (acumuladas)
  data <- data.table::as.data.table(completar_serie(data.frame(fecha = fecha, precipitacion = precipitacion),
                                                    fecha, "1 mes"))
  data[, as.character(escalas) := data.table::frollmean(precipitacion, escalas)]
  data[, precipitacion := NULL]
  data <- data.table::melt(data, id.vars = "fecha", value.name = "precipitacion", variable.name = "escala")
  data[, escala := as.numeric(as.character(escala))][]

  # Hace lo mismo con la serie de referencia
  if (is.vector(referencia)) {
    referencia <- data.table::data.table(fecha = fecha[referencia],
                                         precipitacion = precipitacion[referencia])

  }

  referencia <- data.table::as.data.table(completar_serie(referencia, fecha, "1 mes"))
  referencia[, as.character(escalas) := data.table::frollmean(precipitacion, escalas)]
  referencia[, precipitacion := NULL]
  referencia <- data.table::melt(referencia, id.vars = "fecha", value.name = "precipitacion",
                                 variable.name = "escala")
  referencia[, escala := as.numeric(as.character(escala))][]

  # Fitea los parámetros de la distribución para cada mes y escala
  # Como el resultado son arrays, está metido en una lista.
  params <- referencia[, .(params = .(spi_params(precipitacion, scale = 1, na.rm = TRUE,
                                                 distribution = distribucion, ...))),
                       by = .(escala, month = data.table::month(fecha))]

  # Calcula el SPI usando los parámetros.
  data[, spi := SPEI::spi(stats::ts(precipitacion, frequency = 1), scale = 1, na.rm = TRUE,
                          distribution = distribucion,
                          params = params[escala == .BY$escala & month == .BY$month]$params[[1]],
                          verbose =  FALSE, ...)$fitted,
       by = .(escala, month = data.table::month(fecha))]
  data[, spi := as.vector(spi)]
  data[, precipitacion := NULL]
  data.table::setnames(data, "fecha", deparse(substitute(fecha)))

  return(as.data.frame(data))
}





#' @export
#' @rdname spi_indice
spei_indice <- function(fecha, balance, escalas, distribucion = "log-Logistic", ...) {
  data <- spi_indice(fecha = fecha, precipitacion = balance, escalas = escalas, distribucion = distribucion, ...)

  data.table::setnames(data, c("fecha", "spi"), c(deparse(substitute(fecha)), "spei"))
  return(data)
}

#' @export
#' @rdname spi_indice
spi_referencia <- function(fecha, precipitacion) {
  data.frame(fecha = fecha, precipitacion = precipitacion)
}

spi_params <- function(pp, ...)  {
  SPEI::spi(stats::ts(pp, frequency = 1), verbose =  FALSE, ...)$coefficients
}

.datatable.aware <- TRUE
