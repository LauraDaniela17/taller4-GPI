# Script maestro para ejecutar la simulación, análisis y visualización 
# del proyecto.
# Las funciones se encuentran en /src y los scripts en /scripts.


Write-Host "==> [Fase 2] Simulacion de datos" -ForegroundColor Cyan

# Ruta a Rscript (ajusta si usas bin\x64)
$Rscript = "C:\Program Files\R\R-4.4.1\bin\Rscript.exe"
$Script  = "scripts/simulacion.R"

# Ejecutar y capturar salida y errores
$proc = Start-Process -FilePath $Rscript -ArgumentList $Script -NoNewWindow -PassThru -Wait
if ($proc.ExitCode -ne 0) {
    Write-Error "La simulación falló. Código de salida: $($proc.ExitCode)"
    exit 1
} else {
    Write-Host "OK: simulacion finalizada." -ForegroundColor Green
}

Write-Host "==> [Fase 3] Analisis" -ForegroundColor Cyan
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" "scripts/analisis.R"
if ($LASTEXITCODE -ne 0) { Write-Error "El análisis falló"; exit 1 }

Write-Host "==> [Fase 4] Visualizacion" -ForegroundColor Cyan
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" "scripts/visualizacion.R"
if ($LASTEXITCODE -ne 0) { Write-Error "La visualización falló"; exit 1 }
else { Write-Host "OK: visualizacion finalizada." -ForegroundColor Green }
