# scripts/simulacion.R
# Asegura entorno y carga función
if (file.exists("renv/activate.R")) source("renv/activate.R")
source("src/simulate_data.R")

# Parámetros
n <- 500
seed <- 2026
alpha <- 1200
beta <- 180
sd_error <- 400
prob_desempleo <- 0.12

# Ejecutar simulación
datos <- simulate_data(
  n = n, seed = seed,
  alpha = alpha, beta = beta,
  sd_error = sd_error,
  prob_desempleo = prob_desempleo
)

# Crear carpeta de salida si no existe
outdir <- file.path("data", "raw")
if (!dir.exists(outdir)) dir.create(outdir, recursive = TRUE)

# Guardar CSV en la estructura
outfile <- file.path(outdir, "datos_simulados.csv")
write.csv(datos, outfile, row.names = FALSE)

message("OK: datos simulados guardados en ", normalizePath(outfile))
