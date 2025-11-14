# 📊 Guía de Interpretación de Resultados

**Health Economics ML Challenge - UNO 2025**

Esta guía te ayudará a interpretar los resultados del modelo, especialmente la **importancia de variables** y conectarlos con teoría económica.

---

## 📋 Índice

1. [Archivos Clave de Resultados](#archivos-clave-de-resultados)
2. [Cómo Leer tb_importancia.txt](#cómo-leer-tb_importanciatxt)
3. [Qué Significa "Importancia" en LightGBM](#qué-significa-importancia-en-lightgbm)
4. [Interpretación Económica](#interpretación-económica)
5. [Análisis de Predicciones](#análisis-de-predicciones)
6. [Conectar con Teoría](#conectar-con-teoría)
7. [Errores Comunes de Interpretación](#errores-comunes-de-interpretación)

---

## 📁 Archivos Clave de Resultados

Después de ejecutar el pipeline, encontrarás estos archivos en:
```
exp/[experimento]/03_HT/
```

### 1. `tb_importancia.txt` ⭐

**Contenido:** Lista de variables ordenadas por importancia

**Columnas:**
- `Feature`: Nombre de la variable
- `Gain`: Ganancia promedio al usar esa variable en splits (más importante)
- `Cover`: % de observaciones afectadas por esa variable
- `Frequency`: Cuántas veces se usó la variable en el modelo

**Este es el archivo MÁS IMPORTANTE para el informe.**

### 2. `BO_log.txt`

**Contenido:** Log de todas las iteraciones de optimización bayesiana

**Columnas clave:**
- `ganancia`: RMSE de cada iteración (menor = mejor)
- `iteracion_bayesiana`: Número de iteración
- Hiperparámetros probados (learning_rate, num_leaves, etc.)

**Uso:** Identificar el RMSE del mejor modelo.

### 3. `modelo_final_lgb.rds`

**Contenido:** Modelo LightGBM entrenado (serializado)

**Uso:** Cargar el modelo para predicciones adicionales (si necesario).

### 4. `predicciones_presente.csv`

**Contenido:** Predicciones para el año 2022

**Columnas:**
- Todas las variables de entrada
- `prediccion_clase`: Predicción de `hf3_ppp_pc` para 2022

**Este es su entregable principal.**

---

## 📖 Cómo Leer tb_importancia.txt

### Estructura del Archivo

```
Feature                          Gain        Cover      Frequency
NY.GDP.PCAP.PP.CD_lag1          0.15234     0.08123    245
SP.DYN.LE00.IN_lag1             0.12456     0.07234    198
eficiencia_salud                0.08932     0.05123    156
...
```

### ¿Qué Columna Usar?

**Recomendación: Usar `Gain`** (es la métrica más informativa)

**Interpretación de Gain:**
- **Gain alto** → La variable aporta mucho a reducir el error de predicción
- **Gain bajo** → La variable aporta poco (puede ser redundante o ruidosa)

**Cover y Frequency:**
- Son métricas complementarias
- Mencionar si hay diferencias notables (ej: variable con alto Gain pero baja Frequency → es muy importante pero selectiva)

### Ejemplo de Lectura

```
Feature                          Gain
NY.GDP.PCAP.PP.CD_lag1          0.15234
```

**Interpretación:**
> "La variable `NY.GDP.PCAP.PP.CD_lag1` (PIB per cápita del año anterior) es la más importante del modelo, con un Gain de 0.15234. Esto significa que, en promedio, cada vez que el modelo usa esta variable para decidir un split, reduce el error de predicción en ~15% (relativo al Gain total)."

---

## 🤖 Qué Significa "Importancia" en LightGBM

### Cómo Funciona LightGBM (Simplificado)

LightGBM construye **árboles de decisión** secuenciales:

```
                [PIB > 15000?]
               /              \
           SÍ /                \ NO
             /                  \
    [Expectativa > 70?]    [Gasto_salud > 500?]
       /         \              /          \
     ...         ...          ...          ...
```

Cada decisión ("split") en el árbol usa una variable y un umbral.

### Gain: ¿Cuánto Mejora Cada Split?

**Gain** mide **cuánto reduce el error** (RMSE) cada vez que se usa esa variable.

**Fórmula (simplificada):**
```
Gain = Error_antes_del_split - Error_después_del_split
```

**Interpretación:**
- Variable con **alto Gain** → Cuando se usa, mejora mucho la predicción
- Variable con **bajo Gain** → Cuando se usa, apenas mejora

### ⚠️ Importante: No es Causalidad

**Importancia ≠ Causalidad**

Que una variable sea "importante" NO significa que:
- ❌ Cause el aumento de OOP
- ❌ Sea la única relevante
- ❌ Deba ser manipulada como política pública

**Interpretación correcta:**
✅ La variable es **predictiva** del gasto de bolsillo
✅ Captura información útil que el modelo usa
✅ Puede representar correlaciones, no necesariamente causas

---

## 💡 Interpretación Económica

### Paso 1: Identificar Top 20 Variables

```r
library(data.table)

# Cargar importancia
importancia <- fread("exp/[tu_experimento]/03_HT/tb_importancia.txt")

# Top 20 por Gain
top20 <- head(importancia[order(-Gain)], 20)
print(top20)
```

### Paso 2: Clasificar por Categoría

**Ejemplo de clasificación:**

| Variable | Categoría | Interpretación Económica |
|----------|-----------|--------------------------|
| `NY.GDP.PCAP.PP.CD_lag1` | **Capacidad Económica** | PIB per cápita del año anterior predice fuertemente OOP |
| `SP.DYN.LE00.IN_lag1` | **Salud Poblacional** | Expectativa de vida (año anterior) es predictiva |
| `SH.XPD.CHEX.PC.CD_lag2` | **Gasto Salud Total** | Gasto total en salud de hace 2 años importa |
| `eficiencia_salud` | **Variable Propia** | Nuestra variable de eficiencia es informativa |

**Categorías sugeridas:**
- Capacidad económica (PIB, ingreso, crecimiento)
- Salud poblacional (expectativa vida, mortalidad)
- Sistema de salud (gasto, camas, cobertura)
- Demografía (envejecimiento, urbanización)
- Variables propias (sus creaciones)
- Lags/tendencias (transformaciones temporales)

### Paso 3: Interpretar Patrones

**Preguntas a responder:**

#### a) ¿Qué tipo de variables dominan?

**Ejemplo A:**
> "Las top 5 variables son todas económicas (PIB, crecimiento, ingreso). Esto sugiere que la **capacidad económica del país** es el predictor más fuerte del gasto de bolsillo en salud."

**Ejemplo B:**
> "Las top 5 incluyen tanto variables económicas como de salud poblacional. Esto indica que OOP está determinado por una **combinación de riqueza y necesidad de salud**."

#### b) ¿Los lags importan más que las variables actuales?

**Si `PIB_lag1` es más importante que `PIB`:**
> "El PIB del año anterior predice mejor que el PIB actual, sugiriendo que hay **efectos retardados** en cómo los cambios económicos afectan el gasto de bolsillo."

#### c) ¿Las tendencias importan?

**Si `PIB_tendencia_3` aparece en top 20:**
> "La tendencia del PIB (pendiente de los últimos 3 años) es informativa, indicando que no solo el **nivel** sino la **trayectoria** económica importa para predecir OOP."

#### d) ¿Sus variables propias aparecen?

**Si `eficiencia_salud` está en top 20:**
> "Nuestra variable de eficiencia del sistema de salud (expectativa_vida / gasto_salud_pc) resultó ser altamente predictiva (puesto #8), validando la hipótesis de que **la eficiencia en producir salud** está relacionada con los patrones de gasto de bolsillo."

**Si NO aparecen:**
> "Nuestras variables propias no aparecen en el top 50, sugiriendo que (1) son redundantes con variables automáticas, (2) no capturan información nueva, o (3) tienen demasiado ruido. Esto indica que [reflexión sobre qué se puede mejorar]."

---

## 🔍 Análisis de Predicciones

### Cargar Predicciones

```r
library(data.table)

# Cargar predicciones para 2022
pred <- fread("exp/[tu_experimento]/03_HT/predicciones_presente.csv")

# Ver resumen
summary(pred$prediccion_clase)

# Top 10 países con mayor OOP predicho
pred[order(-prediccion_clase), .(Country Code, Country Name, prediccion_clase)][1:10]

# Top 10 países con menor OOP predicho
pred[order(prediccion_clase), .(Country Code, Country Name, prediccion_clase)][1:10]
```

### Preguntas de Análisis

#### 1. ¿Las predicciones son razonables?

```r
# Comparar con valores históricos
hist_data <- fread("dataset/dataset_desafio.csv")

# Rango histórico de OOP
hist_range <- hist_data[!is.na(hf3_ppp_pc), range(hf3_ppp_pc)]
cat("Rango histórico:", hist_range, "\n")

# Rango de predicciones
pred_range <- range(pred$prediccion_clase)
cat("Rango predicciones:", pred_range, "\n")

# ¿Están en rango similar?
```

**Interpretación:**
- ✅ Si rangos son similares → Predicciones razonables
- ⚠️ Si predicciones son mucho más extremas → Posible problema (overfitting, extrapolación)

#### 2. ¿Hay patrones por región?

```r
# Promedio de predicciones por región
pred[, .(mean_pred = mean(prediccion_clase),
         median_pred = median(prediccion_clase),
         n = .N),
     by = region]
```

**Interpretación económica:**
> "Las predicciones muestran que la región AFR (África) tiene el mayor OOP promedio predicho (X USD PPP pc), mientras que EUR (Europa) tiene el menor (Y USD PPP pc). Esto es consistente con [teoría sobre protección financiera en sistemas de salud]."

#### 3. ¿Hay países "sorpresivos"?

```r
# Países con predicción muy diferente a su tendencia histórica
```

**Identificar:**
- Países que históricamente tenían OOP bajo pero se predice alto (o viceversa)
- ¿Por qué el modelo predice ese cambio?
- ¿Es razonable económicamente?

---

## 📚 Conectar con Teoría

### Marco Conceptual: Determinantes del Gasto de Bolsillo

**Teoría Económica de la Salud sugiere que OOP depende de:**

1. **Capacidad Económica del País**
   - ↑ PIB per cápita → ↓ OOP (con cobertura universal)
   - Pero: relación no lineal (países muy pobres también tienen OOP bajo por poca demanda)

2. **Protección Financiera**
   - ↑ Gasto público en salud → ↓ OOP
   - ↑ Cobertura de seguros → ↓ OOP
   - Meta OMS: OOP < 20% del gasto total en salud

3. **Necesidad de Salud**
   - ↑ Envejecimiento → ↑ Demanda → ↑ OOP (si no hay cobertura adecuada)
   - ↑ Carga de enfermedad → ↑ Uso servicios → ↑ OOP

4. **Eficiencia del Sistema**
   - Sistemas ineficientes → mayor costo de producir salud → mayor OOP
   - Calidad baja → ciudadanos recurren a sector privado → mayor OOP

### Conectar Importancia con Teoría

**Ejemplo de interpretación teóricamente fundamentada:**

> "Nuestro modelo identifica el PIB per cápita del año anterior como el predictor más importante (Gain = 0.15), lo cual es **consistente con la teoría de protección financiera** en economía de la salud. Países más ricos típicamente tienen mayor capacidad fiscal para financiar sistemas de salud públicos robustos, reduciendo la carga de gasto de bolsillo en los ciudadanos. El hecho de que el lag de 1 año sea más importante que el valor actual sugiere efectos retardados en la implementación de políticas de protección financiera."

> "Sorprendentemente, la expectativa de vida tiene una importancia relativamente baja (puesto #45), a pesar de ser un indicador clave de salud poblacional. Esto podría indicar que la **necesidad de salud** (capturada por expectativa de vida) es menos predictiva que la **capacidad de pago** (capturada por PIB). Esto refuerza el argumento de que OOP está más determinado por factores económicos que por factores de salud per se."

---

## ❌ Errores Comunes de Interpretación

### Error 1: Confundir Importancia con Causalidad

❌ **Mal:**
> "El PIB es la variable más importante, por lo tanto, para reducir OOP debemos aumentar el PIB."

✅ **Bien:**
> "El PIB es el predictor más fuerte de OOP en nuestro modelo. Esto no implica necesariamente causalidad directa, ya que PIB alto puede estar correlacionado con otros factores (calidad institucional, sistemas de salud robustos) que son los verdaderos causantes de bajo OOP."

### Error 2: Ignorar Variables Ausentes

❌ **Mal:**
> "Nuestro modelo identifica los determinantes completos del OOP."

✅ **Bien:**
> "Nuestro modelo identifica predictores de OOP dentro de las variables disponibles. Variables importantes no incluidas en el dataset (ej: calidad de gobernanza, corrupción, estructura de financiamiento de salud) podrían ser determinantes omitidos."

### Error 3: Sobreinterpretar Rankings Exactos

❌ **Mal:**
> "La variable X es exactamente 2.3 veces más importante que la variable Y porque Gain(X) / Gain(Y) = 2.3."

✅ **Bien:**
> "La variable X tiene mayor importancia que Y (Gain de 0.12 vs 0.05), sugiriendo que aporta aproximadamente el doble de información predictiva. Los rankings exactos deben interpretarse con cautela debido a posible correlación entre variables."

### Error 4: Ignorar Incertidumbre

❌ **Mal:**
> "El modelo predice con certeza que el OOP de Argentina en 2022 será $523.45 USD PPP pc."

✅ **Bien:**
> "El modelo predice que el OOP de Argentina en 2022 será aproximadamente $523 USD PPP pc. Esta predicción está sujeta a incertidumbre considerable, especialmente dado el contexto post-COVID y la volatilidad económica de la región."

### Error 5: No Contextualizar con Domain Knowledge

❌ **Mal:**
> "La variable `camas_hospitalarias` no es importante (puesto #89), por lo tanto las camas no importan para el gasto de bolsillo."

✅ **Bien:**
> "La variable `camas_hospitalarias` tiene baja importancia en el modelo (puesto #89). Esto podría deberse a: (1) alta colinealidad con otras variables de sistema de salud, (2) calidad de los datos (muchos NAs), o (3) la variable captura capacidad, no utilización real. La teoría económica sugiere que capacidad instalada es importante, pero nuestro modelo no logra capturar esta relación directamente."

---

## ✅ Checklist de Interpretación

Antes de escribir la sección de análisis en el informe:

- [ ] Identifiqué las top 20 variables más importantes
- [ ] Clasifiqué las variables por categorías temáticas (económicas, salud, demográficas, propias)
- [ ] Analicé qué tipo de variables dominan (lags, actuales, tendencias, ratios)
- [ ] Conecté los resultados con teoría de economía de la salud
- [ ] Mencioné mis variables propias (aparezcan o no en el top)
- [ ] Analicé las predicciones para 2022 (rangos, patrones por región)
- [ ] Reconocí limitaciones (variables ausentes, incertidumbre, diferencia entre correlación y causalidad)
- [ ] Evité errores comunes de interpretación

---

## 📝 Plantilla para Sección de Informe

### Estructura Sugerida:

```markdown
## 3. Resultados y Performance del Modelo

### 3.1 Métricas del Modelo

- RMSE en Validación: [valor]
- RMSE en Test: [valor]
- RMSE baseline (sin FE avanzado): [valor]
- Mejora: [%]

### 3.2 Análisis de Importancia de Variables

#### Top 5 Variables Más Importantes

1. **Variable 1** (Gain = X.XX)
   - Descripción: ...
   - Interpretación económica: ...
   
2. **Variable 2** (Gain = X.XX)
   - ...

#### Patrones Identificados

[Análisis de qué tipo de variables dominan]

#### Análisis de Variables Propias

[Si aparecen en top 50 o no, y qué implica]

### 3.3 Interpretación Económica

[Conectar con teoría de economía de la salud]

### 3.4 Análisis de Predicciones para 2022

[Patrones por región, países sorpresivos, validación de razonabilidad]

### 3.5 Limitaciones

[Variables ausentes, incertidumbre, advertencias]
```

---

## 🚀 Próximo Paso

Una vez que hayan interpretado los resultados:

**Ir a:** [05_FAQ_tecnico.md](05_FAQ_tecnico.md) si tienen problemas técnicos, o comenzar a escribir el **informe ejecutivo final**.

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0
