# src/simulate_data.R
# Activa el entorno del proyecto si se ejecuta fuera de RStudio
if (file.exists("renv/activate.R")) source("renv/activate.R")

#' Simula un conjunto de datos para análisis
#'
#' @param n integer Número de observaciones (>= 1).
#' @param seed integer Semilla para reproducibilidad.
#' @param alpha numeric Ingreso base.
#' @param beta numeric Incremento por año de educación.
#' @param sd_error numeric Desvío estándar del error en el ingreso.
#' @param prob_desempleo numeric Probabilidad de desempleo (0-1).
#'
#' @return data.frame con columnas:
#'   id, edad, educacion_anios, ingreso_mensual, desempleado
#' @examples
#' df <- simulate_data(n = 500, seed = 2026)
simulate_data <- function(
  n = 500,
  seed = 2026,
  alpha = 1200,
  beta = 180,
  sd_error = 400,
  prob_desempleo = 0.12
) {
  # Validaciones mínimas
  stopifnot(is.numeric(n), n >= 1, is.numeric(seed))
  stopifnot(is.numeric(alpha), is.numeric(beta), is.numeric(sd_error), sd_error >= 0)
  stopifnot(is.numeric(prob_desempleo), prob_desempleo >= 0, prob_desempleo <= 1)

  set.seed(seed)

  # Variables
  edad <- sample(18:70, n, replace = TRUE)
  educacion_anios <- sample(0:20, n, replace = TRUE)
  error <- rnorm(n, mean = 0, sd = sd_error)

  ingreso_mensual <- round(alpha + beta * educacion_anios + error, 0)
  desempleado <- rbinom(n, size = 1, prob = prob_desempleo)

  data.frame(
    id = seq_len(n),
    edad = edad,
    educacion_anios = educacion_anios,
    ingreso_mensual = ingreso_mensual,
    desempleado = desempleado
  )
}