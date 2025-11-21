# 🚀 Guía de Instalación Rápida

**Desafío de Machine Learning en Economía de la Salud**
**Universidad Nacional del Oeste - 2025**

---

## ⏱️ Tiempo estimado: 30-45 minutos

Esta guía te llevará paso a paso desde cero hasta tener el proyecto funcionando en tu computadora.

---

## 📋 Checklist Rápido

Antes de empezar, verificá que tengas:

- [ ] Cuenta en GitHub creada
- [ ] Git instalado (o GitHub Desktop)
- [ ] R instalado (versión 4.0+)
- [ ] RStudio instalado
- [ ] Al menos 4 GB de RAM disponible
- [ ] Al menos 2 GB de espacio en disco

---

## Paso 1: Obtener el Código (GitHub)

### Opción A: Si tu grupo ya hizo el Fork

1. Pedile al compañero que hizo el Fork la URL del repositorio
2. Debería ser algo como: `https://github.com/USUARIO_DEL_GRUPO/health_economics_challenge`
3. Seguí al **Paso 2** para clonar

### Opción B: Si sos el primero del grupo

1. Andá al repositorio del profesor: `https://github.com/panchtox/health_economics_challenge`
2. Hacé clic en **"Fork"** (arriba a la derecha)
3. Esperá a que se cree tu copia
4. Agregá a tus compañeros como colaboradores:
   - Settings → Collaborators → Add people
5. Seguí al **Paso 2**

**Nota:** Para más detalles, consultá el [Instructivo GitHub](../Instructivo_GitHub_Desafio_ML_Salud_FINAL.md)

---

## Paso 2: Clonar el Repositorio

### Con GitHub Desktop (Recomendado)

