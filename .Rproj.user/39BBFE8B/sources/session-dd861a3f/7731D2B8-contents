################################################################################
# SCRIPT EJECUTOR PRINCIPAL - PIPELINE HEALTH ECONOMICS
################################################################################
# 
# Este script ejecuta el pipeline completo de Machine Learning para predecir
# el gasto de bolsillo en salud (Out-of-Pocket) per cápita en PPP para 2022.
#
# El pipeline consta de 4 etapas:
#   01_FE: Feature Engineering - Creación de variables predictoras
#   02_TS: Training Strategy - Definición de períodos train/validate/test
#   03_HT: Hyperparameter Tuning - Optimización de hiperparámetros con LightGBM
#   04_ZZ: Predicción Final - Generación de predicciones para 2022 (TODO)
#
# IMPORTANTE: Antes de ejecutar este script:
#   1. Completar la función AgregarVariables() en 01_FE_health_ALUMNO.R
#   2. Configurar 'presente' y 'orden_lead' en 0_HEALTH_YML_covid.yml
#   3. Decidir si excluir años COVID (2020, 2021) en training_strategy
#
# Tiempo estimado de ejecución: 30-60 minutos (depende del hardware)
#
################################################################################

# Limpio la memoria
rm(list = ls())  # Remove all objects
gc()             # Garbage collection

# Cargo librerías necesarias
library(data.table)
library(lubridate)
library(yaml)

################################################################################
# CONFIGURACIÓN DE PATHS
################################################################################

# IMPORTANTE: Ajustar esta ruta a la ubicación del proyecto en tu computadora
carpeta_base <- "C:/00_dev/00_playground/04_TEACH/UNO/2025/clases/health_economics_challenge"

# Verificar que la carpeta existe
if (!dir.exists(carpeta_base)) {
  stop("ERROR: La carpeta base no existe. Por favor ajusta 'carpeta_base' a la ubicación correcta del proyecto.")
}

setwd(carpeta_base)

# Objetos que se mantendrán entre scripts
objetos_trans_script <- c("experiment_dir", "experiment_lead_dir", "carpeta_base", "objetos_trans_script")

################################################################################
# CARGAR CONFIGURACIÓN
################################################################################

cat("\n")
cat("================================================================================\n")
cat("  HEALTH ECONOMICS ML CHALLENGE - PIPELINE EJECUTOR\n")
cat("================================================================================\n")
cat("\n")

# Cargar parámetros del archivo YML
PARAMS <- yaml.load_file("./codigo_base/0_HEALTH_YML_covid.yml")

cat("Configuración cargada desde: 0_HEALTH_YML_covid.yml\n")
cat("  - Experimento:", PARAMS$experiment$experiment_label, "\n")
cat("  - Código:", PARAMS$experiment$experiment_code, "\n")
cat("  - Año presente:", PARAMS$feature_engineering$const$presente, "\n")
cat("  - Orden lead:", PARAMS$feature_engineering$const$orden_lead, "\n")
cat("\n")

# Verificar que 'presente' y 'orden_lead' están configurados
if (is.null(PARAMS$feature_engineering$const$presente) || 
    PARAMS$feature_engineering$const$presente == "???") {
  stop("ERROR: Debes configurar 'presente' en 0_HEALTH_YML_covid.yml antes de ejecutar el pipeline.")
}

if (is.null(PARAMS$feature_engineering$const$orden_lead) || 
    PARAMS$feature_engineering$const$orden_lead == "???") {
  stop("ERROR: Debes configurar 'orden_lead' en 0_HEALTH_YML_covid.yml antes de ejecutar el pipeline.")
}

################################################################################
# CREAR ESTRUCTURA DE DIRECTORIOS
################################################################################

# Carpetas de experimento
experiment_dir <- paste(PARAMS$experiment$experiment_label, 
                       PARAMS$experiment$experiment_code, 
                       sep = "_")

experiment_lead_dir <- paste(PARAMS$experiment$experiment_label, 
                            PARAMS$experiment$experiment_code, 
                            paste0("f", PARAMS$feature_engineering$const$orden_lead), 
                            sep = "_")

setwd(carpeta_base)
dir.create("exp", showWarnings = FALSE)
setwd("exp")

dir.create(experiment_dir, showWarnings = FALSE)
setwd(experiment_dir)
dir.create(experiment_lead_dir, showWarnings = FALSE)
setwd(experiment_lead_dir)

cat("Directorio de experimento creado:\n")
cat("  exp/", experiment_dir, "/", experiment_lead_dir, "/\n", sep = "")
cat("\n")

################################################################################
# CALCULAR PERÍODOS TEMPORALES
################################################################################

# Para datos de salud, trabajamos con años en lugar de meses
presente_year <- PARAMS$feature_engineering$const$presente

# Calcular año final para canaritos (variables sintéticas para feature selection)
# canaritos_year_end es el último año que usaremos para entrenar
canaritos_year_end <- presente_year - PARAMS$feature_engineering$const$orden_lead - 1
PARAMS$feature_engineering$const$canaritos_year_end <- canaritos_year_end

