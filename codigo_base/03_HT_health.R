################################################################################
# HYPERPARAMETER TUNING - Optimización Bayesiana con LightGBM
################################################################################
#
# Este script realiza la optimización de hiperparámetros usando Bayesian
# Optimization para encontrar la mejor configuración de LightGBM.
#
# Proceso:
#   1. Carga datos de train/validate/test desde 02_TS
#   2. Define espacio de búsqueda de hiperparámetros (desde YML)
#   3. Ejecuta optimización bayesiana (mlrMBO)
#   4. Entrena modelo final con mejores hiperparámetros
#   5. Genera predicciones para datos de 2022 (present)
#
# IMPORTANTE:
#   - Este proceso puede tomar 30-60 minutos (depende del hardware)
#   - La optimización prueba múltiples combinaciones de hiperparámetros
#   - Los resultados se van guardando incrementalmente en BO_log.txt
#   - Si se interrumpe, puede continuar desde donde quedó (BO_bin.Rdata)
#
################################################################################

require("data.table")
require("primes")
require("lightgbm")

# Paquetes necesarios para la Bayesian Optimization
require("DiceKriging")
require("mlrMBO")
require("rlist")

# Configurar threads de data.table (usar 65% de CPUs disponibles)
setDTthreads(percent = 65)

################################################################################
# FUNCIONES AUXILIARES
################################################################################

#------------------------------------------------------------------------------
# loguear: Graba a un archivo los componentes de una lista
# Para el primer registro, escribe los títulos de las columnas
#------------------------------------------------------------------------------

loguear <- function(reg, arch = NA, folder = "./exp/", ext = ".txt", verbose = TRUE) {
  archivo <- arch
  if (is.na(arch)) archivo <- paste0(folder, substitute(reg), ext)

  # Si el archivo no existe, escribo los títulos de las columnas
  if (!file.exists(archivo)) {
    linea <- paste0(
      "fecha\t",
      paste(list.names(reg), collapse = "\t"), "\n"
    )
    cat(linea, file = archivo)
  }

  # Escribo la línea de datos
  linea <- paste0(
    format(Sys.time(), "%Y%m%d %H%M%S"), "\t", # Fecha y hora
    gsub(", ", "\t", toString(reg)), "\n"
  )

  cat(linea, file = archivo, append = TRUE) # Grabo al archivo

  if (verbose) cat(linea) # Imprimo por pantalla
}

#------------------------------------------------------------------------------
# parametrizar: Separa parámetros fijos de parámetros a optimizar
# Los parámetros con un solo valor son fijos
# Los parámetros con dos valores [desde, hasta] son para optimizar
#------------------------------------------------------------------------------

parametrizar <- function(lparam) {
  param_fijos <- copy(lparam)
  hs <- list()

  for (param in names(lparam)) {
    if (length(lparam[[param]]) > 1) {
      desde <- as.numeric(lparam[[param]][[1]])
      hasta <- as.numeric(lparam[[param]][[2]])

      if (length(lparam[[param]]) == 2) {
        # Parámetro numérico continuo
        hs <- append(
          hs,
          list(makeNumericParam(param, lower = desde, upper = hasta))
        )
      } else {
        # Parámetro entero
        hs <- append(
          hs,
          list(makeIntegerParam(param, lower = desde, upper = hasta))
        )
      }

      param_fijos[[param]] <- NULL # Lo quito de los fijos
    }
  }

  return(list(
    "param_fijos" = param_fijos,
    "paramSet" = hs
  ))
}

#------------------------------------------------------------------------------
# particionar: Divide un dataset en forma estratificada
#------------------------------------------------------------------------------

particionar <- function(data, division, agrupa = "", campo = "fold", start = 1, seed = NA) {
  if (!is.na(seed)) set.seed(seed)

  bloque <- unlist(mapply(function(x, y) {
    rep(y, x)
  }, division, seq(from = start, length.out = length(division))))

  data[, (campo) := sample(rep(bloque, ceiling(.N / length(bloque))))[1:.N],
    by = agrupa
  ]
}

