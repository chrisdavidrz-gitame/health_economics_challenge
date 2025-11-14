# 📚 CONTEXTO DE CONTINUIDAD - PROYECTO PEDAGÓGICO HEALTH ECONOMICS ML

**Documento de Referencia Completo para Trabajo con Claude**  
**Fecha de creación:** 11 de Noviembre de 2025  
**Proyecto:** Desafío Pedagógico de Machine Learning en Economía de la Salud  
**Docente:** Francisco Fernández (Fran)  
**Institución:** UNO - Universidad Nacional del Oeste  

---

## 🎯 OBJETIVO GENERAL DEL PROYECTO

Crear un **desafío pedagógico completo** para grupos de 3 alumnos de Machine Learning donde deben:
- **Predecir** el gasto de bolsillo (Out-of-Pocket) per cápita en PPP para 2022 (`hf3_ppp_pc_2022`)
- **Tomar decisiones estratégicas** sobre uso de datos COVID (2020-2021)
- **Desarrollar feature engineering creativo** en economía de la salud
- **Justificar decisiones** con razonamiento económico y técnico

---

## 📁 ESTRUCTURA DE DIRECTORIOS

### **Ubicación Actual de Datos Fuente:**
```
C:\00_dev\00_playground\UDESA\ECONOMIA DE LA SALUD\MBSO1003 - 104520_2025064_1851\TP final\
```

**Contiene:**
- Scripts R originales del pipeline completo (01_FE, 02_TS, 03_HT, 04_ZZ)
- Dataset completo con todas las variables (`data/dataset.csv`)
- YML de configuración original (`pipeline_health/0_HEALTH_YML.yml`)
- Resultados de modelos entrenados en `exp/`

### **Ubicación Nueva para Proyecto Pedagógico:**
```
C:\00_dev\00_playground\04_TEACH\UNO\2025\clases\health_economics_challenge\
```

**Estructura creada:**
```
health_economics_challenge/
├── 00_CONTEXTO_CONTINUIDAD_PROYECTO.md   # Este documento
├── README.md                              # Guía principal del desafío (por crear)
│
├── dataset/
│   ├── dataset_desafio.csv                # Dataset limpio para alumnos (por crear)
│   ├── diccionario_variables.md           # Explicación de cada variable (por crear)
│   └── metadata_paises.csv                # Info de países, regiones, income (por crear)
│
├── codigo_base/
│   ├── 0_HEALTH_YML.yml                   # Template configuración (por crear)
│   ├── 0_HEALTH_EXE.R                     # Script ejecutor (por crear)
│   ├── 01_FE_health_ALUMNO.R              # FE con AgregarVariables() vacía (por crear)
│   ├── 02_TS_health.R                     # Training Strategy completo (por crear)
│   ├── 03_HT_health.R                     # Hyperparameter Tuning completo (por crear)
│   └── 04_ZZ_health.R                     # Predicción final completo (por crear)
│
├── documentacion/
│   ├── 01_guia_instalacion.md             # Setup R, librerías, estructura (por crear)
│   ├── 02_guia_estrategia_covid.md        # Dilema COVID, configuraciones (por crear)
│   ├── 03_guia_feature_engineering.md     # Hints para crear variables (por crear)
│   ├── 04_guia_interpretacion.md          # Cómo analizar importancia (por crear)
│   └── 05_FAQ_tecnico.md                  # Troubleshooting común (por crear)
│
├── evaluacion/
│   ├── rubrica_evaluacion.md              # Criterios detallados (por crear)
│   ├── checklist_entrega.md               # Qué deben entregar (por crear)
│   └── ejemplos_analisis.md               # Ejemplos de buen análisis (por crear)
│
└── soluciones_referencia/                 # Solo para el docente
    ├── datos_docente_2022/
    │   └── dataset_completo_2022.csv      # Con datos reales de 2022 (por crear)
    ├── solucion_maximalista/              # Estrategia con COVID (por crear)
    ├── solucion_conservadora/             # Estrategia sin COVID (por crear)
    └── analisis_comparativo.md            # Comparación de enfoques (por crear)
```

