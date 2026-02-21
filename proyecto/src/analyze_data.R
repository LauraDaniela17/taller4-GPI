# src/analyze_data.R
# Activa el entorno del proyecto si se ejecuta fuera de RStudio/CLI
if (file.exists("renv/activate.R")) source("renv/activate.R")

#' Analiza los datos simulados: validación, transformaciones y resumen por grupos.
#'
#' @param infile character Ruta del CSV crudo (por defecto, data/raw/datos_simulados.csv)
#' @return list con:
#'   - processed: data.frame con transformaciones mínimas y variables de grupo
#'   - resumen:   data.frame con ingreso promedio y tasa de desempleo por grupo
#'
#' @examples
#' res <- analyze_data("data/raw/datos_simulados.csv")
analyze_data <- function(infile = file.path("data", "raw", "datos_simulados.csv")) {
  # 1) Validaciones de entrada
  if (!file.exists(infile)) {
    stop("No se encontró el archivo de entrada: ", infile)
  }

  # 2) Lectura
  df <- tryCatch(
    read.csv(infile, stringsAsFactors = FALSE),
    error = function(e) stop("No se pudo leer el archivo: ", infile, " | Detalle: ", e$message)
  )

  # 3) Validación de columnas requeridas
  req_cols <- c("id", "edad", "educacion_anios", "ingreso_mensual", "desempleado")
  faltan <- setdiff(req_cols, names(df))
  if (length(faltan) > 0) {
    stop("Faltan columnas requeridas: ", paste(faltan, collapse = ", "))
  }

  # 4) Coerciones mínimas (por seguridad)
  suppressWarnings({
    df$id               <- as.integer(df$id)
    df$edad             <- as.integer(df$edad)
    df$educacion_anios  <- as.integer(df$educacion_anios)
    df$ingreso_mensual  <- as.numeric(df$ingreso_mensual)
    df$desempleado      <- as.integer(df$desempleado)
  })

  # 5) Variables de grupo (educación y edad)
  #    - Ajusta los cortes si lo necesitas; los niveles quedan ordenados.
  df$grupo_educacion <- cut(
    df$educacion_anios,
    breaks = c(-Inf, 5, 11, 16, Inf),
    labels = c("0-5", "6-11", "12-16", "17+"),
    right = TRUE,
    ordered_result = TRUE
  )

  df$grupo_edad <- cut(
    df$edad,
    breaks = c(17, 25, 35, 50, 70),
    labels = c("18-25", "26-35", "36-50", "51-70"),
    right = TRUE,
    ordered_result = TRUE
  )

  # 6) Resumen por grupos (base R, en dos pasos para evitar columnas-lista)
  #    - ingreso promedio
  resumen_ing <- aggregate(
    ingreso_mensual ~ grupo_educacion + grupo_edad,
    data = df,
    FUN  = function(x) mean(x, na.rm = TRUE)
  )

  #    - tasa de desempleo (promedio de 0/1)
  resumen_des <- aggregate(
    desempleado ~ grupo_educacion + grupo_edad,
    data = df,
    FUN  = function(x) mean(x, na.rm = TRUE)
  )

  #    - unir y renombrar tasa
  resumen <- merge(
    resumen_ing,
    resumen_des,
    by = c("grupo_educacion", "grupo_edad"),
    all = TRUE
  )
  names(resumen)[names(resumen) == "desempleado"] <- "desempleo_tasa"

  # 7) Ordenar por niveles (opcional, queda más prolijo)
  resumen <- resumen[order(resumen$grupo_educacion, resumen$grupo_edad), ]

  # 8) Retorno
  list(
    processed = df,
    resumen   = resumen[, c("grupo_educacion", "grupo_edad", "ingreso_mensual", "desempleo_tasa")]
  )
}