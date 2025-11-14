# Diccionario de Variables - Otras Variables (PA.*, region, income)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Tipo de Cambio (PA.*)

### PA.NUS.ATLS
**Nombre:** Tipo de cambio oficial (LCU por USD, promedio del período)  
**Definición:** Tipo de cambio oficial de la moneda local por dólar estadounidense, promedio anual  
**Unidad:** Unidades de moneda local por USD  
**Interpretación:** Valor de la moneda local vs. dólar. Valores más altos = moneda local más débil.

### PA.NUS.FCRF
**Nombre:** Tipo de cambio oficial (LCU por USD, fin del período)  
**Definición:** Tipo de cambio oficial al final del año  
**Unidad:** Unidades de moneda local por USD  
**Interpretación:** Valor de la moneda al cierre del año fiscal

---

## Variables de Metadatos (WHO)

### region
**Nombre:** Región WHO  
**Definición:** Clasificación regional de la Organización Mundial de la Salud  
**Valores posibles:**
- **AFR** - África (African Region)
- **AMR** - Américas (Region of the Americas)
- **EMR** - Mediterráneo Oriental (Eastern Mediterranean Region)
- **EUR** - Europa (European Region)
- **SEAR** - Sudeste Asiático (South-East Asia Region)
- **WPR** - Pacífico Occidental (Western Pacific Region)

**Interpretación:** Agrupación geográfica-epidemiológica. Captura diferencias estructurales en sistemas de salud y carga de enfermedad entre regiones.

### income
**Nombre:** Nivel de ingreso del país  
**Definición:** Clasificación del Banco Mundial según ingreso nacional bruto per cápita  
**Valores posibles:**
- **Low** - Ingreso bajo (GNI per cápita ≤ $1,135)
- **Lower-middle** - Ingreso medio-bajo ($1,136 - $4,465)
- **Upper-middle** - Ingreso medio-alto ($4,466 - $13,845)
- **High** - Ingreso alto (≥ $13,846)

**Interpretación:** Proxy fundamental de nivel de desarrollo económico. Países de mayor ingreso típicamente tienen:
- Mejores sistemas de salud
- Mayor gasto total en salud
- Pero NO necesariamente mayor gasto de bolsillo (pueden tener mejor protección financiera)

---

## Relevancia CRÍTICA para Economía de la Salud

### 1. **region - Variable Dummy de Control ESENCIAL**

**¿Por qué es importante?**
- Captura diferencias NO observables entre regiones:
  - Estructura demográfica (África: población joven, Europa: envejecida)
  - Carga de enfermedad (África: malaria, tuberculosis; Europa: enfermedades crónicas)
  - Organización de sistemas de salud
  - Factores culturales en uso de servicios

**Uso esperado en el modelo:**
```r
# Crear dummies para región
dataset[, region_AFR := ifelse(region == "AFR", 1, 0)]
dataset[, region_AMR := ifelse(region == "AMR", 1, 0)]
dataset[, region_EMR := ifelse(region == "EMR", 1, 0)]
dataset[, region_EUR := ifelse(region == "EUR", 1, 0)]
dataset[, region_SEAR := ifelse(region == "SEAR", 1, 0)]
# WPR queda como categoría de referencia
```

**Hipótesis regional:**
- **AFR:** Mayor gasto de bolsillo (sistemas públicos débiles)
- **EUR:** Menor gasto de bolsillo (cobertura universal sólida)
- **AMR:** Alta variabilidad (USA vs. resto de las Américas)

### 2. **income - Predictor Fundamental de Capacidad de Pago**

**¿Por qué es crucial?**
- **Correlación NO lineal con gasto de bolsillo:**
  - **Low income:** Alto % de OOP sobre gasto total (falta protección)
  - **Lower-middle:** MUY alto OOP (peak de catastrofic spending)
  - **Upper-middle:** OOP empieza a bajar (mejores seguros)
  - **High income:** Bajo OOP en % pero alto en valor absoluto (PPP per cápita)

**Uso esperado:**
```r
# Dummies de income
dataset[, income_Low := ifelse(income == "Low", 1, 0)]
dataset[, income_LowerMiddle := ifelse(income == "Lower-middle", 1, 0)]
dataset[, income_UpperMiddle := ifelse(income == "Upper-middle", 1, 0)]
# High queda como referencia

# Interacción con otras variables
dataset[, income_mortality_interaction := income_Low * SH.DTH.IMRT]
```

### 3. **PA.NUS.ATLS - Tipo de Cambio y Poder Adquisitivo**

**¿Por qué importa?**
- **Devaluación de moneda afecta gasto en salud:**
  - Medicamentos importados más caros
  - Equipamiento médico más costoso
  - Puede aumentar gasto de bolsillo real

**Uso potencial:**
```r
# Volatilidad cambiaria
dataset[, exchange_volatility := abs(PA.NUS.ATLS - lag(PA.NUS.ATLS, 1)) / lag(PA.NUS.ATLS, 1)]

# Devaluación acumulada
dataset[, exchange_depreciation_5y := (PA.NUS.ATLS - lag(PA.NUS.ATLS, 5)) / lag(PA.NUS.ATLS, 5)]
```

---

## Feature Engineering Sugerido

### Interacciones Región × Income
```r
# Capturar efectos combinados
dataset[, AFR_low_income := region_AFR * income_Low]
dataset[, EUR_high_income := region_EUR * income_High]
```

### Dummies Temporales + Región
```r
# Crisis regional específicas
dataset[, AFR_2020 := region_AFR * ifelse(year == 2020, 1, 0)]  # COVID en África
dataset[, AMR_2008 := region_AMR * ifelse(year == 2008, 1, 0)]  # Crisis financiera
```

---

## Resumen: Importancia de Variables de Metadatos

### **region**
- **Uso:** Variable de control obligatoria (dummies)
- **Importancia esperada:** ALTA - Captura efectos fijos regionales
- **Recomendación:** SIEMPRE incluir en el modelo

### **income**
- **Uso:** Variable de control obligatoria (dummies o ordinal)
- **Importancia esperada:** MUY ALTA - Predictor fundamental de capacidad y necesidad
- **Recomendación:** SIEMPRE incluir + considerar interacciones

### **PA.NUS.ATLS**
- **Uso:** Variable económica de contexto
- **Importancia esperada:** MEDIA - Relevante en países con crisis cambiarias
- **Recomendación:** Considerar volatilidad y cambios temporales

---

## ⚠️ ADVERTENCIA: No Confundir income con PIB per cápita

**income** es una variable CATEGÓRICA (Low, Lower-middle, Upper-middle, High)  
**NY.GDP.PCAP.CD** es una variable CONTINUA (USD per cápita)

Ambas capturan nivel de desarrollo pero de forma diferente:
- **income:** Captura umbrales y saltos discretos en políticas de salud
- **GDP per cápita:** Captura variación continua en capacidad económica

**Recomendación:** Usar AMBAS puede ser beneficioso (una como dummy, otra continua)