# Calcular año de validación para canaritos
canaritos_year_valid <- presente_year - PARAMS$feature_engineering$const$orden_lead
PARAMS$feature_engineering$const$canaritos_year_valid <- canaritos_year_valid

cat("Períodos temporales calculados:\n")
cat("  - Año presente:", presente_year, "\n")
cat("  - Orden lead:", PARAMS$feature_engineering$const$orden_lead, "\n")
cat("  - Canaritos year end:", canaritos_year_end, "\n")
cat("  - Canaritos year valid:", canaritos_year_valid, "\n")
cat("\n")

################################################################################
# PERSISTIR PARÁMETROS
################################################################################

# Guardo los parámetros en formato JSON para que estén disponibles en todas las etapas
jsontest <- jsonlite::toJSON(PARAMS, pretty = TRUE, auto_unbox = TRUE)
write(jsontest, paste0(experiment_lead_dir, ".json"))

cat("Parámetros guardados en:", paste0(experiment_lead_dir, ".json"), "\n")
cat("\n")

################################################################################
# ETAPA 1: FEATURE ENGINEERING
################################################################################

cat("================================================================================\n")
cat("  ETAPA 1/3: FEATURE ENGINEERING\n")
cat("================================================================================\n")
cat("\n")
cat("Ejecutando 01_FE_health_ALUMNO.R...\n")
cat("\n")

setwd(carpeta_base)
setwd("./codigo_base")
source(PARAMS$feature_engineering$files$fe_script)

cat("\n")
cat(">>> Feature Engineering completado exitosamente!\n")
cat("\n")

################################################################################
# ETAPA 2: TRAINING STRATEGY
################################################################################

cat("================================================================================\n")
cat("  ETAPA 2/3: TRAINING STRATEGY\n")
cat("================================================================================\n")
cat("\n")

# Limpio la memoria (mantengo solo objetos necesarios)
rm(list = setdiff(ls(), objetos_trans_script))
gc()

# Recargo parámetros desde el JSON
setwd(carpeta_base)
setwd("exp")
setwd(experiment_dir)
setwd(experiment_lead_dir)

jsonfile <- list.files(pattern = ".json")
PARAMS <- jsonlite::fromJSON(jsonfile)

cat("Ejecutando 02_TS_health.R...\n")
cat("\n")

setwd(carpeta_base)
setwd("./codigo_base")
source(PARAMS$training_strategy$files$ts_script)

cat("\n")
cat(">>> Training Strategy completado exitosamente!\n")
cat("\n")

# Actualizo los parámetros del JSON (por si hubo cambios en TS)
setwd(carpeta_base)
setwd("exp")
setwd(experiment_dir)
setwd(experiment_lead_dir)

jsontest <- jsonlite::toJSON(PARAMS, pretty = TRUE, auto_unbox = TRUE)
write(jsontest, paste0(experiment_lead_dir, ".json"))

################################################################################
# ETAPA 3: HYPERPARAMETER TUNING
################################################################################

cat("================================================================================\n")
cat("  ETAPA 3/3: HYPERPARAMETER TUNING\n")
cat("================================================================================\n")
cat("\n")

# Limpio la memoria (mantengo solo objetos necesarios)
rm(list = setdiff(ls(), objetos_trans_script))
gc()

# Recargo parámetros desde el JSON
setwd(carpeta_base)
setwd("exp")
setwd(experiment_dir)
setwd(experiment_lead_dir)

jsonfile <- list.files(pattern = ".json")
PARAMS <- jsonlite::fromJSON(jsonfile)

cat("Ejecutando 03_HT_health.R...\n")
cat("\n")
cat("ADVERTENCIA: Esta etapa puede tomar 30-60 minutos dependiendo del hardware.\n")
cat("La optimización bayesiana probará múltiples combinaciones de hiperparámetros.\n")
cat("\n")

setwd(carpeta_base)
setwd("./codigo_base")
source(PARAMS$hyperparameter_tuning$files$ht_script)

cat("\n")
cat(">>> Hyperparameter Tuning completado exitosamente!\n")
cat("\n")

################################################################################
# RESUMEN FINAL
################################################################################

cat("================================================================================\n")
cat("  PIPELINE COMPLETADO EXITOSAMENTE!\n")
cat("================================================================================\n")
cat("\n")
cat("Resultados guardados en:\n")
cat("  exp/", experiment_dir, "/", experiment_lead_dir, "/\n", sep = "")
cat("\n")
cat("Archivos generados:\n")
cat("  - 01_FE/: Dataset con feature engineering aplicado\n")
cat("  - 02_TS/: Datos de train/validate/test separados\n")
cat("  - 03_HT/: Modelo final entrenado y análisis de importancia\n")
cat("\n")
cat("Próximos pasos:\n")
cat("  1. Revisar 03_HT/tb_importancia.txt para ver las variables más importantes\n")
cat("  2. Analizar 03_HT/BO_log.txt para ver el proceso de optimización\n")
cat("  3. Usar el modelo en 03_HT/modelo_final_lgb.rds para predicciones\n")
cat("  4. Comparar resultados con diferentes configuraciones de 'presente' y 'orden_lead'\n")
cat("\n")
cat("================================================================================\n")
cat("\n")
