# scripts/modelado.R
# Orquestador del modelado: carga entorno, llama función y guarda salidas

if (file.exists("renv/activate.R")) source("renv/activate.R")
source("src/fit_model.R")

# 1) Archivo de entrada (procesado)
infile <- file.path("data", "processed", "datos_procesados.csv")

# 2) Ejecutar modelado con manejo de errores básico
res <- tryCatch(
  fit_model(infile),
  error = function(e) {
    message("ERROR en el modelado: ", e$message)
    quit(status = 1)
  }
)

# 3) Crear carpeta de salida si no existe
outdir <- file.path("results", "tables")
if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# 4) Guardar coeficientes y métricas
outfile_coefs <- file.path(outdir, "modelo_coeficientes.csv")
outfile_mets  <- file.path(outdir, "modelo_metricas.csv")

write.csv(res$coefs,    outfile_coefs, row.names = FALSE)
write.csv(res$metricas, outfile_mets,  row.names = FALSE)

# 5) Mensajes (sin warnings)
message("OK: modelado completado.")
message(" - ", normalizePath(outfile_coefs, mustWork = FALSE))
message(" - ", normalizePath(outfile_mets,  mustWork = FALSE))