#------------------------------------------------------------------------------
# EstimarGanancia_lightgbm: Función objetivo para la optimización bayesiana
# Entrena un modelo con los hiperparámetros dados y retorna la métrica
#------------------------------------------------------------------------------

EstimarGanancia_lightgbm <- function(x) {
  gc()
  GLOBAL_iteracion <<- GLOBAL_iteracion + 1

  # Combino parámetros fijos con los que estoy probando
  param_completo <- c(param_fijos, x)

  # Configuración de early stopping
  param_completo$num_iterations <- ifelse(param_fijos$boosting == "dart", 999, 99999)
  param_completo$early_stopping_rounds <- as.integer(200 + 4 / param_completo$learning_rate)

  # Entreno el modelo
  set.seed(param_completo$seed)
  modelo_train <- lgb.train(
    data = dtrain,
    valids = list(valid = dvalidate),
    param = param_completo,
    verbose = -100
  )

  # Aplico el modelo a testing y calculo la métrica
  prediccion <- predict(
    modelo_train,
    data.matrix(dataset_test[, campos_buenos, with = FALSE])
  )

  tbl <- dataset_test[, c(PARAMS$hyperparameter_tuning$const$campo_clase), with = F]
  tbl[, pred := prediccion]

  gc()

  # Para health economics: usar la métrica configurada (RMSE por defecto)
  parametro <- unlist(modelo_train$record_evals$valid[[PARAMS$hyperparameter_tuning$param$lightgbm$metric]]$eval)[modelo_train$best_iter]

  ganancia_test_normalizada <- parametro

  rm(tbl)
  gc()

  # Guardo importancia de variables si es la mejor iteración hasta ahora
  if (ganancia_test_normalizada < GLOBAL_ganancia) {
    GLOBAL_ganancia <<- ganancia_test_normalizada
    tb_importancia <- as.data.table(lgb.importance(modelo_train))

    fwrite(tb_importancia,
      file = paste0(PARAMS$hyperparameter_tuning$files$output$importancia, GLOBAL_iteracion, ".txt"),
      sep = "\t"
    )
  }

  # Logueo los resultados de esta iteración
  ds <- list("cols" = ncol(dtrain), "rows" = nrow(dtrain))
  xx <- c(ds, copy(param_completo))

  xx$early_stopping_rounds <- NULL
  xx$num_iterations <- modelo_train$best_iter
  xx$ganancia <- ganancia_test_normalizada
  xx$iteracion_bayesiana <- GLOBAL_iteracion

  loguear(xx, arch = PARAMS$hyperparameter_tuning$files$output$BOlog)

  return(ganancia_test_normalizada)
}

################################################################################
# INICIO DEL PROGRAMA PRINCIPAL
################################################################################

cat("\n")
cat("================================================================================\n")
cat("  HYPERPARAMETER TUNING - HEALTH ECONOMICS\n")
cat("================================================================================\n")
cat("\n")

set.seed(PARAMS$hyperparameter_tuning$param$semilla)

# Navegar al directorio de datos
setwd(paste0(carpeta_base, "/exp"))
setwd(experiment_dir)
setwd(experiment_lead_dir)
setwd("02_TS")

################################################################################
# CARGAR DATASET CON TRAINING STRATEGY
################################################################################

cat("Cargando dataset desde:", PARAMS$hyperparameter_tuning$files$input$dentrada, "\n")
nom_arch <- PARAMS$hyperparameter_tuning$files$input$dentrada
dataset <- fread(nom_arch)

cat("Dataset cargado:", nrow(dataset), "filas x", ncol(dataset), "columnas\n")
cat("\n")

# Crear carpeta de salida
setwd(paste0(carpeta_base, "/exp"))
setwd(experiment_dir)
setwd(experiment_lead_dir)
dir.create("03_HT", showWarnings = FALSE)
setwd("03_HT")

################################################################################
# PREPARAR DATOS PARA LIGHTGBM
################################################################################

