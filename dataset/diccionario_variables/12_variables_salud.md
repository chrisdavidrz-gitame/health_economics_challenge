# Diccionario de Variables - Salud (SH.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Mortalidad Infantil y Neonatal

### SH.DTH.IMRT
**Nombre:** Tasa de mortalidad infantil  
**Definición:** Muertes de niños menores de 1 año por cada 1,000 nacidos vivos  
**Unidad:** Por 1,000 nacidos vivos  
**Interpretación:** Indicador clave de calidad del sistema de salud. Valores altos sugieren sistemas deficientes.

### SH.DTH.MORT
**Nombre:** Tasa de mortalidad en menores de 5 años  
**Definición:** Muertes de niños menores de 5 años por cada 1,000 nacidos vivos  
**Unidad:** Por 1,000 nacidos vivos  
**Interpretación:** Refleja acceso a servicios de salud, nutrición y condiciones sanitarias

### SH.DTH.NMRT
**Nombre:** Tasa de mortalidad neonatal  
**Definición:** Muertes de recién nacidos (primeros 28 días) por cada 1,000 nacidos vivos  
**Unidad:** Por 1,000 nacidos vivos  
**Interpretación:** Indicador de calidad de atención prenatal y del parto

### SH.DYN.NMRT
**Nombre:** Tasa de mortalidad neonatal (alternativa)  
**Definición:** Muertes neonatales por cada 1,000 nacidos vivos  
**Unidad:** Por 1,000 nacidos vivos  
**Interpretación:** Similar a SH.DTH.NMRT

## Variables de Mortalidad Adulta

### SH.DYN.MORT
**Nombre:** Probabilidad de muerte entre 5-60 años  
**Definición:** Probabilidad de muerte entre 5 y 60 años por cada 1,000 personas  
**Unidad:** Por 1,000 personas  
**Interpretación:** Riesgo de mortalidad en edad productiva

### SH.DYN.MORT.FE
**Nombre:** Probabilidad de muerte 5-60 años (mujeres)  
**Definición:** Probabilidad de muerte entre 5 y 60 años para mujeres  
**Unidad:** Por 1,000 mujeres  
**Interpretación:** Mortalidad femenina en edad productiva

### SH.DYN.MORT.MA
**Nombre:** Probabilidad de muerte 5-60 años (hombres)  
**Definición:** Probabilidad de muerte entre 5 y 60 años para hombres  
**Unidad:** Por 1,000 hombres  
**Interpretación:** Mortalidad masculina en edad productiva

## Variables de Inmunización

### SH.IMM.IDPT
**Nombre:** Inmunización DPT (difteria, pertussis, tétanos)  
**Definición:** Porcentaje de niños de 12-23 meses con inmunización completa DPT  
**Unidad:** Porcentaje  
**Interpretación:** Indicador de cobertura de vacunación básica y acceso a servicios preventivos

### SH.IMM.MEAS
**Nombre:** Inmunización contra sarampión  
**Definición:** Porcentaje de niños de 12-23 meses vacunados contra sarampión  
**Unidad:** Porcentaje  
**Interpretación:** Cobertura de vacunación contra enfermedades prevenibles

## Variables de Salud Materna

### SH.MMR.DTHS
**Nombre:** Muertes maternas (número absoluto)  
**Definición:** Número total de muertes maternas en el año  
**Unidad:** Número absoluto  
**Interpretación:** Magnitud absoluta de mortalidad materna

### SH.MMR.RISK
**Nombre:** Riesgo de mortalidad materna de por vida  
**Definición:** Probabilidad de que una mujer de 15 años muera por causas maternas durante su vida reproductiva  
**Unidad:** 1 en X (inverso)  
**Interpretación:** Riesgo acumulado de muerte materna

### SH.MMR.RISK.ZS
**Nombre:** Riesgo de mortalidad materna (%)  
**Definición:** Riesgo de mortalidad materna expresado como porcentaje  
**Unidad:** Porcentaje  
**Interpretación:** Versión porcentual del riesgo de mortalidad materna

### SH.STA.MMRT
**Nombre:** Razón de mortalidad materna  
**Definición:** Muertes maternas por cada 100,000 nacidos vivos  
**Unidad:** Por 100,000 nacidos vivos  
**Interpretación:** Indicador estándar de calidad de atención obstétrica. Valores altos indican sistemas deficientes.

---

## Relevancia CRÍTICA para Economía de la Salud

⚠️ **ESTAS SON LAS VARIABLES MÁS RELEVANTES** para predecir gasto de bolsillo en salud.

### 1. **Relación Directa con Calidad del Sistema de Salud**

**Mortalidad infantil (SH.DTH.IMRT):** Países con alta mortalidad infantil típicamente tienen:
- Sistemas de salud más débiles
- Mayor dependencia de pagos de bolsillo
- Menor inversión pública en salud

**Mortalidad materna (SH.STA.MMRT):** Alta mortalidad indica:
- Falta de acceso a servicios de calidad
- Necesidad de recurrir a proveedores privados
- Sistemas sub-financiados

### 2. **Inmunización como Proxy de Acceso**

**Alta cobertura de vacunación (SH.IMM.IDPT, SH.IMM.MEAS):**
- Indica buen acceso a servicios preventivos públicos
- Sugiere menor dependencia de proveedores privados
- Predice menor gasto de bolsillo

### 3. **Ideas para Feature Engineering**

```r
# Índice de salud materno-infantil
health_mch_index <- (SH.DTH.IMRT + SH.DTH.MORT + SH.STA.MMRT) / 3

# Brecha de género en mortalidad adulta
mortality_gender_gap <- SH.DYN.MORT.MA - SH.DYN.MORT.FE

# Cobertura de inmunización promedio
immunization_coverage <- (SH.IMM.IDPT + SH.IMM.MEAS) / 2

# Indicador de crisis en salud materna
maternal_crisis <- ifelse(SH.STA.MMRT > 300, 1, 0)
```

### 4. **Hipótesis a Testear**

1. **H1:** Mayor mortalidad infantil → Mayor gasto de bolsillo
2. **H2:** Alta cobertura de vacunación → Menor gasto de bolsillo
3. **H3:** Alta mortalidad materna → Mayor gasto de bolsillo
4. **H4:** Brecha grande de género en mortalidad → Mayor gasto de bolsillo

---

## Top 5 Variables SH.* por Importancia Esperada

1. **SH.DTH.IMRT** - Mortalidad infantil (predictor #1 esperado)
2. **SH.STA.MMRT** - Mortalidad materna (predictor #2 esperado)
3. **SH.IMM.IDPT** - Cobertura de vacunación
4. **SH.DTH.MORT** - Mortalidad <5 años
5. **SH.DYN.MORT** - Mortalidad adulta

**Estas variables deberían aparecer en el Top 20 de importancia de cualquier modelo bien ajustado.**
