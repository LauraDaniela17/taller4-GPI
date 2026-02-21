# src/plot_results.R
# Funciones reutilizables para visualización y tablas
# (sin librerías externas)

if (file.exists("renv/activate.R")) source("renv/activate.R")

#' Genera visualizaciones y tabla para informe a partir de datos procesados
#'
#' @param infile_processed character Ruta a datos_procesados.csv
#' @param infile_resumen character Ruta a resumen_por_grupos.csv
#' @return list con:
#'   - plot_ingreso_box: función que dibuja boxplot
#'   - plot_heat_ingreso: función que dibuja heatmap base R
#'   - tabla_resumen: data.frame para exportar como imagen
plot_results <- function(
  infile_processed = file.path("data", "processed", "datos_procesados.csv"),
  infile_resumen   = file.path("data", "processed", "resumen_por_grupos.csv")
) {
  # Validaciones de entrada
  if (!file.exists(infile_processed)) stop("No se encontró: ", infile_processed)
  if (!file.exists(infile_resumen))   stop("No se encontró: ", infile_resumen)

  # Lectura
  df  <- tryCatch(
    read.csv(infile_processed, stringsAsFactors = FALSE),
    error = function(e) stop("No se pudo leer: ", infile_processed, " | Detalle: ", e$message)
  )
  res <- tryCatch(
    read.csv(infile_resumen, stringsAsFactors = FALSE),
    error = function(e) stop("No se pudo leer: ", infile_resumen, " | Detalle: ", e$message)
  )

  # Validar columnas mínimas esperadas
  req_df  <- c("ingreso_mensual", "grupo_educacion", "grupo_edad", "desempleado")
  req_res <- c("grupo_educacion", "grupo_edad", "ingreso_mensual", "desempleo_tasa")

  faltan_df  <- setdiff(req_df, names(df))
  faltan_res <- setdiff(req_res, names(res))
  if (length(faltan_df)  > 0) stop("Faltan columnas en datos_procesados: ", paste(faltan_df, collapse = ", "))
  if (length(faltan_res) > 0) stop("Faltan columnas en resumen_por_grupos: ", paste(faltan_res, collapse = ", "))

  # Plot 1: Boxplot de ingreso por grupo de educación
  plot_ingreso_box <- function() {
    boxplot(
      ingreso_mensual ~ grupo_educacion,
      data = df,
      main = "Ingreso mensual por grupo de educación",
      xlab = "Grupo de educación (años)",
      ylab = "Ingreso mensual"
    )
  }

  # Plot 2: Heatmap simple (base R) de ingreso promedio por educación x edad
  plot_heat_ingreso <- function() {
    mat <- xtabs(ingreso_mensual ~ grupo_educacion + grupo_edad, data = res)

    # Si por alguna razón queda vacío
    if (nrow(mat) == 0 || ncol(mat) == 0) {
      plot.new()
      text(0.5, 0.5, "No hay datos suficientes para heatmap", cex = 1.2)
      return(invisible(NULL))
    }

    # image() requiere matriz numérica, la transponemos para que el eje Y quede como educación
    image(
      x = seq_len(ncol(mat)),
      y = seq_len(nrow(mat)),
      z = t(mat[nrow(mat):1, , drop = FALSE]),
      axes = FALSE,
      xlab = "Grupo de edad",
      ylab = "Grupo de educación",
      main = "Ingreso promedio (educación x edad)"
    )
    axis(1, at = seq_len(ncol(mat)), labels = colnames(mat))
    axis(2, at = seq_len(nrow(mat)), labels = rev(rownames(mat)))

    # Escribir valores encima (opcional, útil para informe)
    for (i in seq_len(nrow(mat))) {
      for (j in seq_len(ncol(mat))) {
        val <- mat[i, j]
        if (!is.na(val)) {
          text(j, nrow(mat) - i + 1, labels = round(val, 0), cex = 0.7)
        }
      }
    }
  }

  # Tabla para informe (por grupos)
  tabla_resumen <- res
  # columnas “bonitas” opcionales
  tabla_resumen$desempleo_pct <- round(100 * tabla_resumen$desempleo_tasa, 1)

  list(
    plot_ingreso_box  = plot_ingreso_box,
    plot_heat_ingreso = plot_heat_ingreso,
    tabla_resumen     = tabla_resumen
  )
}
