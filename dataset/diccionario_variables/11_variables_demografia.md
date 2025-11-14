# Diccionario de Variables - Demografía y Población (SP.*, SM.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables Demográficas Clave

### Población Total y Crecimiento

**SP.POP.TOTL:** Población total  
**SP.POP.GROW:** Tasa de crecimiento poblacional (%)  
**SP.POP.TOTL.FE.IN:** Población femenina  
**SP.POP.TOTL.FE.ZS:** Población femenina (% del total)  
**SP.POP.TOTL.MA.IN:** Población masculina  
**SP.POP.TOTL.MA.ZS:** Población masculina (% del total)

### Urban ización

**SP.URB.TOTL:** Población urbana  
**SP.URB.TOTL.IN.ZS:** Población urbana (% del total)  
**SP.URB.GROW:** Crecimiento población urbana (%)  
**SP.RUR.TOTL:** Población rural  
**SP.RUR.TOTL.ZS:** Población rural (% del total)  
**SP.RUR.TOTL.ZG:** Crecimiento población rural (%)

### Estructura de Edad (por grupos quinquenales)

**Variables por sexo:** SP.POP.XXXX.FE.5Y y SP.POP.XXXX.MA.5Y  
Grupos: 0004, 0509, 1014, 1519, 2024, 2529, 3034, 3539, 4044, 4549, 5054, 5559, 6064, 6569, 7074, 7579, 80UP

**Grupos amplios:**
- SP.POP.0014.*.* (Población 0-14 años)
- SP.POP.1564.*.* (Población 15-64 años, edad activa)
- SP.POP.65UP.*.* (Población 65+ años, **CRÍTICO** para gasto en salud)

### Dependencia Demográfica

**SP.POP.DPND:** Ratio de dependencia total  
**SP.POP.DPND.OL:** Ratio de dependencia de ancianos (MUY IMPORTANTE)  
**SP.POP.DPND.YG:** Ratio de dependencia de jóvenes

### Expectativa de Vida

**SP.DYN.LE00.IN:** Expectativa de vida al nacer (total)  
**SP.DYN.LE00.FE.IN:** Expectativa de vida mujeres  
**SP.DYN.LE00.MA.IN:** Expectativa de vida hombres

**Interpretación:** **MUY IMPORTANTE** - Mayor expectativa → población más vieja → mayor gasto

### Tasas Vitales

**SP.DYN.CBRT.IN:** Tasa de natalidad (por 1,000)  
**SP.DYN.CDRT.IN:** Tasa de mortalidad (por 1,000)  
**SP.DYN.TFRT.IN:** Tasa de fertilidad (hijos por mujer)  
**SP.ADO.TFRT:** Fertilidad adolescente

### Mortalidad

**SP.DYN.IMRT.IN:** Mortalidad infantil (por 1,000 nacidos vivos)  
**SP.DYN.IMRT.FE.IN:** Mortalidad infantil femenina  
**SP.DYN.IMRT.MA.IN:** Mortalidad infantil masculina

**SP.DYN.AMRT.FE:** Tasa mortalidad adulta femenina  
**SP.DYN.AMRT.MA:** Tasa mortalidad adulta masculina

### Migración

**SM.POP.NETM:** Migración neta  
**SM.POP.RHCR.EA:** Refugiados por país de asilo  
**SM.POP.RHCR.EO:** Refugiados por país de origen

### Ratio de Sexo

**SP.POP.BRTH.MF:** Ratio de sexo al nacer (hombres por mujer)

---

## Relevancia para Economía de la Salud

### Variables CRÍTICAS:

1. **SP.POP.65UP.TO.ZS (Población 65+ años % del total):**
   - **Variable EXTREMADAMENTE importante**
   - Envejecimiento poblacional → mayor demanda de salud
   - Población mayor gasta mucho más en salud
   - Probablemente TOP 5 en el modelo

2. **SP.DYN.LE00.IN (Expectativa de vida):**
   - Mayor expectativa → población más longeva → más gasto
   - Proxy de calidad del sistema de salud
   - Relación compleja: mejor salud pero más demanda

3. **SP.URB.TOTL.IN.ZS (Urbanización):**
   - Mayor urbanización → mejor acceso a servicios
   - Pero también mayor costo de vida
   - Efecto ambiguo en gasto de bolsillo

4. **SP.POP.DPND.OL (Ratio dependencia ancianos):**
   - Carga sobre población activa
   - Mayor ratio → más presión sobre familias
   - Potencialmente mayor gasto de bolsillo

5. **SP.DYN.IMRT.IN (Mortalidad infantil):**
   - Proxy inverso de calidad de salud
   - Alta mortalidad → sistema de salud débil
   - Correlación negativa con desarrollo

### Transición Demográfica:
- Países en transición: ↓ fertilidad, ↑ expectativa vida
- Resultado: envejecimiento poblacional
- Mayor demanda de servicios crónicos
- **Implicación:** Creciente gasto en salud

**Nota para Feature Engineering:**
- **Índice de envejecimiento:** SP.POP.65UP.TO.ZS / SP.POP.0014.TO.ZS
- **Velocidad de envejecimiento:** Cambio en SP.POP.65UP.TO.ZS últimos 5 años
- **Bono demográfico:** SP.POP.1564.TO.ZS (alta ratio activa)
- **Pirámide invertida:** Ratio 65+/15-64
- **Urbanización reciente:** Cambio en SP.URB.TOTL.IN.ZS

**Contexto COVID-19:**
- Población mayor más vulnerable
- Interacción edad × COVID para 2020-2021
- Potencial efecto en mortalidad y expectativa de vida 2020
