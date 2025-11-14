# 💡 Guía de Feature Engineering Creativo

**Health Economics ML Challenge - UNO 2025**

Esta guía proporciona **hints conceptuales** para crear variables económicamente significativas. NO da soluciones completas, sino **preguntas y direcciones** para estimular su creatividad.

---

## 📋 Índice

1. [¿Qué es Feature Engineering?](#qué-es-feature-engineering)
2. [Principios de Buen Feature Engineering](#principios-de-buen-feature-engineering)
3. [Categorías de Variables a Considerar](#categorías-de-variables-a-considerar)
4. [Hints por Área Temática](#hints-por-área-temática)
5. [Ejemplos de Transformaciones](#ejemplos-de-transformaciones)
6. [Variables que NO Crear](#variables-que-no-crear)
7. [Cómo Evaluar Sus Variables](#cómo-evaluar-sus-variables)

---

## 🤖 ¿Qué es Feature Engineering?

**Definición:**  
Feature Engineering es el proceso de **crear nuevas variables** (features) a partir de las existentes para mejorar la capacidad predictiva del modelo.

### ¿Qué Ya Tienen Automático?

El pipeline YA crea automáticamente:

✅ **Lags:** Valores de años anteriores (1-4 años atrás)
- Ejemplo: `PIB_lag1` (PIB del año pasado)

✅ **Deltas:** Cambios respecto a años anteriores
- Ejemplo: `PIB_delta1` (cambio del PIB respecto al año pasado)

✅ **Tendencias:** Pendientes de regresión lineal en ventanas de 2-4 años
- Ejemplo: `PIB_tendencia_3` (tendencia del PIB en últimos 3 años)

✅ **Estadísticas móviles:** Min, max, promedio, ratios en ventanas temporales
- Ejemplo: `PIB_promedio_3` (promedio PIB últimos 3 años)

✅ **Rankings:** Posición relativa (0-1) dentro de cada año
- Ejemplo: `PIB_rank` (dónde está el país en PIB ese año)

✅ **Dummies para NAs:** Indicadores de datos faltantes
- Ejemplo: `mortalidad_infantil_isNA`

### ¿Qué Deben Crear USTEDES?

Su función `AgregarVariables()` debe crear variables que:

1. **Capturen relaciones económicas complejas** no representadas por transformaciones simples
2. **Incorporen conocimiento del dominio** (economía de la salud)
3. **Combinen múltiples variables** de formas significativas
4. **Representen conceptos teóricos** (ej: eficiencia, equidad, resiliencia)

---

## ⭐ Principios de Buen Feature Engineering

### 1. **Fundamentación Teórica**

❌ **Mal:** Crear `var1 * var2 / var3` sin razón  
✅ **Bien:** Crear `eficiencia_salud = expectativa_vida / gasto_salud_pc` porque **teóricamente** captura "cuánta salud se obtiene por dólar gastado"

### 2. **Interpretabilidad**

❌ **Mal:** `mystic_var <- sqrt(log(var1^2 + var2))`  
✅ **Bien:** `carga_enfermedad <- mortalidad_infantil + (100 - expectativa_vida)` porque **es interpretable** como "qué tan enfermo está el país"

### 3. **Robustez**

❌ **Mal:** Divisiones que pueden dar infinito o NaN  
✅ **Bien:** Agregar validaciones:
```r
dataset[, ratio_var := ifelse(denominador > 0, numerador / denominador, NA)]
```

### 4. **Parsimonia**

❌ **Mal:** Crear 100 variables "por las dudas"  
✅ **Bien:** Crear 10-20 variables **bien pensadas y justificadas**

---

## 🎯 Categorías de Variables a Considerar

### A. Ratios y Eficiencias

**Idea:** Muchas relaciones económicas se expresan como ratios.

**Ejemplos conceptuales:**
- **Eficiencia en salud:** ¿Cuánta expectativa de vida se obtiene por dólar gastado?
- **Carga de gasto:** ¿Qué % del PIB se gasta en salud de bolsillo?
- **Desbalance:** ¿Cuál es la relación entre gasto público y privado en salud?

**Preguntas para pensar:**
- ¿Qué ratios son relevantes en economía de la salud?
- ¿Qué cocientes capturan "eficiencia" o "ineficiencia"?
- ¿Hay umbrales importantes? (ej: OOP > 20% del gasto total)

### B. Dummies Conceptuales

**Idea:** Crear indicadores binarios (0/1) para situaciones o categorías relevantes.

**Ejemplos conceptuales:**
- **Crisis económicas:** Dummy para 2008-2009
- **Envejecimiento:** Dummy para países con >15% población mayor de 65
- **Bajos ingresos:** Dummy para países con PIB per cápita < umbral X
- **Sistemas frágiles:** Dummy para países con <2 camas hospitalarias por 1000 hab

**Preguntas para pensar:**
- ¿Qué eventos históricos pueden haber afectado el gasto en salud?
- ¿Hay umbrales importantes en las variables?
- ¿Qué características estructurales de un país son relevantes?

### C. Interacciones

**Idea:** El efecto de una variable puede depender de otra.

**Ejemplos conceptuales:**
- **PIB × sistema_salud_coverage:** El impacto del PIB en OOP puede ser diferente si hay cobertura universal
- **Envejecimiento × PIB:** Países ricos con población envejecida pueden tener patrones diferentes
- **Mortalidad × gasto_público_salud:** ¿Cómo interactúan?

**Preguntas para pensar:**
- ¿El efecto de X sobre OOP depende de Z?
- ¿Hay "sinergias" o "antagonismos" entre variables?

### D. Transformaciones No Lineales

**Idea:** Las relaciones no siempre son lineales.

**Ejemplos conceptuales:**
- **Logaritmos:** Para variables con distribuciones muy sesgadas (PIB, población)
- **Raíz cuadrada:** Para suavizar outliers
- **Potencias:** Para capturar no linealidades (ej: PIB^2)

**Preguntas para pensar:**
- ¿Hay variables con distribución muy sesgada?
- ¿Hay rendimientos decrecientes o crecientes?
- ¿Hay efectos "umbral"? (ej: después de cierto PIB, OOP baja mucho)

### E. Variables Temporales Conceptuales

**Idea:** Capturar aspectos temporales más allá de lags simples.

**Ejemplos conceptuales:**
- **Años desde evento:** Años desde primera vez que OOP superó cierto umbral
- **Persistencia:** ¿Cuántos años consecutivos OOP ha aumentado?
- **Volatilidad:** Desviación estándar de OOP en últimos N años
- **Recuperación:** ¿El país se está recuperando de una crisis?

**Preguntas para pensar:**
- ¿Hay "momentos clave" en la historia del país que importen?
- ¿La trayectoria (subiendo/bajando) importa tanto como el nivel?

---

## 🧠 Hints por Área Temática

### 1. Eficiencia y Productividad del Sistema de Salud

**Concepto Teórico:**  
No todos los países "producen salud" con la misma eficiencia. Algunos gastan mucho pero obtienen poca mejora en outcomes.

**Variables que ya tienen:**
- `SP.DYN.LE00.IN` - Expectativa de vida
- `SH.XPD.CHEX.PC.CD` - Gasto en salud per cápita
- `SP.DYN.IMRT.IN` - Mortalidad infantil
- `SH.MED.BEDS.ZS` - Camas hospitalarias per cápita

**Preguntas guía:**
- ¿Cómo medirías "eficiencia" en producción de salud?
- ¿Qué relación esperarías entre gasto en salud y expectativa de vida?
- ¿Países con más camas hospitalarias tienen menor mortalidad?
- ¿Cómo capturar si un país está "sobre-gastando" o "sub-gastando"?

**Hint conceptual:**
```r
# Eficiencia básica: output / input
# Output = Salud producida (expectativa de vida, 100 - mortalidad)
# Input = Recursos usados (gasto, camas, médicos)
#
# Ejemplo conceptual (NO es la única forma):
# eficiencia = expectativa_vida / gasto_salud_per_capita
```

---

### 2. Carga de Enfermedad y Necesidad de Salud

**Concepto Teórico:**  
Países con mayor "carga de enfermedad" (envejecimiento, enfermedades crónicas, mortalidad) probablemente tienen mayor gasto de bolsillo.

**Variables que ya tienen:**
- `SP.POP.65UP.TO.ZS` - % Población ≥65 años
- `SP.DYN.IMRT.IN` - Mortalidad infantil
- `SP.DYN.LE00.IN` - Expectativa de vida
- `SP.DYN.CBRT.IN` - Tasa de natalidad

**Preguntas guía:**
- ¿Cómo construirías un "índice de carga de enfermedad"?
- ¿El envejecimiento poblacional aumenta OOP?
- ¿Alta mortalidad infantil implica sistema de salud débil → mayor OOP?
- ¿Hay una relación entre estructura demográfica y gasto de bolsillo?

**Hint conceptual:**
```r
# Índice de carga: combinar múltiples indicadores de "mala salud"
# Más carga = peor salud poblacional
#
# Componentes posibles:
# - Alta mortalidad infantil
# - Baja expectativa de vida
# - Alto envejecimiento (o bajo, según país)
#
# Ejemplo conceptual:
# carga_enfermedad = mortalidad_infantil + (100 - expectativa_vida) + ...
```

---

### 3. Capacidad Económica y Protección Financiera

**Concepto Teórico:**  
Países más ricos pueden "proteger" mejor a sus ciudadanos del gasto de bolsillo mediante seguros públicos o privados.

**Variables que ya tienen:**
- `NY.GDP.PCAP.PP.CD` - PIB per cápita PPP
- `NY.GDP.MKTP.KD.ZG` - Crecimiento del PIB
- `income` - Nivel de ingreso del país
- Inflación, desempleo (si están en el dataset)

**Preguntas guía:**
- ¿Más PIB = menos OOP? ¿Es lineal o hay umbrales?
- ¿El crecimiento económico reduce OOP inmediatamente o con lag?
- ¿Los países de ingresos altos siempre tienen bajo OOP?
- ¿Hay "trampas de pobreza" en salud?

**Hint conceptual:**
```r
# Capacidad de protección financiera
# Más PIB per cápita → más recursos para seguros públicos/privados → menos OOP
#
# Pero: No es lineal. Países muy pobres y muy ricos pueden tener bajo OOP
#       (pobres: poca demanda, ricos: buena cobertura)
#
# Ejemplo conceptual:
# capacidad_proteccion = log(PIB_per_capita) * indicador_cobertura
```

---

### 4. Crisis y Shocks Económicos

**Concepto Teórico:**  
Crisis económicas (2008, COVID) pueden alterar patrones de gasto en salud.

**Variables que ya tienen:**
- `year` - Año (para crear dummies temporales)
- `NY.GDP.MKTP.KD.ZG` - Crecimiento PIB (negativo en crisis)

**Preguntas guía:**
- ¿Qué crisis económicas globales hubo en 2000-2021?
- ¿Las crisis aumentan o disminuyen OOP? (depende: menos demanda vs menos cobertura pública)
- ¿COVID fue diferente de crisis económicas "normales"?
- ¿Cuánto tarda la recuperación post-crisis en reflejarse en OOP?

**Hint conceptual:**
```r
# Dummies para eventos
# 
# Ejemplos:
# - Crisis financiera 2008-2009
# - Crisis europea 2011-2013
# - COVID 2020-2021 (si deciden usarlo)
# - Recesiones (crecimiento PIB < 0)
#
# Ejemplo conceptual:
# dataset[, crisis_2008 := ifelse(year %in% 2008:2009, 1, 0)]
# dataset[, en_recesion := ifelse(crecimiento_pib < 0, 1, 0)]
```

---

### 5. Heterogeneidad Regional y Estructural

**Concepto Teórico:**  
Los patrones de gasto en salud varían entre regiones y niveles de desarrollo.

**Variables que ya tienen:**
- `region` - Región WHO (AFR, AMR, EMR, EUR, SEAR, WPR)
- `income` - Nivel de ingreso (Low, Lower-middle, Upper-middle, High)

**Preguntas guía:**
- ¿Las regiones tienen patrones diferentes de OOP?
- ¿La combinación región × income level importa?
- ¿Hay "convergencia" entre países similar desarrollo?
- ¿Países vecinos tienen patrones similares?

**Hint conceptual:**
```r
# Ya tienen region e income como categóricas
# El modelo las usará automáticamente
#
# Pero pueden crear:
# - Interacciones region × income
# - Interacciones region × PIB
# - Dummies para regiones específicas si tienen hipótesis
#
# Ejemplo conceptual:
# dataset[, region_high_income := ifelse(region == "EUR" & income == "High", 1, 0)]
```

---

### 6. Variables Propias de Economía de la Salud

**Conceptos Teóricos de la Literatura:**

#### a) QALYs Aproximados (Quality-Adjusted Life Years)
- **Idea:** Capturar "años de vida saludable" no solo "años de vida"
- **Variables disponibles:** Expectativa de vida, mortalidad, discapacidad (si hay)
- **Hint:** ¿Cómo aproximarías QALYs con los datos que tienen?

#### b) Financial Protection
- **Idea:** Medir cuánto protege el sistema de salud a las personas
- **Hint:** OOP alto = baja protección. ¿Cómo medirías "riesgo de gasto catastrófico"?

#### c) Universal Health Coverage (UHC)
- **Idea:** Países con UHC tienen menor OOP
- **Problema:** No tienen variable directa de UHC
- **Hint:** ¿Qué proxies podrían indicar "nivel de cobertura universal"? (% gasto público en salud, camas hospitalarias per cápita, ...)

#### d) Out-of-Pocket Burden
- **Idea:** El peso del OOP depende del ingreso
- **Hint:** OOP de $100 es muy diferente para un país con PIB $1000 vs $50000 per cápita
- **Ejemplo conceptual:**
```r
# Burden relativo
dataset[, oop_burden := hf3_ppp_pc / PIB_per_capita]
```

---

## 🔧 Ejemplos de Transformaciones

### Ejemplo 1: Ratio Básico

```r
# Eficiencia del sistema de salud
# ¿Cuánta expectativa de vida se obtiene por cada dólar gastado?
dataset[, eficiencia_salud := SP.DYN.LE00.IN / SH.XPD.CHEX.PC.CD]

# Validación: Si denominador es 0 o NA, asignar NA
dataset[is.infinite(eficiencia_salud), eficiencia_salud := NA]
```

### Ejemplo 2: Índice Compuesto

```r
# Índice de carga de enfermedad (0-100)
# Componentes: mortalidad infantil, expectativa de vida invertida
dataset[, carga_enfermedad := 
          (SP.DYN.IMRT.IN / 100) +           # Mortalidad infantil normalizada
          ((100 - SP.DYN.LE00.IN) / 100)]    # Expectativa de vida invertida
```

### Ejemplo 3: Dummy por Umbral

```r
# Países con alto envejecimiento (>15% mayores de 65)
dataset[, poblacion_envejecida := ifelse(SP.POP.65UP.TO.ZS > 15, 1, 0)]
```

### Ejemplo 4: Interacción

```r
# Interacción: PIB × cobertura hospitalaria
# La relación PIB-OOP puede ser diferente según capacidad hospitalaria
dataset[, pib_x_camas := NY.GDP.PCAP.PP.CD * SH.MED.BEDS.ZS]
```

### Ejemplo 5: Variable Temporal

```r
# Años desde que OOP superó cierto umbral (por país)
# (requiere cálculo por grupo)
umbral_alto <- 500  # Ejemplo: 500 USD PPP per cápita

dataset[, year_first_high_oop := min(year[hf3_ppp_pc > umbral_alto]), 
        by = "Country Code"]
        
dataset[, years_since_high_oop := year - year_first_high_oop]
dataset[years_since_high_oop < 0, years_since_high_oop := 0]
```

### Ejemplo 6: Transformación No Lineal

```r
# Logaritmo del PIB (para "comprimir" la escala)
# Útil cuando PIB tiene rango muy amplio (1000 a 100000)
dataset[, log_pib := log(NY.GDP.PCAP.PP.CD + 1)]  # +1 para evitar log(0)
```

---

## ❌ Variables que NO Crear

### 1. **No Crear Variables que Causan Data Leakage**

❌ **Mal:** Usar información del futuro
```r
# ¡NO HACER ESTO!
dataset[, oop_futuro := shift(hf3_ppp_pc, type = "lead")]  # ¡Leakage!
```

❌ **Mal:** Usar la variable target o derivadas directas
```r
# ¡NO HACER ESTO!
dataset[, oop_cuadrado := hf3_ppp_pc^2]  # Es casi la misma variable
```

### 2. **No Crear Variables Redundantes**

❌ **Mal:** Variables que ya existen con otro nombre
```r
# ¡NO HACER ESTO!
dataset[, nueva_var := PIB * 1.0]  # Es lo mismo que PIB
```

### 3. **No Crear Variables Sin Sentido Económico**

❌ **Mal:** Combinaciones arbitrarias sin justificación
```r
# ¡NO HACER ESTO!
dataset[, mystic_var := (var1^3 + sqrt(var2)) / log(var3 + 100)]
# ¿Qué significa esto? ¿Por qué esa fórmula específica?
```

### 4. **No Crear Demasiadas Variables**

❌ **Mal:** Crear 200 variables "por si acaso"
- El modelo puede confundirse (curse of dimensionality)
- Es difícil interpretar luego
- Incrementa tiempo de ejecución

✅ **Bien:** Crear 10-20 variables **bien pensadas**

---

## 📊 Cómo Evaluar Sus Variables

### 1. **Durante Desarrollo**

**Explorar distribución:**
```r
# Resumen estadístico
summary(dataset$nueva_variable)

# Visualizar
hist(dataset$nueva_variable, main = "Distribución de nueva_variable")

# Verificar NAs
sum(is.na(dataset$nueva_variable))

# Verificar infinitos
sum(is.infinite(dataset$nueva_variable))
```

**Correlación con target:**
```r
# Solo para años donde target existe
cor(dataset[!is.na(hf3_ppp_pc), .(nueva_variable, hf3_ppp_pc)], 
    use = "complete.obs")
```

### 2. **Después de Ejecutar Pipeline**

**Revisar `tb_importancia.txt`:**
```
exp/[experimento]/03_HT/tb_importancia.txt
```

**¿Sus variables aparecen en el top 50?**
- ✅ SÍ → La variable es útil para el modelo
- ❌ NO → La variable no aporta información nueva o es redundante

**¿Sus variables aparecen en el top 20?**
- 🌟 EXCELENTE → Variable muy informativa, mencionar en informe

### 3. **Comparación Baseline**

**Estrategia:**
1. Ejecutar pipeline CON sus variables → anotar RMSE
2. Comentar `AgregarVariables()` (dejarla vacía) → ejecutar de nuevo → anotar RMSE
3. Comparar:
   - Si RMSE con variables < RMSE sin variables → ✅ Sus variables ayudan
   - Si RMSE con variables ≈ RMSE sin variables → ⚠️ Sus variables no aportan mucho
   - Si RMSE con variables > RMSE sin variables → ❌ Sus variables empeoran (posible overfitting)

---

## 💭 Reflexiones Finales

### Lo Importante NO es la Cantidad

Mejor crear **5 variables excelentes** que **50 variables mediocres**.

### Lo Importante es la Justificación

En el informe, para cada variable creada, deben poder responder:
1. ¿Qué captura esta variable?
2. ¿Por qué es relevante económicamente?
3. ¿Qué relación esperan con el target?
4. ¿Cómo se desempeñó en el modelo?

### Iterar es Parte del Proceso

Feature Engineering es **iterativo**:
1. Crear variables con hipótesis inicial
2. Ejecutar pipeline
3. Revisar importancia
4. Ajustar/eliminar/crear nuevas variables
5. Repetir

No esperen acertar a la primera. **La iteración es parte del aprendizaje.**

---

## ✅ Checklist de Feature Engineering

Antes de entregar, verificar:

- [ ] Creé entre 10-20 variables económicamente significativas
- [ ] Cada variable tiene comentario explicando qué captura
- [ ] Verifiqué que no hay infinitos ni NaNs no manejados
- [ ] Revisé `tb_importancia.txt` - ¿alguna de mis variables está en top 50?
- [ ] Comparé RMSE con y sin mis variables
- [ ] Puedo justificar económicamente cada variable en el informe
- [ ] Considero que mis variables capturan aspectos no capturados por lags/tendencias automáticas

---

## 🎓 Evaluación de Feature Engineering

**Este componente vale 40% de la nota final:**
- Originalidad (15%): Variables novedosas y bien fundamentadas
- Justificación teórica (15%): Conexión con economía de la salud
- Impacto en performance (10%): Mejora en RMSE

---

## 🚀 Próximo Paso

Una vez que hayan creado sus variables:

**Ir a:** [04_guia_interpretacion.md](04_guia_interpretacion.md) para aprender a interpretar los resultados del modelo.

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0