cat("================================================================================\n")
cat("  PREPARANDO DATOS\n")
cat("================================================================================\n")
cat("\n")

# Campos que se pueden usar para predicción (excluyendo clase y particiones)
campos_buenos <- setdiff(
  copy(colnames(dataset)),
  c(
    PARAMS$hyperparameter_tuning$const$campo_clase,
    "part_train", "part_validate", "part_test"
  )
)

cat("Variables disponibles para el modelo:", length(campos_buenos), "\n")
cat("\n")

# Crear dataset de TRAIN para LightGBM
cat("Creando dataset de TRAIN...\n")
dtrain <- lgb.Dataset(
  data = data.matrix(dataset[part_train == 1, campos_buenos, with = FALSE]),
  label = dataset[part_train == 1][[PARAMS$hyperparameter_tuning$const$campo_clase]],
  free_raw_data = FALSE
)

cat("  - Train:", dataset[part_train == 1, .N], "registros\n")

# Crear datasets de VALIDATE y TEST
if (PARAMS$hyperparameter_tuning$param$crossvalidation == FALSE) {
  if (PARAMS$hyperparameter_tuning$param$validate == TRUE) {
    # Usar validate explícito
    cat("Creando dataset de VALIDATE...\n")
    dvalidate <- lgb.Dataset(
      data = data.matrix(dataset[part_validate == 1, campos_buenos, with = FALSE]),
      label = dataset[part_validate == 1][[PARAMS$hyperparameter_tuning$const$campo_clase]],
      free_raw_data = FALSE
    )

    cat("  - Validate:", dataset[part_validate == 1, .N], "registros\n")

    dataset_test <- dataset[part_test == 1]
    test_multiplicador <- 1

    cat("  - Test:", dataset[part_test == 1, .N], "registros\n")
  } else {
    # Dividir test en dos mitades: una para validate, otra para test
    cat("Dividiendo TEST en validate y test...\n")
    particionar(dataset,
      division = c(1, 1),
      agrupa = c("part_test", PARAMS$hyperparameter_tuning$const$campo_periodo),
      seed = PARAMS$hyperparameter_tuning$param$semilla,
      campo = "fold_test"
    )

    # fold_test==1 para validation
    dvalidate <- lgb.Dataset(
      data = data.matrix(dataset[part_test == 1 & fold_test == 1, campos_buenos, with = FALSE]),
      label = dataset[part_test == 1 & fold_test == 1, PARAMS$hyperparameter_tuning$const$campo_clase],
      free_raw_data = FALSE
    )

    cat("  - Validate (50% de test):", dataset[part_test == 1 & fold_test == 1, .N], "registros\n")

    dataset_test <- dataset[part_test == 1 & fold_test == 2, ]
    test_multiplicador <- 2

    cat("  - Test (50% de test):", dataset[part_test == 1 & fold_test == 2, .N], "registros\n")
  }
}

cat("\n")

# Liberar memoria
rm(dataset)
gc()

################################################################################
# PREPARAR OPTIMIZACIÓN BAYESIANA
################################################################################

cat("================================================================================\n")
cat("  CONFIGURANDO OPTIMIZACIÓN BAYESIANA\n")
cat("================================================================================\n")
cat("\n")

# Separar hiperparámetros fijos de los que se van a optimizar
hiperparametros <- PARAMS$hyperparameter_tuning$param[[PARAMS$hyperparameter_tuning$param$algoritmo]]
apertura <- parametrizar(hiperparametros)

param_fijos <- apertura$param_fijos

cat("Hiperparámetros FIJOS:\n")
print(param_fijos)
cat("\n")

cat("Hiperparámetros a OPTIMIZAR:\n")
for (p in apertura$paramSet) {
  cat("  -", p$id, ": [", p$lower, ",", p$upper, "]\n")
}
cat("\n")

cat("Iteraciones de optimización bayesiana:", PARAMS$hyperparameter_tuning$param$BO$iterations, "\n")
cat("Métrica a optimizar:", PARAMS$hyperparameter_tuning$param$lightgbm$metric, "(menor es mejor)\n")
cat("\n")

