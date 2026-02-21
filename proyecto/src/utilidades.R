# src/utilidades.R
if (file.exists("renv/activate.R")) source("renv/activate.R")

#' Imputa NA con la mediana (numérico)
imputar_mediana <- function(x) {
  if (!is.numeric(x)) stop("x debe ser numérico")
  x[is.na(x)] <- median(x, na.rm = TRUE)
  x
}

#' Normaliza a [0,1] (numérico)
minmax <- function(x) {
  if (!is.numeric(x)) stop("x debe ser numérico")
  rng <- range(x, na.rm = TRUE)
  if (rng[1] == rng[2]) return(rep(0, length(x)))
  (x - rng[1]) / (rng[2] - rng[1])
}