# scripts/analisis.R
# Asegura entorno y carga la función de análisis
if (file.exists("renv/activate.R")) source("renv/activate.R")
source("src/analyze_data.R")

# 1) Archivo de entrada (crudo)
infile <- file.path("data", "raw", "datos_simulados.csv")

# 2) Ejecutar análisis con manejo de errores básico
res <- tryCatch(
  analyze_data(infile),
  error = function(e) {
    message("ERROR en el análisis: ", e$message)
    quit(status = 1)  # salir con código de error para que runall.ps1 lo detecte
  }
)

# 3) Crear carpeta de salida si no existe
outdir <- file.path("data", "processed")
if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# 4) Guardar salidas
outfile_processed <- file.path(outdir, "datos_procesados.csv")
outfile_resumen   <- file.path(outdir, "resumen_por_grupos.csv")

write.csv(res$processed, outfile_processed, row.names = FALSE)
write.csv(res$resumen,   outfile_resumen,   row.names = FALSE)

# 5) Mensajes
message("OK: análisis completado.")
message(" - ", normalizePath(outfile_processed))
message(" - ", normalizePath(outfile_resumen))