# Variables globales para la optimización
GLOBAL_iteracion <- 0
GLOBAL_ganancia <- Inf

################################################################################
# EJECUTAR OPTIMIZACIÓN BAYESIANA
################################################################################

cat("================================================================================\n")
cat("  INICIANDO OPTIMIZACIÓN BAYESIANA\n")
cat("================================================================================\n")
cat("\n")
cat("ADVERTENCIA: Este proceso puede tomar 30-60 minutos.\n")
cat("Los resultados se van guardando en:", PARAMS$hyperparameter_tuning$files$output$BOlog, "\n")
cat("Puedes interrumpir y continuar después desde:", PARAMS$hyperparameter_tuning$files$output$BObin, "\n")
cat("\n")

# Definir función objetivo para mlrMBO
obj.fun <- makeSingleObjectiveFunction(
  fn = EstimarGanancia_lightgbm,
  minimize = TRUE, # Minimizar RMSE
  noisy = TRUE,
  par.set = makeParamSet(params = apertura$paramSet),
  has.simple.signature = PARAMS$hyperparameter_tuning$param$BO$has.simple.signature
)

# Configurar control de la optimización
ctrl <- makeMBOControl(
  save.on.disk.at.time = PARAMS$hyperparameter_tuning$param$BO$save.on.disk.at.time,
  save.file.path = PARAMS$hyperparameter_tuning$files$output$BObin
)

ctrl <- setMBOControlTermination(ctrl,
  iters = PARAMS$hyperparameter_tuning$param$BO$iterations
)

ctrl <- setMBOControlInfill(ctrl, crit = makeMBOInfillCritEI())

# Configurar modelo surrogate (Kriging)
surr.km <- makeLearner("regr.km",
  predict.type = "se",
  covtype = "matern3_2",
  control = list(trace = TRUE)
)

# EJECUTAR OPTIMIZACIÓN
if (!file.exists(PARAMS$hyperparameter_tuning$files$output$BObin)) {
  # Iniciar optimización desde cero
  cat("Iniciando optimización desde cero...\n")
  run <- mbo(obj.fun, learner = surr.km, control = ctrl)
} else {
  # Continuar optimización desde archivo guardado
  cat("Continuando optimización desde archivo existente...\n")
  run <- mboContinue(PARAMS$hyperparameter_tuning$files$output$BObin)
}

cat("\n")
cat(">>> Optimización bayesiana completada!\n")
cat("\n")

################################################################################
# ENTRENAR MODELO FINAL CON MEJORES HIPERPARÁMETROS
################################################################################

cat("================================================================================\n")
cat("  ENTRENANDO MODELO FINAL\n")
cat("================================================================================\n")
cat("\n")

