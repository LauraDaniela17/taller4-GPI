# analisis/estadisticas.R
# Estadísticas descriptivas simples

estadisticas_descriptivas <- function(df) {
  # ERROR intencional: meanx no existe (debería ser mean)
  data.frame(
    n = nrow(df),
    media_ingreso = mean(df$ingreso_mensual, na.rm = TRUE),
    sd_ingreso = sd(df$ingreso_mensual, na.rm = TRUE)
  )
}