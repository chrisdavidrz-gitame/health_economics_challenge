# 💰 Métrica de Evaluación Económica

**Desafío de Machine Learning en Economía de la Salud**
**Universidad Nacional del Oeste - 2025**

---

## 🎯 Introducción

En este desafío, **NO solo evaluamos el RMSE** (Root Mean Squared Error) de sus predicciones. También evaluamos el **impacto económico** de sus modelos usando una métrica basada en economía de la salud.

### ¿Por qué?

Un modelo con buen RMSE puede seguir siendo **peligroso** si subestima sistemáticamente el gasto de bolsillo en países pobres, llevando a decisiones políticas incorrectas.

**Ejemplo:**

| Modelo | RMSE | Problema |
|--------|------|----------|
| Modelo A | 0.85 | Subestima gastos en países pobres → Familias en crisis |
| Modelo B | 0.90 | Sobreestima gastos (conservador) → Políticas más seguras |

**Modelo B es preferible**, aunque tenga peor RMSE.

---

## 📊 La Métrica: Impacto en Gasto Catastrófico

### Concepto Base: Gasto Catastrófico en Salud

Según la **Organización Mundial de la Salud (OMS)**:

> Un hogar incurre en **gasto catastrófico** cuando el gasto de bolsillo en salud excede el **10% del ingreso familiar**.

Cuando una familia cae en gasto catastrófico:
- Debe vender activos (casa, auto, tierra)
- Se endeuda
- Reduce gastos en alimentación o educación
- Puede caer en pobreza extrema

---

## 🧮 Cómo Calculamos la Ganancia Económica

### Paso 1: Ratio de Gasto vs Ingreso

Para cada país-año, calculamos:

```
Ratio = Gasto de bolsillo per cápita / Ingreso per cápita (GDP)
```

**Ejemplo:**
- País X: Gasto de bolsillo = $200 USD per cápita
- País X: GDP per cápita = $10,000 USD
- Ratio = 200 / 10,000 = **0.02 = 2%**

---

### Paso 2: Exceso sobre Umbral Catastrófico

El umbral catastrófico es **10% del ingreso**.

```
Exceso = max(0, Ratio - 0.10)
```

**Ejemplo:**
- Si Ratio = 0.15 (15%) → Exceso = 0.05 (5% por encima del umbral)
- Si Ratio = 0.08 (8%) → Exceso = 0 (no hay exceso)

---

### Paso 3: Monetizar el Impacto

Multiplicamos el exceso por la población y el ingreso per cápita:

```
Ganancia (USD) = (Exceso_real - Exceso_predicho) × Población × GDP_per_cápita
```

**Interpretación:**

| Situación | Ganancia | Significado |
|-----------|----------|-------------|
| Predicho < Real | **Positiva** | Sobreestimamos (conservador) ✅ |
| Predicho > Real | **Negativa** | Subestimamos (peligroso) ❌ |
| Predicho = Real | **Cero** | Predicción perfecta |

---

## 📐 Ejemplo Completo

### Datos:
- **País:** Argentina
- **Población:** 45 millones
- **GDP per cápita (PPP):** $20,000 USD
- **Gasto de bolsillo REAL (2022):** $2,200 USD per cápita
- **Gasto de bolsillo PREDICHO:** $2,500 USD per cápita

### Cálculo:

**1. Ratios:**
```
Ratio_real = 2200 / 20000 = 0.11 = 11%
Ratio_predicho = 2500 / 20000 = 0.125 = 12.5%
```

**2. Exceso:**
```
Exceso_real = 0.11 - 0.10 = 0.01 = 1%
Exceso_predicho = 0.125 - 0.10 = 0.025 = 2.5%
```

**3. Ganancia:**
```
Ganancia = (0.01 - 0.025) × 45,000,000 × 20,000
         = -0.015 × 900,000,000,000
         = -13,500,000,000 USD (pérdida de $13.5 mil millones)
```

**Interpretación:**
❌ El modelo **sobreestimó** el gasto, lo cual genera una **pérdida** porque:
- Las políticas se diseñarían para un gasto más alto del real
- Se desperdiciarían recursos
- Pero es menos peligroso que subestimar

---

## 🎯 Estrategia para Maximizar Ganancia

### 1. Ser Conservador en Países Pobres

En países con **bajo GDP per cápita**, es mejor **sobreestimar** levemente el gasto de bolsillo.

