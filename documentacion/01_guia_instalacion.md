# 🔧 Guía de Instalación y Setup

**Health Economics ML Challenge - UNO 2025**

Esta guía te ayudará a configurar el entorno completo para ejecutar el pipeline de Machine Learning.

---

## 📋 Índice

1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación de R y RStudio](#instalación-de-r-y-rstudio)
3. [Instalación de Librerías R](#instalación-de-librerías-r)
4. [Configuración del Proyecto](#configuración-del-proyecto)
5. [Verificación de Instalación](#verificación-de-instalación)
6. [Problemas Comunes](#problemas-comunes)

---

## 💻 Requisitos del Sistema

### Mínimos
- **Sistema Operativo:** Windows 10/11, macOS 10.14+, o Linux (Ubuntu 20.04+)
- **RAM:** 8 GB mínimo
- **Espacio en Disco:** 5 GB libres
- **Procesador:** Intel i5 o equivalente

### Recomendados (para mejor performance)
- **RAM:** 16 GB o más
- **Procesador:** Intel i7 o AMD Ryzen 5 o superior
- **SSD:** Recomendado para lectura/escritura rápida de datos

**Nota:** El Hyperparameter Tuning (03_HT) es la etapa más intensiva y puede tomar 30-60 minutos en equipos promedio.

---

## 📥 Instalación de R y RStudio

### Paso 1: Instalar R

#### Windows
1. Ir a https://cran.r-project.org/bin/windows/base/
2. Descargar el instalador más reciente (R-4.x.x-win.exe)
3. Ejecutar el instalador con opciones por defecto
4. **Importante:** Durante la instalación, marcar "Add R to PATH"

#### macOS
1. Ir a https://cran.r-project.org/bin/macosx/
2. Descargar el archivo .pkg correspondiente a tu versión de macOS
3. Ejecutar el instalador

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install r-base r-base-dev
```

### Paso 2: Instalar RStudio Desktop

1. Ir a https://posit.co/download/rstudio-desktop/
2. Descargar RStudio Desktop (versión gratuita)
3. Instalar con opciones por defecto

### Verificar Instalación

Abrir RStudio y ejecutar en la consola:
```r
version
```

Deberías ver algo como:
```
platform       x86_64-w64-mingw32          
arch           x86_64                      
os             mingw32                     
system         x86_64, mingw32             
major          4                           
minor          3.2                         
```

---

## 📦 Instalación de Librerías R

### Método 1: Instalación Interactiva (Recomendado)

Copiar y pegar este código en la consola de RStudio:

```r
# Lista de paquetes necesarios
packages <- c(
  "data.table",      # Manipulación rápida de datos
  "lightgbm",        # Gradient Boosting Machine Learning
  "yaml",            # Lectura de archivos de configuración
  "mlrMBO",          # Optimización Bayesiana
  "DiceKriging",     # Kriging para mlrMBO
  "rlist",           # Utilidades para listas
  "lubridate",       # Manejo de fechas
  "primes",          # Números primos (para canaritos)
  "jsonlite"         # Lectura/escritura JSON
)

# Instalar paquetes que no estén instalados
nuevos_paquetes <- packages[!(packages %in% installed.packages()[,"Package"])]

if(length(nuevos_paquetes) > 0) {
  install.packages(nuevos_paquetes, dependencies = TRUE)
  cat("Instalados:", length(nuevos_paquetes), "paquetes nuevos\n")
} else {
  cat("Todos los paquetes ya están instalados\n")
}

# Verificar instalación
cat("\n=== VERIFICACIÓN DE INSTALACIÓN ===\n")
for(pkg in packages) {
  if(require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("✓", pkg, "- OK\n")
  } else {
    cat("✗", pkg, "- ERROR\n")
  }
}
```

### Método 2: Instalación Manual (uno por uno)

Si el método anterior falla, instalar uno por uno:

```r
install.packages("data.table")
install.packages("lightgbm")
install.packages("yaml")
install.packages("mlrMBO")
install.packages("DiceKriging")
install.packages("rlist")
install.packages("lubridate")
install.packages("primes")
install.packages("jsonlite")
```

### Instalación Especial: LightGBM (si falla)

LightGBM a veces requiere instalación especial:

#### Windows con RTools
Si `install.packages("lightgbm")` falla:

1. Instalar Rtools desde: https://cran.r-project.org/bin/windows/Rtools/
2. Reiniciar RStudio
3. Ejecutar:
```r
install.packages("lightgbm", repos = "https://cran.r-project.org")
```

#### Linux
```bash
# Instalar dependencias del sistema
sudo apt-get install -y cmake libboost-dev libboost-system-dev libboost-filesystem-dev

# Luego en R:
install.packages("lightgbm")
```

#### macOS
```bash
# Instalar Homebrew si no lo tienes
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar cmake y libomp
brew install cmake libomp

# Luego en R:
install.packages("lightgbm")
```

---

## 📁 Configuración del Proyecto

### Paso 1: Descargar el Proyecto

Opción A: **Descomprimir ZIP**
1. Descomprimir `health_economics_challenge.zip` en una ubicación sin espacios ni caracteres especiales
2. Ejemplo: `C:/Users/TuNombre/Documentos/health_economics_challenge/`

Opción B: **Clonar con Git** (si está disponible)
```bash
git clone [URL_REPOSITORIO] health_economics_challenge
cd health_economics_challenge
```

### Paso 2: Verificar Estructura de Archivos

La estructura debe verse así:

```
health_economics_challenge/
├── README.md
├── codigo_base/
│   ├── 0_HEALTH_YML.yml
│   ├── 0_HEALTH_EXE.R
│   ├── 01_FE_health_ALUMNO.R
│   ├── 02_TS_health.R
│   └── 03_HT_health.R
├── dataset/
│   ├── dataset_desafio.csv
│   └── diccionario_variables.md
└── documentacion/
    ├── 01_guia_instalacion.md  (este archivo)
    ├── 02_guia_estrategia_covid.md
    └── ...
```

### Paso 3: Configurar Path del Proyecto

Editar `codigo_base/0_HEALTH_YML.yml`:

```yaml
environment:
  base_dir: "RUTA/COMPLETA/A/health_economics_challenge"  # ← CAMBIAR AQUÍ
  data_dir: "./dataset"
```

**Importante:**
- Usar barras `/` (no `\`) incluso en Windows
- NO incluir espacios en la ruta
- NO usar tildes o caracteres especiales en la ruta

**Ejemplos válidos:**
```yaml
# Windows
base_dir: "C:/Users/Juan/Documentos/health_economics_challenge"

# macOS
base_dir: "/Users/juan/Documents/health_economics_challenge"

# Linux
base_dir: "/home/juan/health_economics_challenge"
```

**Ejemplos INVÁLIDOS:**
```yaml
base_dir: "C:\Users\Juan\Documentos\health_economics_challenge"  # ❌ Barras invertidas
base_dir: "C:/Program Files/health_economics_challenge"          # ❌ Espacios
base_dir: "C:/Users/José/health_economics_challenge"             # ❌ Tildes
```

### Paso 4: Configurar Parámetros Iniciales

En `0_HEALTH_YML.yml`, reemplazar los `???` con valores iniciales:

```yaml
feature_engineering:
  const:
    orden_lead: 1      # Empezar con 1
    presente: 2021     # Empezar con 2021
    
training_strategy:
  param:
    train:
      excluir: []      # Empezar sin excluir años
```

---

## ✅ Verificación de Instalación

### Test Completo de Instalación

Ejecutar este script en RStudio para verificar que todo funcione:

```r
# ============================================
# SCRIPT DE VERIFICACIÓN DE INSTALACIÓN
# ============================================

cat("=== INICIANDO VERIFICACIÓN ===\n\n")

# 1. Verificar librerías
cat("1. Verificando librerías...\n")
packages <- c("data.table", "lightgbm", "yaml", "mlrMBO", 
              "DiceKriging", "rlist", "lubridate", "primes", "jsonlite")

all_ok <- TRUE
for(pkg in packages) {
  if(require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("   ✓", pkg, "\n")
  } else {
    cat("   ✗", pkg, "- ERROR\n")
    all_ok <- FALSE
  }
}

if(!all_ok) {
  stop("ERROR: Algunas librerías no están instaladas correctamente.")
}

cat("\n2. Verificando path del proyecto...\n")

# Cargar YAML
yml_path <- "codigo_base/0_HEALTH_YML.yml"
if(file.exists(yml_path)) {
  cat("   ✓ 0_HEALTH_YML.yml encontrado\n")
  
  PARAMS <- yaml.load_file(yml_path)
  base_dir <- PARAMS$environment$base_dir
  
  if(dir.exists(base_dir)) {
    cat("   ✓ base_dir existe:", base_dir, "\n")
  } else {
    cat("   ✗ base_dir NO existe:", base_dir, "\n")
    cat("   → Edita 0_HEALTH_YML.yml con la ruta correcta\n")
    all_ok <- FALSE
  }
} else {
  cat("   ✗ No se encuentra 0_HEALTH_YML.yml\n")
  cat("   → Verifica que estés en el directorio correcto del proyecto\n")
  all_ok <- FALSE
}

cat("\n3. Verificando dataset...\n")
if(file.exists("dataset/dataset_desafio.csv")) {
  cat("   ✓ dataset_desafio.csv encontrado\n")
  
  # Intentar cargar unas pocas líneas
  test_data <- fread("dataset/dataset_desafio.csv", nrows = 5)
  cat("   ✓ Dataset se puede leer correctamente\n")
  cat("   → Variables:", ncol(test_data), "\n")
  cat("   → Primeras filas leídas exitosamente\n")
} else {
  cat("   ✗ dataset_desafio.csv NO encontrado\n")
  all_ok <- FALSE
}

cat("\n4. Verificando scripts...\n")
scripts <- c(
  "codigo_base/0_HEALTH_EXE.R",
  "codigo_base/01_FE_health_ALUMNO.R",
  "codigo_base/02_TS_health.R",
  "codigo_base/03_HT_health.R"
)

for(script in scripts) {
  if(file.exists(script)) {
    cat("   ✓", basename(script), "\n")
  } else {
    cat("   ✗", basename(script), "NO encontrado\n")
    all_ok <- FALSE
  }
}

# Resultado final
cat("\n=== RESULTADO FINAL ===\n")
if(all_ok) {
  cat("✅ TODO CORRECTO! El proyecto está listo para ejecutarse.\n")
  cat("\nPróximos pasos:\n")
  cat("1. Editar 01_FE_health_ALUMNO.R para agregar tus variables\n")
  cat("2. Ejecutar: source('codigo_base/0_HEALTH_EXE.R')\n")
} else {
  cat("❌ HAY ERRORES. Revisa los mensajes arriba y corrige antes de continuar.\n")
}
```

Si ves "✅ TODO CORRECTO!", estás listo para empezar.

---

## 🐛 Problemas Comunes

### Problema: "package 'xxx' is not available"

**Solución:**
```r
# Actualizar repositorios CRAN
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# Reintentar instalación
install.packages("nombre_paquete")
```

### Problema: "Error: HTTP status was '404 Not Found'"

**Solución:**
```r
# Cambiar mirror de CRAN
chooseCRANmirror()  # Seleccionar un mirror cercano geográficamente
```

### Problema: "cannot open file... Permission denied"

**Causa:** Archivo abierto en otro programa o sin permisos de escritura.

**Solución:**
- Cerrar todos los archivos CSV/Excel abiertos
- Ejecutar RStudio como Administrador (Windows)
- Verificar permisos de la carpeta del proyecto

### Problema: "could not find function 'fread'"

**Causa:** Librería no cargada.

**Solución:**
```r
library(data.table)  # Cargar la librería antes de usar
```

### Problema: Error al compilar LightGBM (Windows)

**Solución:**
1. Instalar Rtools: https://cran.r-project.org/bin/windows/Rtools/
2. Reiniciar R/RStudio completamente
3. Ejecutar:
```r
Sys.setenv(PATH = paste(Sys.getenv("PATH"), "C:/rtools43/mingw64/bin", sep = ";"))
install.packages("lightgbm")
```

### Problema: "objeto 'PARAMS' no encontrado"

**Causa:** El YAML no se cargó correctamente.

**Solución:**
```r
# Verificar que estés en el directorio correcto
getwd()  # Debe mostrar la carpeta health_economics_challenge

# Si no, ajustar:
setwd("C:/ruta/correcta/health_economics_challenge")

# Recargar YAML
library(yaml)
PARAMS <- yaml.load_file("codigo_base/0_HEALTH_YML.yml")
```

### Problema: "Error in setwd... cannot change working directory"

**Causa:** La ruta en `base_dir` no existe o está mal escrita.

**Solución:**
1. Verificar que la carpeta existe
2. Usar barras `/` (no `\`)
3. No usar espacios ni caracteres especiales en la ruta

---

## 🚀 Siguiente Paso

Una vez que la verificación sea exitosa:

**Ir a:** [02_guia_estrategia_covid.md](02_guia_estrategia_covid.md) para entender el dilema estratégico principal del desafío.

---

## 📞 ¿Necesitas Ayuda?

Si después de seguir esta guía aún tienes problemas:

1. Revisa [05_FAQ_tecnico.md](05_FAQ_tecnico.md) para más soluciones
2. Consulta con tus compañeros de grupo
3. Pregunta en clase o por email al docente

**Tip:** Al reportar un problema, incluye:
- Sistema operativo y versión
- Versión de R (`version` en consola)
- Mensaje de error completo
- Qué paso estabas ejecutando

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0