---

## 🔑 DECISIONES CLAVE DEL DISEÑO PEDAGÓGICO

### **1. El Dilema COVID como Elemento Central**

**Problema Planteado:**
- Dataset incluye años 2000-2021 (CON datos COVID 2020-2021)
- Objetivo: predecir año 2022
- **Los alumnos DEBEN decidir:**
  - ¿Uso datos COVID o los descarto?
  - ¿Qué `orden_lead` elijo? (1, 2, 3 o 4 años hacia futuro)

**Trade-offs Pedagógicos:**

| Estrategia | `presente` | `orden_lead` | Train hasta | Predice | Datos COVID |
|------------|-----------|--------------|-------------|---------|-------------|
| **Maximalista** | 2021 | 1 | 2020 | 2022 | ✅ USA 2020-2021 |
| **Conservadora** | 2019 | 3 | 2016 | 2022 | ❌ Descarta 2020-2021 |
| **Intermedia** | 2020 | 2 | 2018 | 2022 | ⚠️ USA 2020, descarta 2021 |
| **Prudente** | 2018 | 4 | 2014 | 2022 | ❌ Descarta 2019-2021 |

**Evaluación:** 15% de la nota por justificación documentada de esta decisión estratégica.

**Configuración YML que controla esto:**
```yaml
feature_engineering:
  const:
    presente: ???  # ← DECISIÓN DEL ALUMNO (2018-2021)
    orden_lead: ???  # ← DECISIÓN DEL ALUMNO (1, 2, 3, 4+)

training_strategy:
  param:
    train:
      excluir: []  # ← DECISIÓN: [2020, 2021] o []
```

---

### **2. Feature Engineering como Desafío Principal**

**Lo que los alumnos RECIBEN (código completo y funcional):**
- ✅ Funciones de lags (1-4 años con deltas)
- ✅ Funciones de tendencias (ventanas móviles 2-4 años: min, max, promedio, ratios)
- ✅ Funciones de ranking por año
- ✅ Dummies para NAs (`_isNA` para variables con missing values)
- ✅ Variable `year_cycle` (ciclo global 1-10 basado en año calendario)
- ✅ Tratamiento de seguridad (infinitos → NA, NaN → 0)

**Lo que los alumnos DEBEN CREAR (función vacía `AgregarVariables()`):**

```r
AgregarVariables <- function(dataset) {
  gc()
  
  # ========================================
  # AQUÍ LOS ALUMNOS CREAN SUS VARIABLES
  # ========================================
  
  # Ejemplos de lo que podrían crear:
  # - Ratios de eficiencia en salud (e.g., expectativa vida / gasto per cápita)
  # - Variables de crisis económicas (dummies 2008-2009, post-crisis)
  # - QALYs aproximados usando datos disponibles
  # - Interacciones entre variables (e.g., PIB × mortalidad)
  # - Transformaciones no lineales (logs, raíces, potencias)
  # - YearsSinceFirst: años desde primer registro positivo de hf3_ppp_pc
  
  # ========================================
  # LÓGICA DE SEGURIDAD (NO MODIFICAR)
  # ========================================
  
  # Paso infinitos a NA
  infinitos <- lapply(names(dataset), function(.name) dataset[, sum(is.infinite(get(.name)))])
  infinitos_qty <- sum(unlist(infinitos))
  if(infinitos_qty > 0) {
    cat("ATENCION: hay", infinitos_qty, "valores infinitos. Seran pasados a NA\n")
    dataset[mapply(is.infinite, dataset)] <<- NA
  }
  
  # Paso NaN (0/0) a 0
  nans <- lapply(names(dataset), function(.name) dataset[, sum(is.nan(get(.name)))])
  nans_qty <- sum(unlist(nans))
  if(nans_qty > 0) {
    cat("ATENCION: hay", nans_qty, "valores NaN. Seran pasados a 0\n")
    dataset[mapply(is.nan, dataset)] <<- 0
  }
  
  ReportarCampos(dataset)
  return(dataset)
}
```

