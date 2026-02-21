# src/fit_model.R
if (file.exists("renv/activate.R")) source("renv/activate.R")

#' Ajusta un modelo logístico para desempleo usando datos procesados.
#'
#' @param infile character Ruta del CSV procesado (por defecto: data/processed/datos_procesados.csv)
#' @return list con:
#'   - modelo: objeto glm
#'   - coefs: data.frame con coeficientes y p-values
#'   - metricas: data.frame con métricas básicas (AIC, N)
fit_model <- function(infile = file.path("data", "processed", "datos_procesados.csv")) {

  # 1) Validación de entrada
  if (!file.exists(infile)) {
    stop("No se encontró el archivo de entrada procesado: ", infile)
  }

  # 2) Lectura
  df <- tryCatch(
    read.csv(infile, stringsAsFactors = FALSE),
    error = function(e) {
      stop("No se pudo leer el archivo: ", infile, " | Detalle: ", e$message)
    }
  )

  # 3) Validar columnas requeridas
  req_cols <- c("desempleado", "edad", "educacion_anios", "ingreso_mensual")
  faltan <- setdiff(req_cols, names(df))
  if (length(faltan) > 0) {
    stop("Faltan columnas requeridas para el modelo: ", paste(faltan, collapse = ", "))
  }

  # 4) Coerciones mínimas
  suppressWarnings({
    df$desempleado     <- as.integer(df$desempleado)
    df$edad            <- as.numeric(df$edad)
    df$educacion_anios <- as.numeric(df$educacion_anios)
    df$ingreso_mensual <- as.numeric(df$ingreso_mensual)
  })

  # 5) Modelo (logístico)
  modelo <- glm(
    desempleado ~ edad + educacion_anios + ingreso_mensual,
    data = df,
    family = binomial()
  )

  # 6) Tabla de coeficientes
  s <- summary(modelo)
  coefs <- as.data.frame(s$coefficients)
  coefs$term <- rownames(coefs)
  rownames(coefs) <- NULL

  # 7) Métricas básicas
  metricas <- data.frame(
    aic = AIC(modelo),
    n   = nrow(df)
  )

  list(modelo = modelo, coefs = coefs, metricas = metricas)
}