**Por qué:** El impacto de subestimar es **mucho mayor** en países donde las familias ya están al límite.

---

### 2. Identificar Países en Riesgo de Gasto Catastrófico

Crear variables que detecten:
- Países con sistemas de salud débiles
- Países sin cobertura universal
- Países con alta desigualdad

---

### 3. Usar Información de Tendencias

Si un país está aumentando su gasto de bolsillo:
- Detectar la tendencia
- Predecir continuación o aceleración

---

## 📊 Cómo Se Calcula Su Nota (Predicciones - 15%)

| Componente | Peso | Rango |
|------------|------|-------|
| **RMSE** | 60% | Normalizado entre grupos |
| **Ganancia Económica** | 30% | Normalizada entre grupos |
| **Formato Correcto** | 10% | Sí (1 pto) / No (0 ptos) |

### Fórmula:

```r
# Normalizar RMSE (mejor grupo = 10, peor = 0)
nota_rmse <- 10 * (1 - (tu_rmse - mejor_rmse) / (peor_rmse - mejor_rmse))

# Normalizar Ganancia (mejor = 10, peor = 0)
nota_ganancia <- 10 * (tu_ganancia - peor_ganancia) / (mejor_ganancia - peor_ganancia)

# Nota final (sobre 10)
nota_final <- 0.6 * nota_rmse + 0.3 * nota_ganancia + 1.0
```

---

## 🔍 Ejemplo de Comparación Entre Grupos

| Grupo | RMSE | Ganancia (USD) | Nota RMSE | Nota Ganancia | Nota Final |
|-------|------|----------------|-----------|---------------|------------|
| **Grupo 1** | 0.85 | +5M | 10.0 | 8.5 | **9.35** |
| **Grupo 2** | 0.90 | +8M | 7.5 | 10.0 | **8.50** |
| **Grupo 3** | 0.82 | -2M | 10.0 | 2.0 | **7.60** |

**Análisis:**
- **Grupo 1:** Mejor balance entre RMSE y ganancia → Mejor nota
- **Grupo 2:** Mejor ganancia económica, pero peor RMSE
- **Grupo 3:** Mejor RMSE, pero **pérdida económica** → Penalizado

---

## 💡 Consejos Finales

### ✅ Hacer:
- Analizar la distribución de errores por nivel de ingreso
- Detectar si tu modelo subestima en países pobres
- Crear variables que capturen vulnerabilidad económica
- Priorizar conservadurismo en predicciones de países frágiles

### ❌ Evitar:
- Optimizar SOLO para RMSE sin considerar el impacto económico
- Subestimar gastos en países con bajo GDP
- Ignorar la tendencia temporal del gasto

---

## 📚 Referencias

1. **WHO - Universal Health Coverage (UHC):**
   https://www.who.int/health-topics/universal-health-coverage

2. **Catastrophic Health Expenditure:**
   Xu, K. et al. (2007). "Protecting Households From Catastrophic Health Spending"
   Health Affairs, 26(4): 972-983

3. **Out-of-Pocket Payments and Health Equity:**
   Wagstaff, A. & van Doorslaer, E. (2003). "Catastrophe and impoverishment in paying for health care"
   The Lancet, 362(9388): 1026-1031

---

## ❓ FAQ

### ¿Por qué penalizamos subestimar más que sobreestimar?

Porque **subestimar** es más peligroso:
- Las políticas públicas se diseñan con datos incorrectos
- Las familias enfrentan gastos inesperados
- Se perpetúa la desigualdad

**Sobreestimar** es conservador y más seguro.

---

### ¿Cómo sé si mi modelo está subestimando?

Ejecutá el pipeline y analizá los residuos:
```r
# Después de predecir
residuos <- hf3_ppp_pc_real - hf3_ppp_pc_pred

# Si la mayoría de residuos son POSITIVOS → estás subestimando
mean(residuos > 0)  # Si > 0.5, subestimás en más de la mitad de países
```

---

### ¿Puedo ver mi ganancia económica antes de entregar?

No directamente, porque no tienen acceso a los datos reales de 2022.

Pero pueden:
1. Usar validación cruzada para estimar
2. Analizar si su modelo es conservador o agresivo
3. Comparar predicciones entre configuraciones

---

**Última actualización:** Noviembre 2025
**Autor:** Francisco Fernández