**Criterios de Evaluación del Feature Engineering:** 40% de la nota total
- **Originalidad de variables** (15%): ¿Crearon variables novedosas y bien fundamentadas?
- **Justificación teórica económica** (15%): ¿Conectan con teoría de economía de la salud?
- **Impacto en performance** (10%): ¿Mejoraron el RMSE vs baseline?

---

### **3. Dataset Limpio para Alumnos**

**Características del `dataset_desafio.csv`:**
- **Países:** ~78 países válidos
  - **Excluidos** (12 problemáticos): Portugal, Norway, Panama, United States, Cyprus, Greece, Australia, Italy, Canada, Lithuania, Chile, Montenegro
- **Variables:** ~200 indicadores del World Bank WDI
- **Período:** 2000-2021 (COMPLETO, incluyendo años COVID)
- **Target:** `hf3_ppp_pc` (gasto de bolsillo PPP per cápita)
  - ⚠️ **CRÍTICO:** Target disponible hasta 2021, **falta 2022** (objetivo a predecir)
- **Estructura:** Panel data (`Country Code`, `year`, `region`, `income`, variables...)
- **Limpieza aplicada:**
  - Eliminadas variables con >50% NA en el período 2000-2021
  - NO se incluyen variables con patrón `hf3_*` (salvo el target) para evitar leakage
  - Se mantienen metadatos WHO: `region`, `income` level

**Variables NO Incluidas (prevención de data leakage):**
- Todas las variables `hf3_*` excepto `hf3_ppp_pc` (target)
- Variables de años futuros a 2021
- Variables eliminadas por alto % de NA

**Metadatos incluidos (de WHO):**
- `region`: AFR, AMR, EMR, EUR, SEAR, WPR
- `income`: Low, Lower-middle, Upper-middle, High

---

## 🎓 COMPONENTES DEL DESAFÍO

### **A. Dataset y Materiales Base**
1. **`dataset_desafio.csv`** - Datos limpios 2000-2021, sin `hf3_ppp_pc` para 2022
2. **`diccionario_variables.md`** - Descripción detallada de ~200 variables del World Bank
3. **`metadata_paises.csv`** - Información de países, regiones, income levels

### **B. Código Pipeline (4 etapas + ejecutor + config)**
1. **`01_FE_health_ALUMNO.R`** - Feature Engineering con función `AgregarVariables()` vacía
2. **`02_TS_health.R`** - Training Strategy (configuración automática de períodos train/validate/test)
3. **`03_HT_health.R`** - Hyperparameter Tuning con LightGBM y Optimización Bayesiana
4. **`04_ZZ_health.R`** - Predicción final y generación de outputs
5. **`0_HEALTH_YML.yml`** - Configuración (alumnos modifican `presente` y `orden_lead`)
6. **`0_HEALTH_EXE.R`** - Script ejecutor del pipeline completo

### **C. Documentación Pedagógica**
1. **Guía de Instalación** - Setup del entorno R, librerías necesarias
2. **Guía del Dilema COVID** - Análisis de trade-offs, configuraciones ejemplo
3. **Guía de Feature Engineering** - Hints conceptuales sobre economía de la salud (sin dar soluciones)
4. **Guía de Interpretación** - Cómo analizar importancia de variables, conectar con teoría
5. **FAQ Técnico** - Solución a problemas comunes de ejecución

### **D. Evaluación**
1. **Rúbrica Detallada** - Criterios específicos y puntajes por dimensión
2. **Checklist de Entrega** - Qué archivos y análisis incluir en el informe
3. **Ejemplos de Análisis** - Cómo se ve un buen informe ejecutivo

---

## 📊 ENTREGABLES ESPERADOS DE LOS ALUMNOS

