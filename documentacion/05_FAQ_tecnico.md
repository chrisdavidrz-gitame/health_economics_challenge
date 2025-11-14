# 🐛 FAQ Técnico - Solución de Problemas

**Health Economics ML Challenge - UNO 2025**

Esta guía resuelve los problemas técnicos más comunes que pueden encontrar al ejecutar el pipeline.

---

## 📋 Índice

1. [Problemas de Instalación](#problemas-de-instalación)
2. [Errores al Cargar Librerías](#errores-al-cargar-librerías)
3. [Errores en Feature Engineering](#errores-en-feature-engineering)
4. [Errores en Training Strategy](#errores-en-training-strategy)
5. [Errores en Hyperparameter Tuning](#errores-en-hyperparameter-tuning)
6. [Problemas de Performance](#problemas-de-performance)
7. [Problemas con Paths y Directorios](#problemas-con-paths-y-directorios)
8. [Otros Problemas Comunes](#otros-problemas-comunes)

---

## 🔧 Problemas de Instalación

### P: "Error: package 'lightgbm' is not available"

**Causa:** El paquete no está en CRAN o hay problema con el repositorio.

**Solución:**
```r
# Opción 1: Actualizar repositorios
options(repos = c(CRAN = "https://cloud.r-project.org/"))
install.packages("lightgbm")

# Opción 2: Instalar desde GitHub (requiere devtools)
install.packages("devtools")
devtools::install_github("microsoft/LightGBM", subdir = "R-package")

# Opción 3: Cambiar mirror
chooseCRANmirror()  # Seleccionar un mirror diferente
install.packages("lightgbm")
```

### P: Error al compilar LightGBM en Windows

**Causa:** Falta Rtools o no está en el PATH.

**Solución:**
1. Descargar e instalar Rtools: https://cran.r-project.org/bin/windows/Rtools/
2. Reiniciar RStudio COMPLETAMENTE
3. Verificar:
```r
Sys.which("make")  # Debe mostrar la ruta a make.exe
```
4. Si NO muestra nada:
```r
# Agregar Rtools al PATH
Sys.setenv(PATH = paste(Sys.getenv("PATH"), 
                        "C:/rtools43/mingw64/bin", 
                        sep = ";"))
```
5. Reintentar instalación:
```r
install.packages("lightgbm")
```

### P: "Error: HTTP status was '404 Not Found'"

**Causa:** Problema con el mirror de CRAN.

**Solución:**
```r
# Seleccionar mirror manualmente
chooseCRANmirror()

# O establecer uno específico
options(repos = "https://cloud.r-project.org/")

# Reintentar
install.packages("nombre_paquete")
```

---

## 📚 Errores al Cargar Librerías

### P: "Error: could not find function 'fread'"

**Causa:** Librería data.table no cargada.

**Solución:**
```r
library(data.table)  # Cargar antes de usar fread()
```

### P: "Error in library(xxx): there is no package called 'xxx'"

**Causa:** Paquete no instalado.

**Solución:**
```r
install.packages("xxx")
library(xxx)
```

### P: "Error: package or namespace load failed for 'lightgbm'"

**Causa:** Dependencias de LightGBM no están instaladas o hay conflicto de versiones.

**Solución:**
```r
# Reinstalar con dependencias
remove.packages("lightgbm")
install.packages("lightgbm", dependencies = TRUE)

# Verificar instalación
library(lightgbm)
```

---

## 🛠️ Errores en Feature Engineering

### P: "Error: objeto 'dataset' no encontrado"

**Causa:** El dataset no se cargó correctamente.

**Solución:**
```r
# Verificar que el archivo existe
file.exists("dataset/dataset_desafio.csv")  # Debe ser TRUE

# Si no existe, verificar path
getwd()  # Debe mostrar la carpeta del proyecto

# Si no es correcta, ajustar:
setwd("C:/ruta/correcta/health_economics_challenge")
```

### P: "Warning: NaNs produced"

**Causa:** División por cero o raíz cuadrada de negativo.

**Solución:**
```r
# Antes de dividir, verificar denominador
dataset[, nueva_var := ifelse(denominador != 0 & !is.na(denominador),
                               numerador / denominador,
                               NA)]

# O usar tryCatch para operaciones complejas
dataset[, nueva_var := tryCatch(operacion_compleja,
                                 error = function(e) NA)]
```

### P: "Error: infinite values in dataset"

**Causa:** Operaciones matemáticas produjeron infinitos (ej: log(0), 1/0).

**Solución:**
```r
# La función AgregarVariables() ya tiene lógica de seguridad
# Pero si aún así hay infinitos, agregar validación explícita:

# Después de crear variables, antes del return:
dataset[mapply(is.infinite, dataset)] <- NA

# O para variable específica:
dataset[is.infinite(nueva_var), nueva_var := NA]
```

### P: "Error: 'clase' variable has NAs"

**Causa:** La variable target (clase) tiene valores faltantes en años donde no debería.

**Solución:**
```r
# Verificar qué años tienen NAs en clase
dataset[is.na(clase), unique(year)]

# Si son años 2000-2021 (NO 2022), hay un problema
# Revisar la creación de la variable clase en 01_FE

# La variable clase se crea como:
# dataset[, clase := get(PARAMS$feature_engineering$const$origen_clase)]
```

### P: Mi variable tiene solo NAs

**Causa:** Operación mal planteada o datos de entrada tienen NAs.

**Solución:**
```r
# Verificar input
summary(dataset$variable_input)

# Ver cuántos NAs hay
sum(is.na(dataset$variable_input))

# Si hay muchos NAs, considerar:
# 1. Usar la variable _isNA que el pipeline crea automáticamente
# 2. Imputar valores (con cuidado)
# 3. Crear la variable solo para registros con datos válidos
dataset[!is.na(var1) & !is.na(var2), nueva_var := var1 / var2]
```

---

## 📊 Errores en Training Strategy

### P: "Error: no hay registros en part_train"

**Causa:** La configuración de `presente` y `orden_lead` dejó sin datos el conjunto de entrenamiento.

**Ejemplo problemático:**
```yaml
presente: 2018
orden_lead: 1
```
Esto predice 2019, y train solo tendría hasta 2017, pero con lags de 4 años perdería datos hasta 2013.

**Solución:**
```r
# Revisar el archivo control.txt después de ejecutar 02_TS
exp/[experimento]/02_TS/control.txt

# Verificar conteos
# Si train tiene 0 registros, ajustar YML:

# Opción 1: Reducir orden_lead
presente: 2018
orden_lead: 1  → cambiar a orden_lead: 1 y presente más alto

# Opción 2: Aumentar presente
presente: 2018 → cambiar a 2020 o 2021
```

### P: "Warning: part_validate está vacío"

**Causa:** La configuración automática o manual dejó validate sin registros.

**Solución:**
```r
# Revisar control.txt
# Si validate = 0, verificar:

# 1. ¿Excluyeron el año de validate?
training_strategy:
  param:
    validate:
      excluir: [2020]  # ← Si validate automático cayó en 2020, queda vacío

# Solución: No excluir ese año o ajustar configuración
```

### P: "Error in setdiff: objeto no encontrado"

**Causa:** Alguna variable esperada no existe en el dataset.

**Solución:**
```r
# Verificar qué variables existen
colnames(dataset)

# Buscar la variable específica mencionada en el error
"nombre_variable" %in% colnames(dataset)

# Si no existe, revisar si se perdió en el Feature Engineering
```

---

## 🤖 Errores en Hyperparameter Tuning

### P: "Error: dtrain is empty"

**Causa:** No hay datos de entrenamiento válidos.

**Solución:**
Ver soluciones de "no hay registros en part_train" arriba.

### P: "Error: label should not contain Inf or NaN"

**Causa:** La variable target (clase) tiene valores infinitos o NaN.

**Solución:**
```r
# Verificar en 01_FE que la variable clase esté bien:
dataset[, summary(clase)]

# Si hay Inf o NaN, limpiar:
dataset[is.infinite(clase), clase := NA]
dataset[is.nan(clase), clase := 0]  # O NA, según convenga
```

### P: El Hyperparameter Tuning toma MÁS de 2 horas

**Causa:** Configuración muy intensiva o hardware limitado.

**Solución temporal:**
```yaml
# En 0_HEALTH_YML.yml, reducir iteraciones:
hyperparameter_tuning:
  param:
    BO:
      iterations: 100  # ← Reducir a 50 o 30 para pruebas rápidas
```

**Nota:** Esto reducirá la calidad del modelo. Para el entregable final, volver a 100.

### P: "Error: column 'X' does not exist"

**Causa:** Una variable que existía en 01_FE se perdió en 02_TS.

**Solución:**
```r
# Revisar si la variable contiene "hf3" en el nombre
# 02_TS elimina TODAS las variables con "hf3" excepto clase

# Si su variable tiene "hf3" en el nombre, renombrarla en 01_FE:
dataset[, mi_var_hf3_relacionada := ...]  # ← Cambiar el nombre para no incluir "hf3"
```

### P: "Warning: feature XXX has zero variance"

**Causa:** Una variable es constante (todos los valores iguales).

**Solución:**
```r
# Identificar la variable
var_constante <- "nombre_variable"

# Verificar
dataset[, uniqueN(get(var_constante))]  # Si es 1, es constante

# Eliminarla si no aporta:
dataset[, (var_constante) := NULL]

# O revisar por qué se volvió constante
# (ej: dummy que siempre es 0 o 1)
```

---

## ⚡ Problemas de Performance

### P: El script consume MUCHA RAM (>8 GB)

**Causa:** Dataset muy grande o muchas variables creadas.

**Solución:**
```r
# 1. Liberar memoria frecuentemente
gc()  # Llamar al garbage collector

# 2. En 01_FE, después de crear variables:
dataset[, variables_innecesarias := NULL]
gc()

# 3. Reducir número de threads en 03_HT
# (Esto está en el código, pero se puede ajustar)
setDTthreads(percent = 50)  # En lugar de 65%
```

### P: data.table operaciones muy lentas

**Causa:** Índices no optimizados o operaciones ineficientes.

**Solución:**
```r
# Usar setkey para operaciones frecuentes
setkey(dataset, "Country Code", year)

# Evitar loops, usar operaciones vectorizadas
# ❌ Lento:
for(i in 1:nrow(dataset)) {
  dataset[i, nueva_var := operacion]
}

# ✅ Rápido:
dataset[, nueva_var := operacion_vectorizada]
```

---

## 📂 Problemas con Paths y Directorios

### P: "Error: cannot open the connection"

**Causa:** Path incorrecto o archivo no existe.

**Solución:**
```r
# Verificar directorio actual
getwd()

# Verificar que el archivo existe
file.exists("ruta/al/archivo.csv")

# Listar archivos en directorio
list.files("dataset/")

# Si el path tiene espacios o caracteres especiales:
# Usar comillas y barras /
base_dir <- "C:/Users/Juan Pérez/Documentos/proyecto"  # ❌ Espacios
base_dir <- "C:/Users/JuanPerez/Documentos/proyecto"   # ✅ Sin espacios
```

### P: "Error: cannot change working directory"

**Causa:** El directorio especificado no existe.

**Solución:**
```r
# Verificar que existe
dir.exists("C:/ruta/proyecto")  # Debe ser TRUE

# Si no, crear:
dir.create("C:/ruta/proyecto", recursive = TRUE)

# O ajustar la ruta en 0_HEALTH_YML.yml
```

### P: Los resultados se guardan en un lugar inesperado

**Causa:** El working directory cambió durante la ejecución.

**Solución:**
```r
# Al inicio de cada script, establecer base_dir:
setwd(PARAMS$environment$base_dir)

# O usar rutas absolutas en lugar de relativas
```

---

## 🔄 Otros Problemas Comunes

### P: "Error: object 'PARAMS' not found"

**Causa:** El YAML no se cargó.

**Solución:**
```r
library(yaml)
PARAMS <- yaml.load_file("codigo_base/0_HEALTH_YML.yml")
```

### P: Los valores de `???` en YML causan error

**Causa:** No reemplazaron los `???` con valores reales.

**Solución:**
Editar `0_HEALTH_YML.yml` y reemplazar TODOS los `???`:
```yaml
presente: 2021      # ← NO debe quedar ???
orden_lead: 1       # ← NO debe quedar ???
excluir: []         # ← NO debe quedar ???
```

### P: "Error: column names must be unique"

**Causa:** Crearon dos variables con el mismo nombre.

**Solución:**
```r
# Verificar duplicados
colnames(dataset)[duplicated(colnames(dataset))]

# Renombrar una de las variables duplicadas
```

### P: El modelo da exactamente el mismo RMSE en diferentes configuraciones

**Causa:** Posible problema con semilla o configuración no se está aplicando.

**Solución:**
```r
# Verificar que el YAML se lee correctamente
PARAMS$feature_engineering$const$presente
PARAMS$feature_engineering$const$orden_lead

# Verificar que los archivos de exp/ se están regenerando
# Eliminar carpeta exp/ y volver a ejecutar
```

### P: "Error: could not find function 'lgb.train'"

**Causa:** LightGBM no cargado o mal instalado.

**Solución:**
```r
# Verificar instalación
library(lightgbm)

# Si falla, reinstalar
remove.packages("lightgbm")
install.packages("lightgbm", dependencies = TRUE)
```

### P: Encoding problems (caracteres raros en texto)

**Causa:** Problema de encoding del archivo CSV.

**Solución:**
```r
# Especificar encoding al leer
dataset <- fread("archivo.csv", encoding = "UTF-8")

# O probar con:
dataset <- fread("archivo.csv", encoding = "Latin-1")
```

---

## 🆘 Si Nada Funciona

### Estrategia de Debug Sistemática

1. **Aislar el problema:**
   ```r
   # Ejecutar scripts uno por uno (NO desde 0_HEALTH_EXE.R)
   source("codigo_base/01_FE_health_ALUMNO.R")  # ¿Falla aquí?
   source("codigo_base/02_TS_health.R")         # ¿O aquí?
   ```

2. **Verificar inputs:**
   ```r
   # En cada etapa, verificar que el dataset tiene sentido
   dim(dataset)           # Dimensiones
   summary(dataset)       # Resumen
   colnames(dataset)      # Variables
   dataset[1:5]          # Primeras filas
   ```

3. **Buscar el error específico en logs:**
   ```r
   # Los errores suelen tener línea y archivo
   # Ir directamente a esa línea y revisar
   ```

4. **Simplificar:**
   ```r
   # Comentar temporalmente su código en AgregarVariables()
   # Dejar la función vacía
   # ¿El pipeline funciona sin sus variables? 
   # → El problema está en sus variables
   # ¿Sigue fallando?
   # → El problema está en configuración o datos
   ```

### Pedir Ayuda

**Si siguen teniendo problemas, al pedir ayuda incluir:**

1. ✅ Sistema operativo (Windows/Mac/Linux) y versión
2. ✅ Versión de R (`version` en consola)
3. ✅ Mensaje de error COMPLETO (copiar y pegar TODO)
4. ✅ Qué paso estaban ejecutando
5. ✅ Qué ya intentaron para solucionar
6. ✅ Configuración de YML relevante (presente, orden_lead, excluir)

**Ejemplo de buen reporte:**
```
Sistema: Windows 11
R: 4.3.2
Error al ejecutar 03_HT_health.R:
"Error in lgb.train: label should not contain Inf or NaN"

Configuración YML:
presente: 2021
orden_lead: 1
excluir: []

Ya intenté:
- Verificar que clase no tiene NAs: sum(is.na(dataset$clase)) = 0
- Verificar que clase no tiene Inf: sum(is.infinite(dataset$clase)) = 0

El error persiste. ¿Alguna idea?
```

---

## 📞 Recursos Adicionales

### Documentación de Librerías

- **data.table:** https://rdatatable.gitlab.io/data.table/
- **LightGBM:** https://lightgbm.readthedocs.io/
- **mlrMBO:** https://mlr-org.com/

### Comunidad R

- Stack Overflow (tag: r, data.table, lightgbm)
- R-help mailing list
- RStudio Community

---

## ✅ Checklist de Troubleshooting

Antes de pedir ayuda, verificar que:

- [ ] Todas las librerías están instaladas correctamente
- [ ] El path en `base_dir` (YML) es correcto
- [ ] Reemplacé TODOS los `???` en el YML
- [ ] El dataset existe en `dataset/dataset_desafio.csv`
- [ ] No hay infinitos ni NaNs sin manejar en mis variables
- [ ] La configuración de presente/orden_lead/excluir es válida
- [ ] Probé ejecutar los scripts uno por uno para identificar dónde falla
- [ ] Leí el mensaje de error completo y busqué en esta guía

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0
