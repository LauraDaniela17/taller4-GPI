# scripts/analisis.R
# Asegura entorno y carga la función de análisis
if (file.exists("renv/activate.R")) source("renv/activate.R")
source("src/analyze_data.R")

# 1) Definir fuente remota y local
zenodo_url <- "https://zenodo.org/records/18856399/files/datos_procesados.csv?download=1"
local_file <- file.path("data", "processed", "datos_procesados.csv")

# 2) Intentar descargar desde Zenodo; si falla, usar local
infile <- tryCatch({
  tf <- tempfile(fileext = ".csv")
  download.file(zenodo_url, destfile = tf, mode = "wb", quiet = TRUE)
  message("OK: datos cargados desde Zenodo.")
  tf
}, error = function(e) {
  message("No se pudo descargar desde Zenodo. Se usarán los datos locales.")
  local_file
})

# 3) Ejecutar análisis con manejo de errores básico
res <- tryCatch(
  analyze_data(infile),
  error = function(e) {
    message("ERROR en el análisis: ", e$message)
    quit(status = 1)  # salir con código de error para que runall.ps1 lo detecte
  }
)

# 4) Crear carpeta de salida si no existe
outdir <- file.path("data", "processed")
if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# 5) Guardar salidas
outfile_processed <- file.path(outdir, "datos_procesados.csv")
outfile_resumen   <- file.path(outdir, "resumen_por_grupos.csv")

write.csv(res$processed, outfile_processed, row.names = FALSE)
write.csv(res$resumen,   outfile_resumen,   row.names = FALSE)

# 6) Mensajes
message("OK: análisis completado.")
message(" - ", normalizePath(outfile_processed))
message(" - ", normalizePath(outfile_resumen))