### **1. Código (30% de la nota)**
- `01_FE_health_ALUMNO.R` con función `AgregarVariables()` completa
- Comentarios explicando el razonamiento económico de cada variable creada
- `0_HEALTH_YML.yml` con configuración estratégica elegida (presente, orden_lead, excluir)

### **2. Predicciones (15% de la nota)**
- `predicciones_2022.csv` - Predicciones de `hf3_ppp_pc` para cada país en 2022
- Análisis de incertidumbre (opcional pero valorado: intervalos de confianza)

### **3. Análisis de Importancia (25% de la nota)**
- Top 20 variables más importantes del modelo final (desde `tb_importancia.txt`)
- Interpretación económica: ¿por qué esas variables predicen mejor?
- Comparación con literatura de economía de la salud
- Análisis de variables propias creadas: ¿aparecen en el top? ¿por qué sí/no?

### **4. Informe Ejecutivo (30% de la nota)**

**Estructura esperada:**

```markdown
# Informe: Predicción de Gasto de Bolsillo en Salud 2022
## Grupo: [Nombres]

## 1. Decisión de Estrategia (15% de la nota total)
### 1.1 Configuración Elegida
- `presente`: [valor elegido]
- `orden_lead`: [valor elegido]
- Años excluidos de training: [2020, 2021 o ninguno]

### 1.2 Justificación del Trade-off
[Explicar por qué eligieron usar o no datos de COVID]
[Análisis del trade-off: más datos vs. calidad de datos]
[Consideración del impacto del shock COVID en las relaciones entre variables]

### 1.3 Análisis de Sensibilidad (opcional)
¿Probaron múltiples configuraciones? 
¿Cuál funcionó mejor en validación?

## 2. Feature Engineering (40% de la nota total)
### 2.1 Descripción de Variables Creadas (15%)
[Tabla con cada variable creada, su fórmula, y descripción]

### 2.2 Justificación Teórica Económica (15%)
[Conexión con teoría de economía de la salud]
[Referencias a literatura si corresponde]

### 2.3 Análisis de Impacto en Performance (10%)
[RMSE del modelo con vs. sin sus variables]
[Importancia de sus variables en el modelo final]

## 3. Resultados y Performance (30% de la nota total)
### 3.1 Métricas del Modelo
- RMSE en Validación: [valor]
- RMSE en Test: [valor]
- Comparación con baseline (modelo sin FE avanzado)

### 3.2 Análisis de Importancia de Variables
[Top 20 variables del modelo final]
[Interpretación económica de predictores clave]

### 3.3 Interpretación Económica
¿Qué factores predicen mejor el gasto de bolsillo en salud?
¿Tiene sentido económico?
¿Coincide con la literatura?

## 4. Conclusiones (15% de la nota total)
### 4.1 Insights Principales
[Principales hallazgos sobre predictores de gasto en salud]

### 4.2 Limitaciones del Modelo
[Qué no captura bien el modelo, datos faltantes, supuestos]

### 4.3 Recomendaciones Futuras
[Mejoras para futuras iteraciones]
```

---

## 🔧 HERRAMIENTAS TÉCNICAS

### **Stack Tecnológico:**
- **R 4.x+**
- **Librerías principales:**
  - `data.table` - Manipulación eficiente de datos panel
  - `lightgbm` - Gradient boosting para regression
  - `yaml` - Lectura de configuración
  - `mlrMBO` - Optimización bayesiana de hiperparámetros
  - `ggplot2` - Visualizaciones (opcional para alumnos)
  - `dplyr`, `stringr`, `lubridate` - Utilidades

### **Flujo de Ejecución:**
```r
# 0_HEALTH_EXE.R ejecuta secuencialmente:
source("01_FE_health_ALUMNO.R")    # → hf3_pred_vX_fY.csv.gz
source("02_TS_health.R")            # → TS_train_*.csv.gz, TS_present_data.csv.gz
source("03_HT_health.R")            # → modelo_final_lgb.rds, tb_importancia.txt
source("04_ZZ_health.R")            # → predicciones_2022.csv
```

