# Taller 4 - GPI_CA

## 📌 Descripción del proyecto

Este repositorio contiene el desarrollo del Taller 4 del curso **Gestión de Proyectos de Investigación y Ciencia Abierta (GPI_CA)**.

El proyecto implementa un flujo de trabajo reproducible en R que incluye:

- Generación y simulación de datos  
- Procesamiento y limpieza  
- Modelamiento estadístico  
- Visualización de resultados  
- Exportación de tablas y figuras  

El pipeline está estructurado en tres etapas principales que garantizan organización, trazabilidad y reproducibilidad.

---

# Flujos de trabajo del proyecto

## Etapa I: Información Inicial (Data Input)

**Objetivo:** Generar o recopilar los datos base del análisis.

**Componentes:**

- Simulación de datos  
  - `proyecto/scripts/simulacion.R`  
  - `proyecto/src/simulate_data.R`  

- Datos sin procesar generados:  
  - `proyecto/data/raw/datos_simulados.csv`  

**Flujo:**

Código → Simulación → Datos crudos

---

## Etapa II: Procesamiento de Información (Data Processing)

**Objetivo:** Limpiar, transformar y preparar los datos para el análisis.

**Componentes:**

- Código de análisis:  
  - `proyecto/scripts/analisis.R`  
  - `proyecto/src/analyze_data.R`  

- Datos procesados generados:  
  - `proyecto/data/processed/datos_procesados.csv`  

**Flujo:**

Datos crudos → Limpieza y procesamiento → Datos procesados

---

## Etapa III: Modelamiento y Visualización (Data Analysis)

**Objetivo:** Ajustar modelos estadísticos y generar visualizaciones.

**Componentes:**

- Modelamiento:  
  - `proyecto/scripts/modelado.R`  
  - `proyecto/src/fit_model.R`  

- Visualización:  
  - `proyecto/scripts/visualizacion.R`  
  - `proyecto/src/plot_results.R`  

- Resultados generados:  
  - `proyecto/results/tables`  
  - `proyecto/results/figures`  

**Flujo:**

Datos procesados → Modelamiento / Visualización → Resultados finales

---

# Entorno computacional

Este proyecto fue desarrollado bajo un entorno computacional reproducible.

Para garantizar que los resultados puedan ser replicados en otros equipos, se documentan a continuación las principales especificaciones:

- Sistema operativo: Windows 11 (64 bits)  
- Lenguaje de programación: R (versión 4.4.1)  
- Editor/IDE: Visual Studio Code (versión 1.109.2, x64)  
- Automatización: PowerShell (`runall.ps1`) y R (`runall.R`)  
- Gestión de dependencias: `renv`  

---

# Dependencias del proyecto

Las librerías necesarias para ejecutar el pipeline se encuentran registradas en:

```
renv.lock
```

Entre los paquetes utilizados se incluyen:

- ggplot2  
- gridExtra  
- renv  

---

# Reproducibilidad

Para restaurar el entorno computacional en otro equipo, ejecutar en R:

```r
renv::restore()
```

Esto instalará automáticamente las versiones exactas de los paquetes utilizadas en el desarrollo del proyecto.

---

# Ejecución del pipeline

Para ejecutar todo el flujo de trabajo de manera automatizada:

### Desde PowerShell:

```powershell
.\runall.ps1
```

### Desde R:

```r
source("runall.R")
```

Esto ejecutará secuencialmente:

1. Simulación de datos  
2. Procesamiento  
3. Modelamiento  
4. Generación de resultados  

---

# Diagramas del flujo de trabajo

El repositorio incluye:

- `diagram.mermaid` → Versión en Mermaid  
- `diagram.drawio` → Versión editable en Draw.io  
- `diagram.png` → Versión exportada como imagen  

Estos diagramas representan gráficamente el pipeline reproducible del proyecto.

---

# Buenas prácticas implementadas

- Organización estructurada de carpetas (`raw`, `processed`, `results`)  
- Separación entre scripts y funciones (`scripts/` y `src/`)  
- Automatización del pipeline  
- Control de versiones con Git y GitHub  
- Gestión de dependencias con `renv`  

---

# Consideraciones finales

El proyecto sigue principios de ciencia abierta y reproducibilidad, permitiendo que cualquier usuario pueda:

- Restaurar el entorno computacional  
- Ejecutar el pipeline completo  
- Obtener los mismos resultados  

Esto garantiza transparencia, trazabilidad y buenas prácticas en investigación reproducible.