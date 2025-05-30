#' Índice de Severidad de Sequía de Palmer
#'
#' Calcula el Indice de Severidad de Sequía de Palmer.
#' `psdi_ac()` calcula la versión autocalibrada.
#'
#' @param precipitacion serie de precipitación sin datos faltantes (en mm). Ver sección Details.
#' @param etp serie de evapotranspiración potencial sin datos faltantes. Ver sección Details.
#' @param cc capacidad de campo (en mm).
#' @param coeficientes lista de coeficientes que devuelve `pdsi_coeficientes()`
#'
#' @return
#' Un vector de la misma longitud que `precipitacion` con el PDSI correspondiente a cada caso.
#'
#' @details
#'
#' El Índice de Severidad de Sequía de Palmer, propuesto por Palmer (1965) es usado
#' como indicador para cuantificar las condiciones de sequía a largo plazo. El
#' cálculo usa constantes definidas empíricamente, originalmente utilizando datos
#' meteorológicos de Kansas y de Iowa en Estados Unidos. Estas constantes no
#' representan necesariamente cualquier región del planeta por lo que puede ser
#' redefinidas para el cálculo del índice usando la función
#' del índice usando la función [pdsi_coeficientes()].
#'
#' Alternativamente, Wells et al. (2004) propuso el Indice de Severidad de Sequía de Palmer Autocalibrado
#' que tiene la capacidad de ajustar las constantes empíricas durante el cálculo del indice.
#'
#' Si bien el cálculo de este indice funcionará para series de datos cortas (datos
#' diarios para un mes o datos mensuales para un año), es necesario contar con una
#' climatología, es decir 30 años para que el resultado sea confiable.
#'
#' @references
#' Palmer (1965), Meteorological Drought. U.S Weather Bureau, Washington, D.C. (book).
#'
#' Wells et. al. (2004), A Self-Calibrating Palmer Drought Severity Index. Journal
#' of Climate \doi{10.1175/1520-0442(2004)017<2335:ASPDSI>2.0.CO;2}
#'
#' @examples
#'
#' library(dplyr)
#'
#' # datos aleatorios
#' set.seed(42)
#'
#' datos <- data.frame(fecha = seq(as.Date("1985-01-01"), as.Date("2015-12-01"), by = "1 month"))
#' datos |>
#'   mutate(pp = rgamma(nrow(datos), shape = 2, scale = 10),
#'          etp = rgamma(nrow(datos), shape = 1, scale = 3),
#'          pdsi_ac = pdsi(pp, etp)) |>
#'   slice_head(n = 10)
#'
#'
#' @export
pdsi  <- function(precipitacion, etp, cc = 100, coeficientes = pdsi_coeficientes()) {
  missing <- !is.finite(precipitacion) | !is.finite(etp)
  precipitacion[missing] <- NA
  etp[missing] <- NA

  as.vector(pdsi_internal(precipitacion, etp, AWC = cc, sc = FALSE)$X)[seq_along(precipitacion)]
}



#' @export
#' @rdname pdsi
pdsi_ac  <- function(precipitacion, etp, cc = 100, coeficientes = pdsi_coeficientes()) {
  missing <- !is.finite(precipitacion) | !is.finite(etp)
  precipitacion[missing] <- NA
  etp[missing] <- NA

  as.vector(pdsi_internal(precipitacion, etp, AWC = cc, sc = TRUE)$X)[seq_along(precipitacion)]
}