### **Outputs Generados por Pipeline:**
```
exp/
└── [experiment_label]_[experiment_code]_f[fold]/
    ├── 01_FE/
    │   └── [nombre_experimento].csv.gz      # Dataset post-FE (~500-1000 variables)
    ├── 02_TS/
    │   ├── TS_train_strategy.csv.gz          # Datos de train/validate/test
    │   ├── TS_train_final.csv.gz             # Datos de train_final
    │   ├── TS_present_data.csv.gz            # Datos sin clase (año 2022)
    │   └── control.txt                       # Info de períodos usados
    └── 03_HT/
        ├── modelo_final_lgb.rds              # Modelo LightGBM entrenado
        ├── tb_importancia.txt                # Importancia de variables
        ├── BO_log.txt                        # Log de optimización bayesiana
        ├── BO_bin.Rdata                      # Objeto de optimización
        └── predicciones_presente.csv         # Predicciones para 2022
```

---

## 📈 MÉTRICAS DE ÉXITO DEL PROYECTO

### **Para los Alumnos (Evaluación):**
1. **RMSE en Test Set** - Comparado con modelo baseline sin FE avanzado
2. **Justificación Teórica** - Conexión sólida con economía de la salud
3. **Creatividad en FE** - Originalidad y fundamentación de variables creadas
4. **Profundidad de Análisis** - Interpretación económica de resultados

### **Para el Docente (Objetivos Pedagógicos):**
1. ¿Los alumnos **entienden** el trade-off de usar/no usar datos COVID?
2. ¿Pueden **crear variables económicamente significativas** más allá de transformaciones mecánicas?
3. ¿**Conectan** importancia de variables con teoría económica de la salud?
4. ¿**Interpretan correctamente** resultados de ML en contexto económico?
5. ¿**Justifican decisiones** con razonamiento sólido más que por "trial and error"?

---

## 🎯 PLAN DE TRABAJO - PRÓXIMAS FASES

### **FASE 1: Preparación de Dataset** ✅ EN PROGRESO
1. ✅ Crear estructura de directorios
2. ⏳ Leer dataset original desde carpeta UDESA
3. ⏳ Filtrar países problemáticos (12 países a excluir)
4. ⏳ Eliminar variables con >50% NA en 2000-2021
5. ⏳ Eliminar variables `hf3_*` (salvo target) para evitar leakage
6. ⏳ Guardar `dataset_desafio.csv` limpio en `/dataset/`
7. ⏳ Separar datos de 2022 (si existen) en `/soluciones_referencia/datos_docente_2022/`

### **FASE 2: Adaptación de Código**
1. Copiar scripts R originales desde `pipeline_health/`
2. Modificar `01_FE_health_asis_goodCountries.R`:
   - Vaciar completamente función `AgregarVariables()`
   - Mantener solo lógica de seguridad (infinitos, NaN)
   - Guardar como `01_FE_health_ALUMNO.R`
3. Actualizar `02_TS_health.R`:
   - Agregar lógica de configuración automática según `presente` y `orden_lead`
   - Agregar warnings educativos sobre decisiones estratégicas
4. Copiar `03_HT_health.R` y `04_ZZ_health.R` sin modificaciones
5. Crear `0_HEALTH_YML.yml` template:
   - Comentarios explicativos en español
   - Parámetros clave marcados con `???` para que alumnos completen
   - Ejemplos de configuraciones comentadas
6. Verificar que pipeline funcione end-to-end con `AgregarVariables()` vacía

### **FASE 3: Documentación Pedagógica**
1. Crear `README.md` principal del desafío (overview completo)
2. Escribir `01_guia_instalacion.md`:
   - Instalación de R y RStudio
   - Instalación de librerías necesarias
   - Estructura de archivos y carpetas
   - Cómo ejecutar el pipeline
