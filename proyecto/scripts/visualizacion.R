# scripts/visualizacion.R
# Ejecuta la visualización: genera figuras + tabla en PNG (BONITA, sin paquetes extra)

if (file.exists("renv/activate.R")) source("renv/activate.R")
source("src/plot_results.R")

# Entradas
in_processed <- file.path("data", "processed", "datos_procesados.csv")
in_resumen   <- file.path("data", "processed", "resumen_por_grupos.csv")

# Ejecutar con manejo de errores (para que runall.ps1 lo detecte)
out <- tryCatch(
  plot_results(in_processed, in_resumen),
  error = function(e) {
    message("ERROR en la visualización: ", e$message)
    quit(status = 1)
  }
)

# Crear carpetas de salida
figdir <- file.path("results", "figures")
tabdir <- file.path("results", "tables")
if (!dir.exists(figdir)) dir.create(figdir, recursive = TRUE)
if (!dir.exists(tabdir)) dir.create(tabdir, recursive = TRUE)

# ---- Guardar figuras ----
fig1 <- file.path(figdir, "fig_ingreso_boxplot.png")
png(fig1, width = 1200, height = 800, res = 150)
out$plot_ingreso_box()
dev.off()

fig2 <- file.path(figdir, "fig_ingreso_heatmap.png")
png(fig2, width = 1200, height = 800, res = 150)
out$plot_heat_ingreso()
dev.off()

# ---- Guardar tabla como PNG (BONITA, solo base R + grid) ----
save_table_png <- function(df, file, title = "Tabla resumen") {
  suppressPackageStartupMessages(library(grid))

  # Formateo para informe
  df2 <- df
  for (nm in names(df2)) {
    if (is.numeric(df2[[nm]])) {
      if (grepl("ingreso", nm)) df2[[nm]] <- format(round(df2[[nm]], 0), big.mark = ".", decimal.mark = ",")
      else if (grepl("pct", nm)) df2[[nm]] <- format(round(df2[[nm]], 1), nsmall = 1, decimal.mark = ",")
      else df2[[nm]] <- format(round(df2[[nm]], 3), nsmall = 3, decimal.mark = ",")
    } else {
      df2[[nm]] <- as.character(df2[[nm]])
    }
  }

  # Limitar filas si crece mucho (opcional)
  max_rows <- 50
  if (nrow(df2) > max_rows) df2 <- df2[1:max_rows, , drop = FALSE]

  # Tamaño dinámico
  nrows <- nrow(df2)
  ncols <- ncol(df2)
  height <- max(650, 260 + (nrows + 1) * 42) # +1 header
  width  <- 1500

  # Anchos relativos por columna (según texto más largo)
  cols <- names(df2)
  col_maxchars <- sapply(seq_len(ncols), function(j) {
    max(nchar(c(cols[j], df2[[j]])), na.rm = TRUE)
  })
  colw <- col_maxchars / sum(col_maxchars)

  # Layout
  top_margin <- 0.14
  left_margin <- 0.04
  right_margin <- 0.02
  bottom_margin <- 0.04

  table_w <- 1 - left_margin - right_margin
  table_h <- 1 - top_margin - bottom_margin

  row_h <- table_h / (nrows + 1) # header + rows

  x_lefts  <- left_margin + c(0, cumsum(colw)[-length(colw)]) * table_w
  x_rights <- left_margin + cumsum(colw) * table_w

  png(file, width = width, height = height, res = 160)
  grid.newpage()

  # Fondo
  grid.rect(gp = gpar(col = NA, fill = "white"))

  # Título centrado
  grid.text(
    title,
    x = 0.5, y = 1 - 0.06,
    gp = gpar(fontsize = 18, fontface = "bold")
  )

  # Header background
  y_header_top <- 1 - top_margin
  y_header_bottom <- y_header_top - row_h

  grid.rect(
    x = left_margin + table_w / 2,
    y = y_header_bottom + row_h / 2,
    width = table_w,
    height = row_h,
    gp = gpar(fill = "#F2F2F2", col = "#BDBDBD", lwd = 1)
  )

  # Header cells + text
  for (j in seq_len(ncols)) {
    grid.rect(
      x = (x_lefts[j] + x_rights[j]) / 2,
      y = y_header_bottom + row_h / 2,
      width = (x_rights[j] - x_lefts[j]),
      height = row_h,
      gp = gpar(fill = NA, col = "#BDBDBD", lwd = 1)
    )
    grid.text(
      cols[j],
      x = x_lefts[j] + 0.008,
      y = y_header_bottom + row_h / 2,
      just = "left",
      gp = gpar(fontsize = 12, fontface = "bold")
    )
  }

  # Body rows
  for (i in seq_len(nrows)) {
    y_top <- y_header_bottom - (i - 1) * row_h
    y_bottom <- y_top - row_h

    # Sombreado alternado
    if (i %% 2 == 0) {
      grid.rect(
        x = left_margin + table_w / 2,
        y = y_bottom + row_h / 2,
        width = table_w,
        height = row_h,
        gp = gpar(fill = "#FAFAFA", col = NA)
      )
    }

    for (j in seq_len(ncols)) {
      # Cell border
      grid.rect(
        x = (x_lefts[j] + x_rights[j]) / 2,
        y = y_bottom + row_h / 2,
        width = (x_rights[j] - x_lefts[j]),
        height = row_h,
        gp = gpar(fill = NA, col = "#D0D0D0", lwd = 0.8)
      )

      val <- df2[i, j]

      # Alineación: números a la derecha, texto a la izquierda
      is_num_like <- grepl("^[0-9]", val) || grepl("^\\-", val)

      if (is_num_like) {
        grid.text(
          val,
          x = x_rights[j] - 0.008,
          y = y_bottom + row_h / 2,
          just = "right",
          gp = gpar(fontsize = 12)
        )
      } else {
        grid.text(
          val,
          x = x_lefts[j] + 0.008,
          y = y_bottom + row_h / 2,
          just = "left",
          gp = gpar(fontsize = 12)
        )
      }
    }
  }

  dev.off()
}

# Exportar tabla
tab_img <- file.path(tabdir, "tabla_resumen_por_grupos.png")
save_table_png(out$tabla_resumen, tab_img, title = "Resumen por grupos (educación x edad)")

# Mensajes finales
message("OK: visualización completada.")
message(" - ", normalizePath(fig1))
message(" - ", normalizePath(fig2))
message(" - ", normalizePath(tab_img))
