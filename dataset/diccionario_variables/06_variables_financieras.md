# Diccionario de Variables - Sector Financiero (FD.*, FI.*, FM.*, FP.*, FS.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Desarrollo Financiero (FD.*, FM.*, FS.*)

### FD.AST.PRVT.GD.ZS
**Nombre:** Crédito interno al sector privado (% PIB)  
**Definición:** Crédito bancario al sector privado como % del PIB  
**Unidad:** Porcentaje del PIB  
**Interpretación:** Profundidad del sistema financiero, acceso a financiamiento

### FM.AST.DOMS.CN
**Nombre:** Activos internos  
**Definición:** Activos internos del sistema monetario (moneda local)  
**Unidad:** Moneda local  
**Interpretación:** Tamaño del sistema financiero doméstico

### FM.AST.NFRG.CN
**Nombre:** Activos externos netos  
**Definición:** Activos externos del sistema monetario (moneda local)  
**Unidad:** Moneda local  
**Interpretación:** Posición financiera internacional

### FM.AST.PRVT.GD.ZS
**Nombre:** Activos del sector privado (% PIB)  
**Definición:** Crédito al sector privado como % del PIB  
**Unidad:** Porcentaje del PIB  
**Interpretación:** Acceso a financiamiento privado

### FM.LBL.BMNY.GD.ZS
**Nombre:** Base monetaria (% PIB)  
**Definición:** Dinero de alta potencia como % del PIB  
**Unidad:** Porcentaje del PIB  
**Interpretación:** Liquidez de la economía

### FS.AST.CGOV.GD.ZS
**Nombre:** Crédito al gobierno central (% PIB)  
**Definición:** Crédito bancario al gobierno como % del PIB  
**Unidad:** Porcentaje del PIB  
**Interpretación:** Financiamiento del déficit fiscal

### FS.AST.PRVT.GD.ZS
**Nombre:** Crédito al sector privado por bancos (% PIB)  
**Definición:** Crédito bancario al sector privado como % del PIB  
**Unidad:** Porcentaje del PIB  
**Interpretación:** Inclusión financiera

---

## Variables de Reservas Internacionales (FI.*)

### FI.RES.TOTL.CD
**Nombre:** Reservas internacionales totales  
**Definición:** Reservas de divisas (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Capacidad de intervención cambiaria y solvencia externa

### FI.RES.TOTL.MO
**Nombre:** Reservas en meses de importaciones  
**Definición:** Reservas expresadas en meses de importaciones  
**Unidad:** Meses  
**Interpretación:** Suficiencia de reservas, estabilidad macroeconómica

### FI.RES.XGLD.CD
**Nombre:** Reservas excluyendo oro  
**Definición:** Reservas sin incluir oro (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Liquidez internacional efectiva

---

## Variables de Inflación y Precios (FP.*)

### FP.CPI.TOTL
**Nombre:** Índice de precios al consumidor (IPC)  
**Definición:** IPC (año base 2010 = 100)  
**Unidad:** Índice  
**Interpretación:** Nivel general de precios

### FP.CPI.TOTL.ZG
**Nombre:** Tasa de inflación  
**Definición:** Variación anual del IPC (%)  
**Unidad:** Porcentaje  
**Interpretación:** **CRÍTICO:** Inflación afecta directamente el gasto de bolsillo real en salud

---

## Relevancia para Economía de la Salud

Las variables financieras son **CRUCIALES** para predecir gasto en salud:

1. **Inflación (FP.CPI.TOTL.ZG):** 
   - **Alta inflación → Mayor gasto nominal en salud**
   - Erosiona poder adquisitivo → familias gastan más en términos nominales
   - Variable probablemente MUY importante en el modelo

2. **Crédito al Sector Privado (FD.AST.PRVT.GD.ZS, FS.AST.PRVT.GD.ZS):**
   - Acceso a crédito permite financiar gastos médicos inesperados
   - Mayor inclusión financiera → menor gasto de bolsillo como % del total
   - Familias pueden diferir pagos médicos

3. **Reservas Internacionales (FI.RES.TOTL.CD, FI.RES.TOTL.MO):**
   - Estabilidad macroeconómica → menor volatilidad en costos de salud
   - Capacidad de importar medicamentos y equipos médicos
   - Bajas reservas → crisis → mayor gasto de bolsillo

4. **Base Monetaria (FM.LBL.BMNY.GD.ZS):**
   - Política monetaria expansiva → inflación → aumento nominal de gastos

**Contexto COVID-19:**
- 2020-2021: Políticas monetarias expansivas globales
- Aumento de crédito para emergencia sanitaria
- Caída de reservas internacionales en muchos países
- Presiones inflacionarias post-pandemia (2021-2022)

**Variables ALTAMENTE importantes:**
- **FP.CPI.TOTL.ZG** (inflación → gasto nominal)
- **FD.AST.PRVT.GD.ZS** (crédito → capacidad de pago)
- **FI.RES.TOTL.MO** (estabilidad → predictibilidad de costos)

**Nota para Feature Engineering:**
- **Lag de inflación:** Inflación rezagada puede predecir ajustes de precios en salud
- **Volatilidad de inflación:** Desviación estándar de inflación 3-5 años
- **Crisis de reservas:** Dummy cuando reservas < 3 meses importaciones
- **Boom de crédito:** Cambio abrupto en crédito/PIB
- **Interacción inflación × COVID:** Efecto amplificado en 2020-2021