3. Escribir `02_guia_estrategia_covid.md`:
   - Explicación del dilema COVID
   - Análisis de trade-offs de cada configuración
   - Ejemplos de configuración YML
   - Preguntas guía para reflexión
4. Escribir `03_guia_feature_engineering.md`:
   - Hints conceptuales sobre economía de la salud
   - Ejemplos de tipos de variables (sin dar código)
   - Preguntas guía: ¿qué factores influyen en gasto de bolsillo?
5. Escribir `04_guia_interpretacion.md`:
   - Cómo leer `tb_importancia.txt`
   - Qué significa importancia de variable en LightGBM
   - Cómo conectar importancia con teoría económica
6. Escribir `05_FAQ_tecnico.md`:
   - Errores comunes de ejecución y soluciones
   - Problemas con paths, encoding, memoria
7. Crear `diccionario_variables.md`:
   - Descripción de cada variable del World Bank WDI
   - Unidades, fuente, interpretación

### **FASE 4: Evaluación**
1. Diseñar `rubrica_evaluacion.md`:
   - Criterios específicos para cada dimensión
   - Puntajes detallados (0-10 por criterio)
   - Ejemplos de respuestas 10/10, 7/10, 4/10
2. Crear `checklist_entrega.md`:
   - Lista de archivos requeridos
   - Formato de nombrado
   - Estructura del informe
3. Escribir `ejemplos_analisis.md`:
   - Ejemplo de buen análisis de importancia
   - Ejemplo de buena justificación de estrategia
   - Ejemplo de mala justificación (para contraste)

### **FASE 5: Soluciones de Referencia (Solo Docente)**
1. Crear `solucion_maximalista/`:
   - YML con presente=2021, orden_lead=1
   - `AgregarVariables()` con variables razonables
   - Ejecutar pipeline completo
   - RMSE resultante, importancia de variables
2. Crear `solucion_conservadora/`:
   - YML con presente=2019, orden_lead=3, excluir=[2020,2021]
   - Mismo `AgregarVariables()` que maximalista
   - Ejecutar pipeline completo
   - RMSE resultante, importancia de variables
3. Escribir `analisis_comparativo.md`:
   - Comparación de RMSE entre estrategias
   - Variables importantes en cada caso
   - Análisis de qué estrategia es mejor y por qué
   - Lecciones pedagógicas: qué deben aprender los alumnos

### **FASE 6: Validación Final**
1. Ejecutar pipeline completo con dataset limpio y `AgregarVariables()` vacía
2. Verificar que todos los outputs se generen correctamente
3. Probar configuraciones ejemplo (maximalista, conservadora)
4. Validar que FAQ técnico resuelve errores reales
5. Revisar que documentación sea clara y completa

---

## ⚠️ CONSIDERACIONES IMPORTANTES

### **Datos Sensibles y Separación Alumno/Docente:**
- Los alumnos **NO** tendrán acceso a:
  - Valores reales de `hf3_ppp_pc` para 2022 (hasta que entreguen predicciones)
  - Soluciones de referencia del docente en `/soluciones_referencia/`
  - Variables `hf3_*` adicionales que podrían causar leakage
  
- El docente **guardará por separado** en `/soluciones_referencia/datos_docente_2022/`:
  - Dataset completo incluyendo 2022 (si existe)
  - Scripts para evaluar RMSE de predicciones de alumnos vs. valores reales

### **Configuración YML Crítica:**
```yaml
feature_engineering:
  const:
    origen_clase: "hf3_ppp_pc"              # NO modificar
    clase: "clase"                          # NO modificar
    orden_lead: ???                         # ← DECISIÓN ALUMNO (1, 2, 3, 4+)
    presente: ???                           # ← DECISIÓN ALUMNO (2018-2021)
    canaritos_year_start: 2000              # NO modificar
    
  param:
    variablesmanuales: FALSE                # ← CRÍTICO: desactiva variables pre-hechas
    dummiesNA: TRUE                         # Mantener
    lags: [configuración completa...]       # Mantener
    tendenciaYmuchomas: [config...]         # Mantener
    rankeador: TRUE                         # Mantener
```

