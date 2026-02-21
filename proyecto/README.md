# taller4-GPI
Desarrollo actividades Taller 4 - GPI_CA

## Entorno computacional

Este proyecto fue desarrollado bajo un entorno computacional reproducible.  
Para garantizar que los resultados puedan ser replicados en otros equipos, se documentan a continuación las principales especificaciones y dependencias utilizadas:

- **Sistema operativo:** Windows 11 (64 bits)  
- **Lenguaje de programación:** R (versión 4.4.1)  
- **Editor/IDE:** Visual Studio Code (versión 1.109.2, x64)
- **Automatización:** PowerShell (`runall.ps1`) y R (`runall.R`)  
- **Gestión de dependencias:** `renv`

### Dependencias del proyecto

Las librerías necesarias para ejecutar el pipeline se encuentran registradas en el archivo:

- `renv.lock`

Entre los paquetes utilizados se incluyen:

- `ggplot2`
- `gridExtra`
- `renv`

### Reproducibilidad

Para restaurar el entorno computacional en otro equipo, ejecute en R:

```r
renv::restore()
