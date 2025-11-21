# 🧪 Guía de Ejecución de Experimentos

**Desafío de Machine Learning en Economía de la Salud**
**Universidad Nacional del Oeste - 2025**

---

## 🎯 Objetivo de esta Guía

Aprender a:
1. Ejecutar el pipeline completo desde cero
2. Crear y probar diferentes experimentos
3. Comparar resultados entre experimentos
4. Decidir cuál es el mejor modelo
5. Trabajar colaborativamente con tu grupo

---

## 📋 Índice

1. [Flujo de Trabajo General](#flujo-de-trabajo-general)
2. [Primera Ejecución (Baseline)](#primera-ejecución-baseline)
3. [Crear un Nuevo Experimento](#crear-un-nuevo-experimento)
4. [Comparar Experimentos](#comparar-experimentos)
5. [Mejores Prácticas](#mejores-prácticas)
6. [Trabajo en Grupo](#trabajo-en-grupo)

---

## Flujo de Trabajo General

```
┌─────────────────────────────────────────────────────────────┐
│  1. DISEÑAR EXPERIMENTO                                     │
│     - Decidir estrategia COVID (presente, orden_lead)       │
│     - Diseñar variables a crear (Feature Engineering)       │
│     - Elegir nombre descriptivo                             │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  2. MODIFICAR CÓDIGO                                        │
│     - Editar CONFIG_basico.yml                              │
│     - Editar 01_FE_health.R (AgregarVariables)              │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  3. EJECUTAR PIPELINE                                       │
│     - Correr 0_HEALTH_EXE.R                                 │
│     - Esperar 30-60 minutos                                 │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  4. ANALIZAR RESULTADOS                                     │
│     - Revisar RMSE en exp/NOMBRE/03_HT/BO_log.txt           │
│     - Revisar importancia en tb_importancia.txt             │
│     - Revisar predicciones en predicciones_presente.csv     │
└────────────────┬────────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────────┐
│  5. DECIDIR PRÓXIMOS PASOS                                  │
│     - ¿Mejoramos? → Probar variante                         │
│     - ¿Empeoramos? → Volver atrás                           │
│     - ¿Listo? → Documentar y entregar                       │
└─────────────────────────────────────────────────────────────┘
```

---

## Primera Ejecución (Baseline)

### Objetivo

Ejecutar el pipeline **SIN MODIFICACIONES** para:
- Verificar que todo funcione
- Establecer un BASELINE (punto de comparación)
- Entender qué genera cada etapa

### Paso 1: Verificar Configuración Inicial

Abrí `codigo_base/CONFIG_basico.yml` y verificá:

```yaml
environment:
  base_dir: "C:/TU/RUTA/health_economics_challenge"  # ← TU RUTA

  experiment:
    experimento: "exp"
    nombre_experimento: "baseline_sin_cambios"  # ← NOMBRE DEL EXPERIMENTO
```

### Paso 2: Verificar Feature Engineering

Abrí `codigo_base/01_FE_health.R` y verificá que la función `AgregarVariables()` esté intacta (solo con el ejemplo de `YearsSinceFirst`).

### Paso 3: Ejecutar Pipeline

1. Abrí RStudio
2. Abrí el archivo: `codigo_base/0_HEALTH_EXE.R`
3. Ejecutá todo el script:
   - **Code → Run Region → Run All** (o Ctrl+Alt+R en Windows)
4. Esperá (30-60 minutos en la primera ejecución)

### Paso 4: Monitorear Ejecución

Observá la consola de RStudio. Deberías ver mensajes como:

```
==============================================
ETAPA 1: FEATURE ENGINEERING
==============================================
Leyendo dataset...
Dataset cargado: XXXX filas
Ejecutando Feature Engineering...
✓ Feature Engineering completado

==============================================
ETAPA 2: TRAINING STRATEGY
==============================================
Particionando datos...
✓ Train: XXXX filas
✓ Validate: XXXX filas
✓ Test: XXXX filas

==============================================
ETAPA 3: HYPERPARAMETER TUNING
==============================================
Iniciando optimización bayesiana...
Iteración 1/100: RMSE = X.XXX
Iteración 2/100: RMSE = X.XXX
...
✓ Mejor RMSE encontrado: X.XXX
```

### Paso 5: Verificar Resultados

Al finalizar, deberías tener esta estructura:

```
exp/
└── baseline_sin_cambios/
    ├── 01_FE/
    │   └── dataset_fe.csv               # Dataset con variables creadas
    ├── 02_TS/
    │   ├── dataset_train.csv            # Datos de entrenamiento
    │   ├── dataset_validate.csv         # Datos de validación
    │   └── dataset_test.csv             # Datos de prueba
    └── 03_HT/
        ├── modelo_final_lgb.rds         # Modelo entrenado
        ├── tb_importancia.txt           # ⭐ IMPORTANCIA DE VARIABLES
        ├── BO_log.txt                   # ⭐ RMSE DEL MEJOR MODELO
        └── predicciones_presente.csv    # ⭐ PREDICCIONES PARA 2022
```

### Paso 6: Anotar RMSE Baseline

Abrí `exp/baseline_sin_cambios/03_HT/BO_log.txt` y buscá la línea:

```
Best parameters found:
...
Best RMSE: 0.XXXXX
```

**Anotá este valor** en una planilla o archivo. Ejemplo:

| Experimento | RMSE | Notas |
|-------------|------|-------|
| baseline_sin_cambios | 0.8542 | Sin modificaciones, solo YearsSinceFirst |

---

## Crear un Nuevo Experimento

### Experimento 1: Probar Estrategia COVID

**Hipótesis:** ¿Usar o no usar datos COVID afecta el modelo?

#### Configuración A: CON COVID (Maximalista)

1. Abrí `CONFIG_basico.yml`
2. Modificá:

```yaml
experiment:
  nombre_experimento: "exp01_con_covid_maximalista"

feature_engineering:
  const:
    orden_lead: 1      # Predecir 1 año adelante
    presente: 2021     # Usar datos hasta 2021 (incluye COVID)

training_strategy:
  param:
    train:
      excluir: []      # NO excluir ningún año
```

3. Guardá el archivo
4. Ejecutá `0_HEALTH_EXE.R`
5. Esperá
6. Anotá el RMSE

#### Configuración B: SIN COVID (Conservadora)

1. Modificá `CONFIG_basico.yml`:

```yaml
experiment:
  nombre_experimento: "exp02_sin_covid_conservador"

feature_engineering:
  const:
    orden_lead: 3      # Predecir 3 años adelante
    presente: 2019     # NO usar datos de 2020-2021

training_strategy:
  param:
    train:
      excluir: []      # No hace falta excluir porque presente=2019
```

2. Ejecutá `0_HEALTH_EXE.R`
3. Anotá el RMSE

#### Comparar

| Experimento | presente | orden_lead | RMSE | ¿Mejor? |
|-------------|----------|------------|------|---------|
| exp01_con_covid_maximalista | 2021 | 1 | 0.8123 | ✓ |
| exp02_sin_covid_conservador | 2019 | 3 | 0.8654 | ✗ |

**Conclusión (ejemplo):** Usar datos COVID mejora la predicción en este caso.

---

### Experimento 2: Crear Variables Nuevas

**Hipótesis:** Agregar variables económicas mejora el modelo.

#### Paso 1: Diseñar Variables

Decidí qué variables crear. Ejemplo:

```r
# Variables de eficiencia en salud
health_efficiency := SP.DYN.LE00.IN / SH.XPD.CHEX.PC.CD

# Ratio gasto salud / PIB
health_gdp_ratio := SH.XPD.CHEX.GD.ZS / NY.GDP.PCAP.PP.CD

# Dummy para crisis 2008
crisis_2008 := ifelse(year %in% 2008:2009, 1, 0)
```

#### Paso 2: Modificar 01_FE_health.R

Abrí `codigo_base/01_FE_health.R` y agregá tus variables dentro de `AgregarVariables()`:

```r
AgregarVariables <- function(dataset) {
  gc()

  # ========================================
  # AQUÍ CREAN SUS VARIABLES
  # ========================================

  # EJEMPLO: Calcular años desde el primer registro válido
  dataset[hf3_ppp_pc > 0, FirstYear := min(year, na.rm = TRUE),
          by = .(region, `Country Code`)]
  dataset[, FirstYear := nafill(FirstYear, type = "locf"),
          by = .(region, `Country Code`)]
  dataset[, FirstYear := nafill(FirstYear, type = "nocb"),
          by = .(region, `Country Code`)]
  dataset[, YearsSinceFirst := year - FirstYear]

  # ========== NUEVAS VARIABLES ==========

  # Variable 1: Eficiencia en salud
  # (Expectativa de vida / Gasto per cápita)
  dataset[, health_efficiency := SP.DYN.LE00.IN / SH.XPD.CHEX.PC.CD]

  # Variable 2: Ratio gasto salud / PIB per cápita
  dataset[, health_gdp_ratio := SH.XPD.CHEX.GD.ZS / NY.GDP.PCAP.PP.CD]

  # Variable 3: Dummy para crisis económica 2008
  dataset[, crisis_2008 := ifelse(year %in% 2008:2009, 1, 0)]

  # ========================================
  # LÓGICA DE SEGURIDAD (NO MODIFICAR)
  # ========================================

  # [Resto del código...]

  return(dataset)
}
```

#### Paso 3: Cambiar Nombre del Experimento

En `CONFIG_basico.yml`:

```yaml
experiment:
  nombre_experimento: "exp03_con_vars_economicas"
```

#### Paso 4: Ejecutar

1. Ejecutá `0_HEALTH_EXE.R`
2. Esperá
3. Anotá el RMSE

#### Paso 5: Analizar Importancia

Abrí `exp/exp03_con_vars_economicas/03_HT/tb_importancia.txt`:

```
Variable                  Gain
1: NY.GDP.PCAP.PP.CD      0.2345
2: health_efficiency      0.1823  ← TU VARIABLE NUEVA!
3: SH.XPD.CHEX.PC.CD      0.1654
4: SP.DYN.LE00.IN         0.1234
5: health_gdp_ratio       0.0987  ← TU VARIABLE NUEVA!
...
```

**Preguntá:**
- ¿Tus variables aparecen en el top 20?
- ¿Mejoraron el RMSE?
- ¿Tienen sentido económico?

---

## Comparar Experimentos

### Tabla de Comparación

Creá una planilla con todos tus experimentos:

| # | Experimento | presente | orden_lead | Variables Nuevas | RMSE | Δ RMSE | Notas |
|---|-------------|----------|------------|------------------|------|--------|-------|
| 0 | baseline_sin_cambios | 2021 | 1 | 1 | 0.8542 | - | Baseline |
| 1 | exp01_con_covid_maximalista | 2021 | 1 | 1 | 0.8123 | **-0.0419** | ✓ Mejora |
| 2 | exp02_sin_covid_conservador | 2019 | 3 | 1 | 0.8654 | +0.0112 | ✗ Peor |
| 3 | exp03_con_vars_economicas | 2021 | 1 | 4 | 0.7956 | **-0.0586** | ✓✓ Mejor! |

### Análisis

**¿Cuál es el mejor?**
- El de **menor RMSE**
- En el ejemplo: `exp03_con_vars_economicas` (RMSE = 0.7956)

**¿Qué aprendimos?**
- Usar datos COVID ayuda
- Agregar variables de eficiencia económica mejora el modelo
- El modelo baseline es débil (solo 1 variable)

---

## Mejores Prácticas

### 1. Nombrar Experimentos Descriptivamente

❌ **Mal:** `exp1`, `prueba`, `test_final_AHORA_SI`

✅ **Bien:**
- `baseline_sin_cambios`
- `exp01_con_covid_maximalista`
- `exp02_sin_covid_conservador`
- `exp03_vars_eficiencia_salud`
- `exp04_vars_tendencias_temporales`

### 2. Cambiar UNA COSA a la Vez

No cambies TODO al mismo tiempo. Si cambias:
- La estrategia COVID
- Las variables
- Los hiperparámetros (aunque estos se optimizan automáticamente)

...no vas a saber QUÉ causó la mejora o el empeoramiento.

**Enfoque incremental:**
1. Baseline
2. Baseline + estrategia COVID
3. Baseline + estrategia COVID + 3 variables nuevas
4. Baseline + estrategia COVID + 3 variables nuevas + 5 variables más

### 3. Documentar SIEMPRE

Creá un archivo `experimentos.md` en tu carpeta y anotá:

```markdown
# Experimentos del Grupo

## exp01_con_covid_maximalista
- **Fecha:** 2025-04-15
- **Autor:** Juan
- **Cambios:** presente=2021, orden_lead=1
- **RMSE:** 0.8123
- **Notas:** Mejoró vs baseline. Variables importantes: GDP per cápita, expectativa de vida.

## exp02_sin_covid_conservador
- **Fecha:** 2025-04-16
- **Autor:** María
- **Cambios:** presente=2019, orden_lead=3
- **RMSE:** 0.8654
- **Notas:** Peor que baseline. Sin COVID el modelo pierde información reciente.
```

### 4. No Borrar Experimentos

Aunque un experimento haya fallado, **NO borres la carpeta en `exp/`**.

**¿Por qué?**
- Podés volver a analizar los resultados después
- Sirve para comparar qué NO funciona
- Evita repetir errores

### 5. Hacer Commit Después de Cada Experimento

Después de cada experimento exitoso:

```bash
git add .
git commit -m "Experimento 03: Agregadas variables de eficiencia económica (RMSE: 0.7956) - Juan"
git push origin main
```

---

## Trabajo en Grupo

### División de Responsabilidades

**Reunión Inicial (30 min):**
1. Decidir estrategia COVID inicial
2. Dividir tipos de variables a crear:
   - **Persona A:** Variables de eficiencia (ratios)
   - **Persona B:** Variables de tendencias temporales
   - **Persona C:** Variables de contexto (dummies, crisis)

### Flujo de Trabajo Colaborativo

```
┌─────────────────────────────────────────────────────────────┐
│  PERSONA A                                                  │
│  1. Crea 3 variables de eficiencia                          │
│  2. Commit: "exp03_vars_eficiencia"                         │
│  3. Push a GitHub                                           │
│  4. Avisa al grupo: "Subí exp03, RMSE: 0.7956"              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  PERSONA B                                                  │
│  1. Pull del repo (trae cambios de A)                       │
│  2. Agrega 3 variables de tendencias                        │
│  3. Commit: "exp04_vars_tendencias"                         │
│  4. Push                                                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  PERSONA C                                                  │
│  1. Pull (trae cambios de A y B)                            │
│  2. Agrega 3 variables de contexto                          │
│  3. Commit: "exp05_vars_contexto"                           │
│  4. Push                                                    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  TODOS JUNTOS                                               │
│  1. Pull (todos tienen las mismas variables)                │
│  2. Analizan qué variables son importantes                  │
│  3. Deciden qué combinar para el modelo final               │
└─────────────────────────────────────────────────────────────┘
```

### Comunicación Clave

**Antes de empezar a trabajar:**
```
Juan: "Voy a trabajar en variables de eficiencia.
       NO toquen 01_FE_health.R por 2 horas."
```

**Al terminar:**
```
Juan: "Listo, subí exp03_vars_eficiencia.
       RMSE: 0.7956 (mejoró!).
       Pueden hacer pull."
```

### Evitar Conflictos

1. **Comunicación:** Avisar cuando vas a modificar archivos
2. **Pull primero:** Siempre hacer Pull ANTES de empezar a trabajar
3. **Commits frecuentes:** Commitear después de cada experimento exitoso
4. **No trabajar en paralelo en 01_FE_health.R:** Solo una persona a la vez

---

## 📊 Estrategia Sugerida

### Semana 1: Exploración

- Día 1-2: Ejecutar baseline, entender el pipeline
- Día 3-4: Probar 3-4 estrategias COVID
- Día 5-7: Crear primeras variables (5-10 variables)

### Semana 2: Optimización

- Día 1-3: Probar más variables (10-15 adicionales)
- Día 4-5: Comparar experimentos, elegir el mejor
- Día 6-7: Documentar decisiones

### Semana 3: Análisis y Entrega

- Día 1-2: Analizar importancia de variables
- Día 3-5: Escribir informe ejecutivo
- Día 6-7: Revisar código, preparar entrega

---

## 🎯 Checklist Final

Antes de entregar, verificá:

- [ ] Ejecutamos al menos 5 experimentos diferentes
- [ ] Probamos con COVID y sin COVID
- [ ] Creamos al menos 10 variables nuevas
- [ ] Documentamos todos los experimentos
- [ ] Identificamos cuál es el mejor modelo (menor RMSE)
- [ ] Analizamos qué variables son más importantes
- [ ] Guardamos las predicciones finales
- [ ] Escribimos el informe justificando nuestras decisiones

---

## 📚 Recursos Relacionados

- [Guía de Instalación](01_guia_instalacion_rapida.md)
- [Guía de Recursos Computacionales](03_guia_recursos_computacionales.md)
- [FAQ Técnico](04_FAQ_tecnico.md)

---

**¡Éxitos con los experimentos!** 🧪🔬

---

**Última actualización:** Noviembre 2025
**Autor:** Francisco Fernández
