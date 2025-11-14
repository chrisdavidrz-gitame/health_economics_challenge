# ⚠️ Guía de Estrategia: El Dilema COVID

**Health Economics ML Challenge - UNO 2025**

Esta guía analiza en profundidad la decisión estratégica más importante del desafío: **¿Usar o no usar datos de los años COVID (2020-2021)?**

---

## 📋 Índice

1. [El Problema del Shock COVID](#el-problema-del-shock-covid)
2. [Parámetros de Decisión](#parámetros-de-decisión)
3. [Configuraciones Típicas](#configuraciones-típicas)
4. [Análisis de Trade-offs](#análisis-de-trade-offs)
5. [Marco de Decisión](#marco-de-decisión)
6. [Ejemplos de Configuración YML](#ejemplos-de-configuración-yml)
7. [Preguntas para Reflexionar](#preguntas-para-reflexionar)
8. [Análisis de Sensibilidad](#análisis-de-sensibilidad)

---

## 🦠 El Problema del Shock COVID

### Contexto

La pandemia de COVID-19 (2020-2021) representó un **shock exógeno sin precedentes** en los sistemas de salud mundial:

**Impactos Documentados:**
- 📈 Aumento dramático del gasto público en salud
- 📉 Caída del PIB en la mayoría de países (-3% a -10%)
- 🏥 Colapso de sistemas de salud (especialmente países de bajos ingresos)
- 💰 Cambios en patrones de gasto de bolsillo:
  - ↓ Reducción en consultas y tratamientos electivos
  - ↑ Aumento en medicamentos y emergencias
  - 🔀 Variabilidad extrema entre países según respuesta gubernamental

### El Dilema para Machine Learning

**Pregunta Central:**  
¿Los datos de 2020-2021 son **informativos** o **ruidosos** para predecir 2022?

**Dos Visiones Contrapuestas:**

#### Visión A: "COVID es señal útil"
- 2022 aún está influenciado por efectos de COVID (long COVID, deuda de procedimientos pospuestos)
- Los datos de 2020-2021 capturan cómo los sistemas de salud responden a shocks
- Descartar COVID = perder información valiosa sobre resiliencia del sistema

#### Visión B: "COVID es ruido"
- COVID fue un evento único, no representativo de condiciones normales
- Las relaciones entre variables en 2020-2021 son distorsionadas y no generalizables
- Usar COVID = entrenar el modelo con patrones que no se repetirán en 2022

**No hay una respuesta correcta única.** La clave es **justificar su decisión con argumentos sólidos**.

---

## ⚙️ Parámetros de Decisión

Tienen **3 parámetros clave** en `0_HEALTH_YML.yml` que determinan su estrategia:

### 1. `presente` (en feature_engineering)

**¿Cuál es el último año CON DATOS que usamos para crear variables?**

```yaml
feature_engineering:
  const:
    presente: ???  # 2018, 2019, 2020, o 2021
```

**Efecto:**
- Define hasta qué año se calculan lags, tendencias, y otras transformaciones
- Determina qué datos están disponibles para el modelo

**Opciones:**
- `2021` → Incluye TODO (2020 y 2021 completos)
- `2020` → Incluye 2020, pero NO 2021
- `2019` → NO incluye ningún dato de COVID
- `2018` → Excluye incluso 2019 (muy conservador)

### 2. `orden_lead` (en feature_engineering)

**¿Cuántos años hacia el futuro predecimos?**

```yaml
feature_engineering:
  const:
    orden_lead: ???  # 1, 2, 3, 4, o más
```

**Efecto:**
- Determina la "distancia temporal" entre los datos y la predicción
- Afecta cuántos años de datos están disponibles para entrenamiento

**Relación con target:**
```
Año a predecir = presente + orden_lead
```

**Ejemplos:**
- `presente=2021, orden_lead=1` → predice 2022
- `presente=2020, orden_lead=2` → predice 2022
- `presente=2019, orden_lead=3` → predice 2022

### 3. `excluir` (en training_strategy)

**¿Qué años queremos ELIMINAR del entrenamiento?**

```yaml
training_strategy:
  param:
    train:
      excluir: ???  # [] o [2020] o [2020, 2021]
```

**Efecto:**
- Permite tener datos hasta cierto año PERO no usarlos para entrenar el modelo
- Es independiente de `presente` y `orden_lead`

**Opciones:**
- `[]` (vacío) → Usar todos los años disponibles
- `[2020, 2021]` → Eliminar ambos años COVID
- `[2020]` → Eliminar solo 2020 (quizás 2021 es más "normal")
- `[2019, 2020, 2021]` → Muy conservador

---

## 🎯 Configuraciones Típicas

### Configuración 1: MAXIMALISTA (Usar TODO)

**Filosofía:** "COVID es parte de la realidad, hay que usarlo"

```yaml
feature_engineering:
  const:
    presente: 2021
    orden_lead: 1

training_strategy:
  param:
    train:
      excluir: []
```

**Características:**
- ✅ Máxima cantidad de datos para entrenar
- ✅ Información más reciente
- ✅ Incluye cómo sistemas responden a shocks
- ❌ Riesgo de overfitting a patrones COVID
- ❌ Relaciones distorsionadas entre variables

**Train hasta:** 2020  
**Predice:** 2022  
**Años COVID usados:** 2020 y 2021

---

### Configuración 2: CONSERVADORA (Descartar COVID)

**Filosofía:** "COVID es ruido, mejor usar datos pre-pandemia"

```yaml
feature_engineering:
  const:
    presente: 2019
    orden_lead: 3

training_strategy:
  param:
    train:
      excluir: []  # No hace falta excluir porque presente=2019
```

**Características:**
- ✅ Datos "estables" sin shocks
- ✅ Relaciones entre variables más predecibles
- ✅ Menor riesgo de aprender patrones no generalizables
- ❌ Menos datos para entrenar
- ❌ Información menos reciente (3 años atrás)
- ❌ No captura cambios estructurales post-COVID

**Train hasta:** 2016  
**Predice:** 2022  
**Años COVID usados:** Ninguno

---

### Configuración 3: INTERMEDIA (Solo 2020, no 2021)

**Filosofía:** "2020 fue shock, 2021 es recuperación → usar 2021"

```yaml
feature_engineering:
  const:
    presente: 2021
    orden_lead: 1

training_strategy:
  param:
    train:
      excluir: [2020]  # Solo excluir 2020, no 2021
```

**Características:**
- ⚖️ Balance entre cantidad de datos y calidad
- ✅ Usa 2021 (año de "normalización")
- ❌ Decisión requiere argumento sofisticado
- ⚠️ Asume que 2021 ≠ 2020 en términos de "calidad" de datos

**Train hasta:** 2019 (excluye 2020)  
**Predice:** 2022  
**Años COVID usados:** Solo 2021 (para features), 2020 excluido de train

---

### Configuración 4: HÍBRIDA (Datos hasta 2021, pero entrenar sin COVID)

**Filosofía:** "Quiero features recientes, pero entrenar con datos pre-COVID"

```yaml
feature_engineering:
  const:
    presente: 2021
    orden_lead: 1

training_strategy:
  param:
    train:
      excluir: [2020, 2021]
```

**Características:**
- ✅ Features con información reciente (lags de 2020, 2021)
- ✅ Entrenamiento solo con datos pre-COVID
- ⚠️ Complejo de justificar: "uso datos COVID para features pero no para entrenar"
- ❌ Puede ser inconsistente (features con COVID, modelo sin COVID)

**Train hasta:** 2019 (excluye 2020 y 2021)  
**Predice:** 2022  
**Años COVID usados:** Para features sí, para entrenamiento no

---

### Configuración 5: PRUDENTE (Muy conservadora)

**Filosofía:** "COVID + incertidumbre 2019 → usar datos solo hasta 2018"

```yaml
feature_engineering:
  const:
    presente: 2018
    orden_lead: 4

training_strategy:
  param:
    train:
      excluir: []
```

**Características:**
- ✅ Solo datos muy estables
- ✅ Sin ningún efecto de COVID ni incertidumbre pre-COVID
- ❌ Muy pocos datos
- ❌ Información MUY antigua (4 años atrás)
- ❌ Puede perder tendencias importantes

**Train hasta:** 2014  
**Predice:** 2022  
**Años COVID usados:** Ninguno

---

## ⚖️ Análisis de Trade-offs

### Trade-off 1: Cantidad vs. Calidad de Datos

| Aspecto | Usar COVID | No usar COVID |
|---------|------------|---------------|
| **Cantidad de datos** | ✅ Más registros | ❌ Menos registros |
| **Calidad de datos** | ❌ Potencialmente ruidosos | ✅ Más estables |
| **Información reciente** | ✅ Hasta 2021 | ❌ Hasta 2019 o antes |
| **Riesgo de overfitting** | ⚠️ Alto | ⚠️ Bajo |
| **Generalización** | ❓ Incierta | ✅ Más robusta |

### Trade-off 2: Predicción 1 año vs. 3 años

| Característica | orden_lead=1 | orden_lead=3 |
|----------------|--------------|--------------|
| **Dificultad** | Más fácil (menos incertidumbre) | Más difícil |
| **Datos de entrenamiento** | Más años disponibles | Menos años disponibles |
| **COVID en entrenamiento** | Muy probable (presente=2021) | Menos probable (presente=2019) |
| **Interpretación** | Relaciones más directas | Relaciones más complejas |

### Trade-off 3: Consistencia Features-Training

**Escenario A: Consistente**
```yaml
presente: 2021
excluir: []
```
✅ Features con COVID, entrenamiento con COVID  
✅ Lógica coherente

**Escenario B: Inconsistente**
```yaml
presente: 2021
excluir: [2020, 2021]
```
⚠️ Features con COVID, entrenamiento sin COVID  
❓ Requiere justificación sofisticada

---

## 🧠 Marco de Decisión

### Paso 1: Análisis del Contexto Económico

**Preguntas a responder:**

1. **¿Cómo afectó COVID al gasto de bolsillo en salud?**
   - ¿Aumentó o disminuyó en promedio?
   - ¿Fue heterogéneo entre países?
   - ¿Cuál fue el mecanismo? (confinamientos, colapso de sistemas, cambio en demanda)

2. **¿Es 2022 un año "post-COVID" o aún "COVID"?**
   - ¿Hay efectos persistentes? (long COVID, deuda de procedimientos)
   - ¿Los sistemas de salud se recuperaron?
   - ¿Las políticas de salud cambiaron estructuralmente?

3. **¿Qué dice la literatura económica?**
   - ¿Hay papers sobre impacto de COVID en OOP?
   - ¿Cuál es el consenso sobre persistencia de efectos?

### Paso 2: Análisis Exploratorio de Datos (EDA)

**Antes de decidir, EXPLORAR:**

```r
library(data.table)
library(ggplot2)

# Cargar datos
dataset <- fread("dataset/dataset_desafio.csv")

# Analizar target por año
summary_by_year <- dataset[!is.na(hf3_ppp_pc), 
                           .(mean_oop = mean(hf3_ppp_pc, na.rm = TRUE),
                             median_oop = median(hf3_ppp_pc, na.rm = TRUE),
                             sd_oop = sd(hf3_ppp_pc, na.rm = TRUE),
                             n = .N),
                           by = year]

print(summary_by_year)

# Gráfico de evolución
ggplot(summary_by_year, aes(x = year, y = mean_oop)) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = 2020, color = "red", linetype = "dashed") +
  labs(title = "Evolución del Gasto de Bolsillo Promedio",
       subtitle = "Línea roja: inicio COVID-19",
       x = "Año", y = "OOP per cápita (PPP)") +
  theme_minimal()

# Comparar pre-COVID vs. COVID
dataset[, periodo := ifelse(year < 2020, "Pre-COVID", "COVID")]
dataset[!is.na(hf3_ppp_pc), .(mean = mean(hf3_ppp_pc),
                               median = median(hf3_ppp_pc),
                               sd = sd(hf3_ppp_pc)),
        by = periodo]
```

**¿Qué buscar?**
- ¿Hay un "salto" visible en 2020?
- ¿La variabilidad (sd) aumentó mucho?
- ¿Se ve una recuperación en 2021?

### Paso 3: Hipótesis y Justificación

**Ejemplo de justificación MAXIMALISTA:**

> "Decidimos usar datos de COVID (presente=2021, orden_lead=1, excluir=[]) por las siguientes razones:
> 
> 1. **Análisis exploratorio:** El gasto de bolsillo en 2020-2021 muestra patrones de recuperación hacia niveles pre-COVID, sugiriendo que las distorsiones fueron temporales.
> 
> 2. **Argumento teórico:** El año 2022 aún está influenciado por efectos rezagados de COVID (deuda de procedimientos pospuestos, long COVID), por lo que los datos 2020-2021 son informativos.
> 
> 3. **Trade-off:** Preferimos maximizar la cantidad de datos de entrenamiento, asumiendo que el modelo puede capturar qué relaciones son "normales" vs "COVID" mediante feature engineering adecuado.
> 
> 4. **Análisis de sensibilidad:** Comparamos RMSE con configuración conservadora (presente=2019) y obtuvimos mejor performance con datos COVID [INCLUIR RESULTADOS].

**Ejemplo de justificación CONSERVADORA:**

> "Decidimos NO usar datos de COVID (presente=2019, orden_lead=3) por las siguientes razones:
> 
> 1. **Análisis exploratorio:** El gasto de bolsillo en 2020 muestra un salto de +30% respecto a tendencia histórica, con alta variabilidad entre países. Esto sugiere que COVID distorsionó las relaciones normales entre variables.
> 
> 2. **Argumento teórico:** COVID fue un shock exógeno único. Las relaciones entre PIB, mortalidad, y gasto de bolsillo durante 2020-2021 no son representativas de condiciones normales, y 2022 marca un retorno a patrones pre-pandemia.
> 
> 3. **Trade-off:** Preferimos estabilidad de relaciones sobre cantidad de datos. Los datos 2000-2019 son suficientes para capturar tendencias estructurales.
> 
> 4. **Análisis de sensibilidad:** Comparamos con configuración maximalista y obtuvimos menor variance en predicciones, aunque similar RMSE promedio [INCLUIR RESULTADOS].

---

## 💻 Ejemplos de Configuración YML

### Ejemplo 1: Maximalista Pura

```yaml
environment:
  base_dir: "C:/tu/ruta/health_economics_challenge"

experiment:
  experiment_label: "hf3_pred"
  experiment_code: "v_maximalista"

feature_engineering:
  const:
    orden_lead: 1      # Predecir 1 año adelante
    presente: 2021     # Usar datos hasta 2021

training_strategy:
  param:
    train:
      excluir: []      # NO excluir ningún año
    validate:
      excluir: []
    test:
      excluir: []
    train_final:
      excluir: []
```

**Resultado:**
- Train: 2000-2020
- Validate: auto (2020)
- Test: auto (2021)
- Predice: 2022

---

### Ejemplo 2: Conservadora Pura

```yaml
environment:
  base_dir: "C:/tu/ruta/health_economics_challenge"

experiment:
  experiment_label: "hf3_pred"
  experiment_code: "v_conservadora"

feature_engineering:
  const:
    orden_lead: 3      # Predecir 3 años adelante
    presente: 2019     # Usar datos hasta 2019

training_strategy:
  param:
    train:
      excluir: []      # No hace falta, presente=2019 ya excluye COVID
    validate:
      excluir: []
    test:
      excluir: []
    train_final:
      excluir: []
```

**Resultado:**
- Train: 2000-2016
- Validate: auto (2017)
- Test: auto (2018)
- Predice: 2022

---

### Ejemplo 3: Híbrida (Solo 2021)

```yaml
environment:
  base_dir: "C:/tu/ruta/health_economics_challenge"

experiment:
  experiment_label: "hf3_pred"
  experiment_code: "v_solo2021"

feature_engineering:
  const:
    orden_lead: 1
    presente: 2021

training_strategy:
  param:
    train:
      excluir: [2020]   # Excluir solo 2020
    validate:
      excluir: [2020]
    test:
      excluir: [2020]
    train_final:
      excluir: [2020]
```

**Resultado:**
- Train: 2000-2019 (salta 2020)
- Validate: auto (2020) → ⚠️ será vacío!
- Test: 2021 (único año COVID usado)
- Predice: 2022

⚠️ **Cuidado:** Esta configuración puede dejar validate vacío. Verificar con análisis de `control.txt` después de ejecutar 02_TS.

---

## 🤔 Preguntas para Reflexionar

### Sobre el Shock COVID

1. ¿COVID cambió permanentemente el comportamiento de gasto en salud, o fue temporal?
2. ¿Los efectos de COVID fueron homogéneos entre países o hubo mucha heterogeneidad?
3. ¿Qué mecanismos económicos explican cambios en OOP durante COVID?
4. ¿Es razonable asumir que 2022 es "post-COVID" o aún hay efectos?

### Sobre Machine Learning

5. ¿El modelo puede "aprender" a diferenciar patrones COVID vs. normales?
6. ¿Más datos SIEMPRE es mejor, o calidad > cantidad?
7. ¿Cómo afecta `orden_lead` a la capacidad predictiva del modelo?
8. ¿Es mejor tener un modelo "robusto" (sin COVID) o "adaptado" (con COVID)?

### Sobre Feature Engineering

9. ¿Pueden crear variables que AYUDEN al modelo a manejar el shock COVID?
   - Ejemplo: `dummy_covid`, `days_since_covid_start`
10. ¿Cómo capturar "resiliencia" del sistema de salud en una variable?

---

## 📊 Análisis de Sensibilidad

### ¿Cómo Comparar Configuraciones?

**Paso 1:** Ejecutar pipeline con configuración A

```yaml
# Configuración A: Maximalista
presente: 2021
orden_lead: 1
excluir: []
```

```r
source("codigo_base/0_HEALTH_EXE.R")
# Anotar RMSE desde exp/.../03_HT/BO_log.txt
```

**Paso 2:** Cambiar configuración en YML a configuración B

```yaml
# Configuración B: Conservadora
presente: 2019
orden_lead: 3
excluir: []
```

```r
source("codigo_base/0_HEALTH_EXE.R")
# Anotar RMSE desde exp/.../03_HT/BO_log.txt
```

**Paso 3:** Comparar resultados

| Configuración | RMSE | Interpretación |
|---------------|------|----------------|
| Maximalista (2021, lead=1) | 0.85 | Mejor performance |
| Conservadora (2019, lead=3) | 0.92 | Peor performance |

**Conclusión ejemplo:**
> "La configuración maximalista obtuvo mejor RMSE (0.85 vs 0.92), sugiriendo que los datos COVID aportan información útil a pesar del ruido potencial. Esto puede deberse a que..."

### Tabla de Comparación Recomendada

| Config | presente | orden_lead | excluir | RMSE Valid | RMSE Test | Tiempo (min) | Interpretación |
|--------|----------|------------|---------|------------|-----------|--------------|----------------|
| Max    | 2021     | 1          | []      | ?          | ?         | ?            | ?              |
| Cons   | 2019     | 3          | []      | ?          | ?         | ?            | ?              |
| Inter  | 2020     | 2          | []      | ?          | ?         | ?            | ?              |

**Incluir en informe final.**

---

## ✅ Checklist de Decisión

Antes de entregar, verificar que pueden responder:

- [ ] ¿Cuál es mi configuración elegida? (presente, orden_lead, excluir)
- [ ] ¿Por qué elegí esta configuración? (mínimo 3 argumentos)
- [ ] ¿Hice análisis exploratorio de datos para justificar?
- [ ] ¿Probé al menos 2 configuraciones diferentes?
- [ ] ¿Documenté los RMSE de cada configuración?
- [ ] ¿Puedo explicar los trade-offs de mi decisión?
- [ ] ¿Conecté mi decisión con teoría de economía de la salud?
- [ ] ¿Consideré la heterogeneidad entre países?

---

## 🎓 Evaluación de Esta Decisión

**Esta decisión vale 15% de la nota final.**

**Se evalúa:**
- ✅ Profundidad del análisis (no solo "elegí X porque sí")
- ✅ Justificación teórica económica
- ✅ Análisis exploratorio de datos
- ✅ Comparación de al menos 2 configuraciones
- ✅ Interpretación de resultados (RMSE, importancia variables)
- ✅ Reconocimiento de limitaciones de la decisión tomada

**NO se evalúa:**
- ❌ Si eligieron "correctamente" (no hay respuesta única correcta)
- ❌ Si su configuración dio el mejor RMSE absoluto

---

## 📚 Recursos Adicionales

**Papers Relevantes (Opcional):**
- WHO Reports on Financial Protection during COVID-19
- World Bank: "Protecting People from the Economic Crisis Caused by COVID-19"
- Papers sobre "catastrophic health expenditure" durante pandemias

**Datos Externos (Opcional):**
- Oxford COVID-19 Government Response Tracker (stringency index)
- WHO COVID-19 cases and deaths by country

---

## 🚀 Próximo Paso

Una vez que hayan decidido su configuración inicial:

**Ir a:** [03_guia_feature_engineering.md](03_guia_feature_engineering.md) para aprender a crear variables económicamente significativas.

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0