# Cargar los mejores parámetros del log
if (file.exists(PARAMS$hyperparameter_tuning$files$output$BOlog)) {
  tabla_log <- fread(PARAMS$hyperparameter_tuning$files$output$BOlog)
  mejor_iteracion <- tabla_log[which.min(ganancia)]

  cat("Mejor iteración encontrada:", mejor_iteracion$iteracion_bayesiana, "\n")
  cat("RMSE del mejor modelo:", mejor_iteracion$ganancia, "\n")
  cat("\n")

  # Construir parámetros del mejor modelo
  mejores_params <- param_fijos
  for (col in names(apertura$paramSet)) {
    if (col %in% names(mejor_iteracion)) {
      mejores_params[[col]] <- mejor_iteracion[[col]]
    }
  }

  mejores_params$num_iterations <- mejor_iteracion$num_iterations
  mejores_params$early_stopping_rounds <- NULL # No usar early stopping en modelo final

  cat("Entrenando modelo final con train_final (train + validate + test)...\n")

  # Cargar datos de train_final
  dataset_final <- fread(paste0("../02_TS/", PARAMS$training_strategy$files$output$train_final))

  campos_buenos_final <- setdiff(
    copy(colnames(dataset_final)),
    c(PARAMS$hyperparameter_tuning$const$campo_clase)
  )

  dtrain_final <- lgb.Dataset(
    data = data.matrix(dataset_final[, campos_buenos_final, with = FALSE]),
    label = dataset_final[[PARAMS$hyperparameter_tuning$const$campo_clase]],
    free_raw_data = FALSE
  )

  # Entrenar modelo final
  set.seed(mejores_params$seed)
  modelo_final <- lgb.train(
    data = dtrain_final,
    param = mejores_params,
    verbose = 100
  )

  # Guardar modelo final
  saveRDS(modelo_final, file = "modelo_final_lgb.rds")
  cat("\n✓ Modelo final guardado como: modelo_final_lgb.rds\n")

  # Guardar tabla de importancia final
  tb_importancia_final <- as.data.table(lgb.importance(modelo_final))
  fwrite(tb_importancia_final,
    file = PARAMS$hyperparameter_tuning$files$output$tb_importancia,
    sep = "\t"
  )

  cat("✓ Importancia de variables guardada como:", PARAMS$hyperparameter_tuning$files$output$tb_importancia, "\n")
  cat("\n")

  # Mostrar top 20 variables más importantes
  cat("Top 20 variables más importantes:\n")
  print(head(tb_importancia_final[order(-Gain)], 20))
  cat("\n")

  ################################################################################
  # GENERAR PREDICCIONES PARA 2022
  ################################################################################

  cat("================================================================================\n")
  cat("  GENERANDO PREDICCIONES PARA 2022\n")
  cat("================================================================================\n")
  cat("\n")

  # Verificar si existen datos para predecir (present)
  if (file.exists(paste0("../02_TS/", PARAMS$training_strategy$files$output$present_data))) {
    dataset_present <- fread(paste0("../02_TS/", PARAMS$training_strategy$files$output$present_data))

    if (nrow(dataset_present) > 0) {
      cat("Generando predicciones para", nrow(dataset_present), "registros (año 2022)...\n")

      campos_present <- intersect(campos_buenos_final, names(dataset_present))

      predicciones_present <- predict(
        modelo_final,
        data.matrix(dataset_present[, campos_present, with = FALSE])
      )

      dataset_present[, prediccion_clase := predicciones_present]

      fwrite(dataset_present, file = "predicciones_presente.csv")

      cat("✓ Predicciones guardadas como: predicciones_presente.csv\n")
      cat("\n")
      cat("Resumen de predicciones:\n")
      cat("  - Min:", min(predicciones_present), "\n")
      cat("  - Max:", max(predicciones_present), "\n")
      cat("  - Media:", mean(predicciones_present), "\n")
      cat("  - Mediana:", median(predicciones_present), "\n")
      cat("\n")
    } else {
      cat("⚠️  No hay datos para generar predicciones (dataset_present vacío).\n")
    }
  } else {
    cat("⚠️  No se encontró archivo de datos present para predicción.\n")
  }

  rm(tabla_log)
}

cat("================================================================================\n")
cat("  HYPERPARAMETER TUNING COMPLETADO EXITOSAMENTE\n")
cat("================================================================================\n")
cat("\n")
cat("Archivos generados:\n")
cat("  - modelo_final_lgb.rds: Modelo LightGBM entrenado\n")
cat("  - tb_importancia.txt: Importancia de variables\n")
cat("  - BO_log.txt: Log de optimización bayesiana\n")
cat("  - predicciones_presente.csv: Predicciones para 2022\n")
cat("\n")
cat("Próximos pasos:\n")
cat("  1. Analizar tb_importancia.txt para ver variables más importantes\n")
cat("  2. Interpretar resultados desde perspectiva de economía de la salud\n")
cat("  3. Comparar con diferentes configuraciones de 'presente' y 'orden_lead'\n")
cat("  4. Escribir informe ejecutivo con análisis económico de resultados\n")
cat("\n")