### **Validación Pedagógica Antes de Entregar:**
- ✅ Pipeline ejecuta sin errores con `AgregarVariables()` vacía
- ✅ Configuraciones ejemplo (maximalista, conservadora) funcionan
- ✅ FAQ técnico cubre errores comunes reales (no ficticios)
- ✅ Documentación en español, clara y sin jerga innecesaria
- ✅ Rúbrica es objetiva y puede aplicarse consistentemente
- ✅ Datos de 2022 están bien separados de lo que ven alumnos

### **Formato de Trabajo con Alumnos:**
- **Grupos de 3 personas**
- **Idioma:** Español (toda la documentación)
- **Sin límite computacional** estricto (pero advertir que Bayesian Optimization toma tiempo)
- **Plazo recomendado:** 2-3 semanas desde entrega hasta presentación

---

## 📞 PREGUNTAS CLAVE RESUELTAS

1. **¿Incluir modelo base pre-entrenado para comparación?**  
   → **NO.** Los alumnos comparan su RMSE contra el de su propio modelo sin las variables que crearon (pueden comentar `AgregarVariables()` y volver a ejecutar).

2. **¿Grupos o individual?**  
   → **Grupos de 3 personas.**

3. **¿Límite de tiempo de ejecución?**  
   → **No hay límite estricto.** Bayesian Optimization con 100 iteraciones puede tomar 30-60 min dependiendo del hardware.

4. **¿Documentación en inglés o español?**  
   → **Español.** Toda la documentación pedagógica debe estar en español.

5. **¿Incluir datos reales de 2022?**  
   → **Sí, pero BIEN SEPARADOS** en `/soluciones_referencia/datos_docente_2022/` para que el docente pueda evaluar predicciones contra valores reales después de la entrega.

---

## 🚀 ESTADO ACTUAL DEL PROYECTO

**Fecha:** 11 de Noviembre de 2025  
**Fase Actual:** FASE 1 - Preparación de Dataset ✅ EN PROGRESO

**Completado:**
- ✅ Estructura de directorios creada
- ✅ Documento de contexto de continuidad (este archivo)

**Próximo Paso Inmediato:**
1. Leer `dataset.csv` original desde carpeta UDESA
2. Analizar estructura y contenido
3. Identificar y filtrar 12 países problemáticos
4. Eliminar variables con >50% NA
5. Eliminar variables `hf3_*` (excepto target)
6. Guardar `dataset_desafio.csv` limpio

**Uso de Herramientas:**
- ✅ Usar **filesystem MCP** para todas las operaciones de archivos
- ❌ **NO usar bash ni artifacts**
- ✅ Trabajar en el directorio del proyecto: `C:\00_dev\00_playground\04_TEACH\UNO\2025\clases\health_economics_challenge\`

---

## 📝 NOTAS FINALES

Este documento debe ser el **punto de partida** para cualquier sesión de trabajo con Claude sobre este proyecto. Contiene:
- ✅ Contexto completo del proyecto pedagógico
- ✅ Decisiones de diseño fundamentadas
- ✅ Estructura de archivos y carpetas
- ✅ Plan de trabajo detallado en fases
- ✅ Consideraciones técnicas y pedagógicas
- ✅ Estado actual y próximos pasos

**Cuando continúes trabajando en este proyecto:**
1. Lee este archivo primero para recuperar contexto
2. Verifica en qué fase estamos
3. Continúa desde el último paso completado
4. Actualiza este archivo si hay cambios importantes en decisiones o estructura

**Para Fran (el docente):**
- Este archivo está en la raíz del proyecto y puede ser compartido con Claude en futuras sesiones
- Contiene TODO el contexto necesario para que Claude pueda continuar el trabajo de forma autónoma
- Si hay cambios en las decisiones pedagógicas, actualizar la sección correspondiente

---

**¡Listo para continuar con FASE 1!** 🚀