1. Abrí GitHub Desktop
2. File → Clone Repository
3. Seleccioná el repositorio del grupo o pegá la URL
4. Elegí dónde guardarlo (ej: `C:\Users\TuUsuario\Documents\`)
5. Hacé clic en **Clone**

### Con Git (Línea de comandos)

```bash
cd ~/Documents/
git clone https://github.com/USUARIO_DEL_GRUPO/health_economics_challenge.git
cd health_economics_challenge
```

---

## Paso 3: Instalar R y RStudio

### 3.1. Instalar R

1. Andá a: **https://cran.r-project.org/**
2. Hacé clic en "Download R for Windows" (o tu sistema operativo)
3. Descargá la versión más reciente (ej: R-4.4.x)
4. Ejecutá el instalador y seguí los pasos (siguiente, siguiente, finalizar)
5. Verificá la instalación:
   - Abrí el símbolo del sistema (CMD)
   - Escribí: `R --version`
   - Deberías ver algo como: `R version 4.4.x`

### 3.2. Instalar RStudio

1. Andá a: **https://posit.co/download/rstudio-desktop/**
2. Descargá RStudio Desktop (versión gratuita)
3. Ejecutá el instalador
4. Abrí RStudio para verificar que funcione

---

## Paso 4: Instalar Librerías de R

### 4.1. Abrir RStudio

1. Abrí RStudio
2. En la consola (abajo a la izquierda), copiá y pegá el siguiente código:

```r
# Lista de librerías necesarias
paquetes <- c(
  "data.table",      # Manipulación eficiente de datos
  "lightgbm",        # Gradient Boosting Machine Learning
  "yaml",            # Lectura de archivos de configuración
  "mlrMBO",          # Optimización Bayesiana
  "DiceKriging",     # Soporte para mlrMBO
  "rlist",           # Utilidades para listas
  "lubridate",       # Manejo de fechas
  "primes"           # Números primos (para canaritos)
)

# Instalar paquetes que falten
install.packages(paquetes)
```

3. Presioná **Enter** y esperá (puede tardar 5-10 minutos)

### 4.2. Verificar Instalación

Ejecutá este código para verificar que todo esté instalado:

```r
# Test de librerías
for (lib in paquetes) {
  if (require(lib, character.only = TRUE)) {
    cat("✓", lib, "instalado correctamente\n")
  } else {
    cat("✗", lib, "NO ENCONTRADO\n")
  }
}
```

Si alguna librería muestra ✗, intentá instalarla individualmente:

```r
install.packages("NOMBRE_DE_LA_LIBRERIA")
```

---

## Paso 5: Configurar el Proyecto

### 5.1. Abrir el Proyecto en RStudio

1. En RStudio: **File → Open Project...**
2. Navegá a la carpeta donde clonaste el repositorio
3. Si hay un archivo `.Rproj`, abrilo
4. Si no, simplemente abrí: **File → Open File...** → `codigo_base/0_HEALTH_EXE.R`

### 5.2. Configurar la Ruta Base

1. Abrí el archivo: `codigo_base/CONFIG_basico.yml`
2. En la línea 2-3, cambiá la ruta base:

```yaml
environment:
  base_dir: "C:/RUTA/COMPLETA/A/health_economics_challenge"
```

**Ejemplo Windows:**
```yaml
base_dir: "C:/Users/Juan/Documents/health_economics_challenge"
```

**Ejemplo Mac/Linux:**
```yaml
base_dir: "/Users/juan/Documents/health_economics_challenge"
```

**⚠️ IMPORTANTE:**
- Usá `/` (slash) NO `\` (backslash)
- NO pongas barra al final
- La ruta debe apuntar a la carpeta raíz del proyecto

### 5.3. Verificar que el Dataset Esté Presente

1. Verificá que exista el archivo: `dataset/dataset_desafio.csv`
2. Este es el dataset reducido con 23 países (recomendado para comenzar)
3. Si tenés 16GB+ de RAM, podés usar `dataset/dataset_desafio_paises_todos.csv`
4. Si no están, contactá al profesor

---

## Paso 6: Prueba Inicial (Test Run)

Ahora vamos a hacer una prueba rápida para verificar que todo funcione:

### 6.1. Test de Lectura de Datos

En RStudio, ejecutá este código línea por línea:

```r
# Cargar librería
library(data.table)

# Configurar ruta (CAMBIAR POR TU RUTA)
setwd("C:/Users/TuUsuario/Documents/health_economics_challenge")

# Leer dataset
dataset <- fread("dataset/dataset_desafio.csv")

# Verificar que se cargó correctamente
cat("Dataset cargado:", nrow(dataset), "filas,", ncol(dataset), "columnas\n")

# Ver primeras filas
head(dataset)

# Ver estructura
str(dataset)
```

**Resultado esperado (dataset reducido - 23 países):**
```
Dataset cargado: ~500 filas, ~400 columnas
```

**Resultado esperado (dataset completo - 78 países):**
```
Dataset cargado: ~1700 filas, ~400 columnas
```

### 6.2. Test de Configuración

Ejecutá:

```r
library(yaml)

# Leer configuración
config <- yaml.load_file("codigo_base/CONFIG_basico.yml")

# Verificar que se leyó correctamente
cat("Configuración cargada correctamente\n")
cat("Año presente:", config$feature_engineering$const$presente, "\n")
cat("Orden lead:", config$feature_engineering$const$orden_lead, "\n")
```

**Resultado esperado:**
```
Configuración cargada correctamente
Año presente: 2021
Orden lead: 1
```

---

## Paso 7: Primera Ejecución Completa (Opcional)

**⚠️ ADVERTENCIA:** La primera ejecución completa tarda aproximadamente **6 horas** con el dataset reducido (23 países).

**💡 Recomendación:** NO ejecutes el pipeline completo ahora. En su lugar:
1. Esperá a tener tu Feature Engineering listo
2. Planificá ejecutarlo de noche o durante el fin de semana
3. Asegurate de que tu computadora no se apague (configurá "Suspender" en Nunca)

Si igual querés probarlo:

1. Abrí el archivo: `codigo_base/0_HEALTH_EXE.R`
2. Revisá que la configuración inicial esté correcta (líneas 1-30)
3. Ejecutá el script completo: **Code → Run Region → Run All** (o Ctrl+Alt+R)
4. Observá los mensajes en la consola

**Lo que va a pasar:**
1. ✅ Feature Engineering (~5-10 min)
2. ✅ Training Strategy (~10-20 min)
3. ✅ Hyperparameter Tuning (~5-6 horas)

**Si todo sale bien:** Verás una carpeta nueva `exp/` con los resultados.

**Si falla:** Revisá la sección de **Problemas Comunes** abajo.

---

## 🆘 Problemas Comunes

### Problema 1: "Error: no se pudo encontrar la función 'fread'"

**Causa:** La librería `data.table` no está cargada.

**Solución:**
```r
library(data.table)
```

---

### Problema 2: "Error al instalar lightgbm"

**Causa:** `lightgbm` requiere compiladores C++ en algunos sistemas.

**Solución Windows:**
1. Instalá Rtools: https://cran.r-project.org/bin/windows/Rtools/
2. Reiniciá RStudio
3. Intentá de nuevo:
```r
install.packages("lightgbm", type = "source")
```

**Solución Mac:**
```bash
# En la terminal:
xcode-select --install

# Luego en R:
install.packages("lightgbm")
```

**Solución Linux (Ubuntu/Debian):**
```bash
sudo apt-get install cmake build-essential
```

---

### Problema 3: "cannot open file 'dataset/dataset_desafio.csv'"

**Causa:** El Working Directory no está configurado correctamente.

**Solución:**
```r
# Verificá dónde estás
getwd()

# Cambiá a la carpeta correcta
setwd("C:/RUTA/COMPLETA/A/health_economics_challenge")

# Verificá que ahora el archivo exista
file.exists("dataset/dataset_desafio.csv")  # Debe devolver TRUE
```

---

### Problema 4: "Error in yaml.load_file : cannot open the connection"

**Causa:** La ruta al archivo YML es incorrecta.

**Solución:**
```r
# Verificá que el archivo exista
file.exists("codigo_base/CONFIG_basico.yml")  # Debe devolver TRUE

# Si devuelve FALSE, verificá tu Working Directory
getwd()
```

---

### Problema 5: "La computadora se queda sin memoria (RAM)"

**Causa:** El dataset es grande y tu computadora tiene poca RAM.

**Solución:** Consultá la guía [03_guia_recursos_computacionales.md](03_guia_recursos_computacionales.md)

---

### Problema 6: Git no funciona / No puedo clonar

**Causa:** Git no está instalado o no está en el PATH.

**Solución:**
- Descargá GitHub Desktop: https://desktop.github.com/ (más fácil)
- O instalá Git: https://git-scm.com/download/win

---

## ✅ Verificación Final

Antes de continuar con el desafío, verificá que todo esto funcione:

- [ ] Podés clonar el repositorio del grupo
- [ ] Podés abrir RStudio
- [ ] Todas las librerías están instaladas
- [ ] Podés leer el dataset con `fread()`
- [ ] Podés leer la configuración con `yaml.load_file()`
- [ ] (Opcional) Ejecutaste el pipeline completo una vez

---

## 📚 Próximos Pasos

Una vez que todo esté instalado:

1. **Leé el README principal:** [../README.md](../README.md)
2. **Aprendé a ejecutar experimentos:** [02_guia_ejecucion_experimentos.md](02_guia_ejecucion_experimentos.md)
3. **Entendé el flujo de trabajo del grupo:** [Instructivo GitHub](../Instructivo_GitHub_Desafio_ML_Salud_FINAL.md)

---

## 💬 ¿Necesitás Ayuda?

Si después de revisar esta guía seguís con problemas:

1. Consultá la [FAQ Técnico](04_FAQ_tecnico.md)
2. Preguntale a tus compañeros de grupo
3. Consultá en el foro del campus virtual
4. Enviá un email al docente con:
   - Descripción del problema
   - Mensaje de error completo (screenshot)
   - Tu sistema operativo
   - Versión de R (`R.version.string`)

---

**¡Éxitos con el desafío!** 🚀📊

---

**Última actualización:** Noviembre 2025
**Autor:** Francisco Fernández
